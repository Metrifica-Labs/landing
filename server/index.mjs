// API da landing (leads do /contato + cases da home). Substitui o Supabase.
// Node 24, sem dependências: http nativo + node:sqlite.
import { createServer } from 'node:http';
import { randomUUID } from 'node:crypto';
import { DatabaseSync } from 'node:sqlite';

const PORT = Number(process.env.PORT ?? 8080);
const DB_PATH = process.env.DB_PATH ?? '/data/landing.db';
const BASE = '/landing';
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS ??
  'https://labs.metrifica.com.br,https://metrifica.com.br,https://www.metrifica.com.br')
  .split(',').map((o) => o.trim()).filter(Boolean);
const MAX_BODY = 64 * 1024;

const db = new DatabaseSync(DB_PATH);
db.exec(`
  pragma journal_mode = wal;
  create table if not exists leads (
    id text primary key,
    status text not null default 'partial' check (status in ('partial','completed')),
    current_step integer not null default 0,
    data text not null default '{}',
    notified_at text,
    created_at text not null default (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
    updated_at text not null default (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
  );
  create index if not exists leads_status_idx on leads (status);
  create table if not exists cases (
    id text primary key,
    name text not null,
    description text not null,
    category text not null,
    category_color text not null default '#2864E8',
    image_url text,
    images text not null default '[]',
    stack text not null default '[]',
    link text,
    "order" integer not null default 0,
    published integer not null default 0
  );
`);

const TEXT_FIELDS = [
  'name', 'phone', 'instagram', 'monthly_revenue', 'business_description',
  'consequence', 'previous_attempt', 'failed_attempt_details',
  'current_systems', 'ideal_system_solution', 'willing_to_invest',
];
const LIST_FIELDS = ['current_problems'];

function pickLead(body) {
  const data = {};
  for (const f of TEXT_FIELDS) {
    if (typeof body[f] === 'string') data[f] = body[f].trim().slice(0, 5000);
  }
  for (const f of LIST_FIELDS) {
    if (Array.isArray(body[f])) {
      data[f] = body[f].filter((v) => typeof v === 'string').slice(0, 30).map((v) => v.slice(0, 500));
    }
  }
  const status = body.status === 'completed' ? 'completed' : 'partial';
  const step = Number.isInteger(body.current_step) ? Math.max(0, Math.min(body.current_step, 100)) : 0;
  return { data, status, step };
}

// Limite simples por IP: 60 escritas por 10 min.
const hits = new Map();
function rateLimited(ip) {
  const now = Date.now();
  const recent = (hits.get(ip) ?? []).filter((t) => now - t < 10 * 60 * 1000);
  recent.push(now);
  hits.set(ip, recent);
  if (hits.size > 10000) hits.clear();
  return recent.length > 60;
}

async function notifyWhatsApp(id) {
  const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID;
  const token = process.env.WHATSAPP_TOKEN;
  const to = process.env.WHATSAPP_RECIPIENT_PHONE;
  const template = process.env.WHATSAPP_LEAD_TEMPLATE_NAME ?? 'novo_lead_metrifica';
  if (!phoneNumberId || !token || !to) return;

  const row = db.prepare('select * from leads where id = ? and notified_at is null').get(id);
  if (!row) return;
  const lead = JSON.parse(row.data);
  const text = (v) => (typeof v === 'string' && v.trim()) || 'Não informado';
  const list = (v) => (Array.isArray(v) && v.length ? v.join('; ') : 'Não informado');
  const createdAt = new Date(row.created_at).toLocaleString('pt-BR', { timeZone: 'America/Sao_Paulo' });

  // O template no Meta tem 17 parâmetros na ordem antiga; os campos que saíram
  // do formulário (e-mail, empresa, momento, por que a Metrifica) vão vazios.
  const params = [
    text(lead.name), text(lead.phone), 'Não informado', 'Não informado',
    text(lead.instagram), text(lead.monthly_revenue), 'Não informado',
    text(lead.business_description), list(lead.current_problems),
    text(lead.consequence), text(lead.previous_attempt),
    text(lead.failed_attempt_details), text(lead.current_systems),
    text(lead.ideal_system_solution), text(lead.willing_to_invest),
    'Não informado', createdAt,
  ].map((t) => ({ type: 'text', text: t }));

  const res = await fetch(`https://graph.facebook.com/v20.0/${phoneNumberId}/messages`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      messaging_product: 'whatsapp',
      to,
      type: 'template',
      template: { name: template, language: { code: 'pt_BR' }, components: [{ type: 'body', parameters: params }] },
    }),
  });
  if (!res.ok) {
    console.error('WhatsApp API error', res.status, await res.text());
    return;
  }
  db.prepare("update leads set notified_at = strftime('%Y-%m-%dT%H:%M:%fZ','now') where id = ?").run(id);
}

function send(res, status, body, origin) {
  const headers = { 'Content-Type': 'application/json; charset=utf-8', Vary: 'Origin' };
  if (origin && ALLOWED_ORIGINS.includes(origin)) {
    headers['Access-Control-Allow-Origin'] = origin;
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, OPTIONS';
    headers['Access-Control-Allow-Headers'] = 'Content-Type';
    headers['Access-Control-Max-Age'] = '86400';
  }
  res.writeHead(status, headers);
  res.end(body === undefined ? '' : JSON.stringify(body));
}

function readJson(req) {
  return new Promise((resolve, reject) => {
    let size = 0;
    const chunks = [];
    req.on('data', (c) => {
      size += c.length;
      if (size > MAX_BODY) { reject(new Error('too_large')); req.destroy(); return; }
      chunks.push(c);
    });
    req.on('end', () => {
      try { resolve(JSON.parse(Buffer.concat(chunks).toString('utf8') || '{}')); }
      catch { reject(new Error('bad_json')); }
    });
    req.on('error', reject);
  });
}

function listCases() {
  return db.prepare('select * from cases where published = 1 order by "order" asc').all()
    .map((c) => ({ ...c, images: JSON.parse(c.images), stack: JSON.parse(c.stack), published: true }));
}

const server = createServer(async (req, res) => {
  const origin = req.headers.origin;
  const ip = req.headers['x-real-ip'] ?? req.socket.remoteAddress ?? '';
  const url = new URL(req.url, 'http://x');
  const path = url.pathname.startsWith(BASE) ? url.pathname.slice(BASE.length) : url.pathname;

  try {
    if (req.method === 'OPTIONS') return send(res, 204, undefined, origin);
    if (req.method === 'GET' && path === '/health') return send(res, 200, { ok: true }, origin);
    if (req.method === 'GET' && path === '/cases') return send(res, 200, listCases(), origin);

    if (req.method === 'POST' && path === '/leads') {
      if (rateLimited(ip)) return send(res, 429, { error: 'rate_limited' }, origin);
      const { data, status, step } = pickLead(await readJson(req));
      const id = randomUUID();
      db.prepare('insert into leads (id, status, current_step, data) values (?, ?, ?, ?)')
        .run(id, status, step, JSON.stringify(data));
      if (status === 'completed') notifyWhatsApp(id).catch((e) => console.error(e));
      return send(res, 201, { id }, origin);
    }

    const m = path.match(/^\/leads\/([0-9a-f-]{36})$/);
    if (req.method === 'PATCH' && m) {
      if (rateLimited(ip)) return send(res, 429, { error: 'rate_limited' }, origin);
      const row = db.prepare('select status, data from leads where id = ?').get(m[1]);
      if (!row) return send(res, 404, { error: 'not_found' }, origin);
      const { data, status, step } = pickLead(await readJson(req));
      // Lead concluído não volta a parcial (o autosave do beforeunload chega depois do envio).
      const finalStatus = row.status === 'completed' ? 'completed' : status;
      const merged = { ...JSON.parse(row.data), ...data };
      db.prepare(`update leads set status = ?, current_step = max(current_step, ?), data = ?,
        updated_at = strftime('%Y-%m-%dT%H:%M:%fZ','now') where id = ?`)
        .run(finalStatus, step, JSON.stringify(merged), m[1]);
      if (finalStatus === 'completed') notifyWhatsApp(m[1]).catch((e) => console.error(e));
      return send(res, 200, { id: m[1] }, origin);
    }

    return send(res, 404, { error: 'not_found' }, origin);
  } catch (e) {
    if (e.message === 'too_large') return send(res, 413, { error: 'too_large' }, origin);
    if (e.message === 'bad_json') return send(res, 400, { error: 'bad_json' }, origin);
    console.error(e);
    return send(res, 500, { error: 'internal' }, origin);
  }
});

server.listen(PORT, () => console.log(`landing-api on :${PORT}, db ${DB_PATH}`));

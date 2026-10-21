import { useEffect, useState } from 'react';
import { useInView, useReducedMotion } from '../hooks';
import { look, sectorColor } from '../data/team';
import { PixelAvatar } from './PixelAvatar';
import { Panel } from './Panel';

type Status = 'novo' | 'fazendo' | 'pausado' | 'bloqueado' | 'em revisão' | 'feito';

interface Item {
  title: string;
  owner: string;
  sector: string;
  p: 'P1' | 'P2' | 'P3';
  est: string;
  status: Status;
}

const COLS = [
  { id: 'pedido', title: 'Pedido', note: 'vira item com dono, prioridade e estimativa' },
  { id: 'fazendo', title: 'Fazendo', note: 'o chefe planeja, divide e chama auxiliares' },
  { id: 'revisao', title: 'Revisão', note: 'chefe revisa, QA testa, Segurança aprova' },
  { id: 'deploy', title: 'Deploy', note: 'só vale conferido no ar, de fora' },
  { id: 'feito', title: 'Feito', note: 'você recebe o resumo com o print' },
] as const;

const OTHERS: Record<(typeof COLS)[number]['id'], Item[]> = {
  pedido: [
    { title: 'Bug no login', owner: 'Caio', sector: 'qa', p: 'P1', est: '2h', status: 'bloqueado' },
    { title: 'Relatório semanal', owner: 'Mel', sector: 'growth', p: 'P3', est: '1h', status: 'novo' },
  ],
  fazendo: [
    { title: 'Landing Black Friday', owner: 'Gael', sector: 'growth', p: 'P2', est: '8h', status: 'fazendo' },
    { title: 'Migração do banco', owner: 'Kai', sector: 'backend', p: 'P2', est: '5h', status: 'pausado' },
  ],
  revisao: [{ title: 'Novo onboarding', owner: 'Duda', sector: 'ui', p: 'P2', est: '4h', status: 'em revisão' }],
  deploy: [],
  feito: [
    { title: 'Webhook do ERP', owner: 'Bento', sector: 'backend', p: 'P1', est: '6h', status: 'feito' },
    { title: 'FAQ do Pix', owner: 'Sol', sector: 'suporte', p: 'P3', est: '1h', status: 'feito' },
  ],
};

const REVIEW = [
  { who: 'Lia', what: 'chefe revisou o código' },
  { who: 'Vera', what: 'QA testou no celular' },
  { who: 'Otto', what: 'Segurança aprovou o merge' },
];

// Ticks: 0 pedido, 1 fazendo, 2-4 review stamps, 5 deploy, 6-7 feito.
const TICKS = 8;
const colAt = (k: number) => (k <= 0 ? 0 : k === 1 ? 1 : k <= 4 ? 2 : k === 5 ? 3 : 4);
const STATUS_AT: Status[] = ['novo', 'fazendo', 'em revisão', 'em revisão', 'feito'];

const slug = (s: Status) => s.replace(' ', '-').replace('ã', 'a');

function Ticket({ it, hot, children }: { it: Item; hot?: boolean; children?: React.ReactNode }) {
  return (
    <article className={`ticket${hot ? ' is-hot' : ''}`} aria-label={hot ? 'Item que você pediu' : undefined}>
      <header>
        <strong>{it.title}</strong>
        <span className={`prio prio-${it.p}`}>{it.p}</span>
      </header>
      <footer>
        <span className="ticket-owner">
          <PixelAvatar shirt={sectorColor(it.sector)} size={12} {...look(it.owner)} /> {it.owner}
        </span>
        <span className="ticket-est">{it.est}</span>
        <span className={`status status-${slug(it.status)}`}>{it.status}</span>
      </footer>
      {children}
    </article>
  );
}

const WATCH = [
  { t: '14:00', text: 'todos andando', tone: '' },
  { t: '14:15', text: 'Rafa parado há 40 min · esperando a chave da API', tone: 'warn' },
  { t: '14:16', text: 'Leo pediu a chave ao Rui', tone: '' },
  { t: '14:18', text: 'Rafa destravado · voltou pro endpoint /pix', tone: 'ok' },
  { t: '14:30', text: 'todos andando', tone: '' },
];

export function Pipeline() {
  const reduced = useReducedMotion();
  const [ref, inView] = useInView<HTMLDivElement>('0px');
  const [k, setK] = useState(0);

  useEffect(() => {
    if (reduced) {
      setK(6);
      return;
    }
    if (!inView) return;
    const id = window.setInterval(() => setK((v) => (v + 1) % TICKS), 1600);
    return () => window.clearInterval(id);
  }, [inView, reduced]);

  const tick = Math.min(k, 6);
  const col = colAt(tick);
  const stamps = Math.max(0, Math.min(3, tick - 1));
  const hot: Item = { title: 'Checkout com Pix', owner: 'Lia', sector: 'frontend', p: 'P1', est: '6h', status: STATUS_AT[col] };
  const watchN = reduced ? WATCH.length : Math.min(WATCH.length, 2 + (k % 4));

  return (
    <section className="section pipeline" id="fluxo" aria-labelledby="pipe-title">
      <div className="wrap">
        <div className="split-head">
          <h2 id="pipe-title" className="h2">
            Do pedido ao deploy. Com prova.
          </h2>
          <p className="body">
            Todo pedido entra num quadro e anda sozinho, revisado em camadas. Você só aparece quando o time realmente
            depende de você.
          </p>
        </div>

        <Panel
          ref={ref}
          className="board-panel"
          title="quadro de demandas"
          meta="9 itens · 1 precisa de você"
          live
        >
          <div className="board" tabIndex={0} aria-label="Quadro com cinco colunas; role para os lados no celular">
            {COLS.map((c, i) => {
              const items = OTHERS[c.id];
              const here = i === col;
              return (
                <section key={c.id} className={`col${here ? ' is-here' : ''}`} aria-label={c.title}>
                  <header className="col-head">
                    <h3>{c.title}</h3>
                    <span className="col-count">{items.length + (here ? 1 : 0)}</span>
                  </header>
                  <p className="col-note">{c.note}</p>
                  <div className="col-items">
                    {here && (
                      <Ticket it={hot} hot key={`hot-${c.id}`}>
                        {c.id === 'revisao' && (
                          <ul className="stamps">
                            {REVIEW.map((r, j) => (
                              <li key={r.who} className={j < stamps ? 'ok' : ''}>
                                <span className="stamp-box" aria-hidden="true" />
                                <strong>{r.who}</strong> {r.what}
                              </li>
                            ))}
                          </ul>
                        )}
                        {(c.id === 'deploy' || c.id === 'feito') && (
                          <div className="proof">
                            <div className="proof-shot" aria-hidden="true">
                              <span className="proof-url">loja.com.br/checkout</span>
                              <span className="proof-qr" />
                            </div>
                            <p className="mono">
                              <span className="ok-dot" aria-hidden="true" /> v1.8.2 no ar · conferido de fora
                            </p>
                          </div>
                        )}
                      </Ticket>
                    )}
                    {items.map((it) => (
                      <Ticket key={it.title} it={it} />
                    ))}
                  </div>
                </section>
              );
            })}
          </div>
        </Panel>

        <div className="pipe-aside">
          <Panel title="pendências do dono" meta="só o que depende de você" className="pending-panel">
            <ul className="pending">
              <li>
                <span className="pending-time">2 min</span>
                <span>
                  <strong>Escolher o texto do checkout</strong>
                  <em>Iris deixou a versão A e a B</em>
                </span>
              </li>
              <li>
                <span className="pending-time">5 min</span>
                <span>
                  <strong>Liberar o token novo do login</strong>
                  <em>Caio está bloqueado esperando</em>
                </span>
              </li>
            </ul>
          </Panel>
          <Panel title="vigia" meta="o gestor confere a cada 15 min" className="watch-panel">
            <ol className="watch mono" aria-live="off">
              {WATCH.slice(0, watchN).map((w, i) => (
                <li key={i} className={w.tone ? `w-${w.tone}` : ''}>
                  <time>{w.t}</time> {w.text}
                </li>
              ))}
            </ol>
          </Panel>
        </div>
      </div>
    </section>
  );
}

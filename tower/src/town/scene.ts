// Town simulation: rooms, furniture and agents on an isometric tile grid.
// Pure data + tick logic; rendering lives in draw.ts.

export const GW = 22;
export const GH = 14;

export type SectorId =
  | 'backend'
  | 'frontend'
  | 'ui'
  | 'gestao'
  | 'qa'
  | 'seguranca'
  | 'infra'
  | 'copa'
  | 'growth'
  | 'suporte'
  | 'arquiteto'
  | 'recepcao';

export interface Room {
  id: SectorId;
  label: string;
  x: number;
  y: number;
  w: number;
  h: number;
  floor: [string, string];
}

export interface Pt {
  x: number;
  y: number;
}

export interface Desk {
  x: number;
  y: number;
  w: number;
  chief: boolean;
  ownerId: string;
}

export type AgentState = 'working' | 'walking' | 'break' | 'summoned' | 'helping';

export interface Agent {
  id: string;
  name: string;
  role: string;
  sector: SectorId;
  chief: boolean;
  helper: boolean;
  shirt: string;
  hair: string;
  skin: string;
  seat: Pt;
  pos: Pt;
  path: Pt[];
  state: AgentState;
  /** State to enter once the current path is walked. */
  next: AgentState;
  timer: number;
  bubble: { text: string; t: number } | null;
  phase: number;
  gone: boolean;
}

const FLOOR: Record<SectorId, [string, string]> = {
  backend: ['#1b2a4a', '#1f3053'],
  frontend: ['#1c2b48', '#213252'],
  ui: ['#24254a', '#292a53'],
  gestao: ['#2a2540', '#302a48'],
  qa: ['#1a2d42', '#1e334a'],
  seguranca: ['#2a2238', '#302741'],
  infra: ['#1c2a3f', '#213047'],
  copa: ['#3a2f22', '#433626'],
  growth: ['#1d2c3c', '#223244'],
  suporte: ['#1f2a44', '#24304c'],
  arquiteto: ['#272a44', '#2d304d'],
  recepcao: ['#3a3020', '#443823'],
};

const ROOM_DEFS: [SectorId, string, number, number, number, number][] = [
  ['backend', 'BACKEND', 0, 0, 6, 5],
  ['frontend', 'FRONTEND', 6, 0, 6, 5],
  ['ui', 'UI · UX', 12, 0, 6, 5],
  ['gestao', 'GESTÃO', 18, 0, 4, 5],
  ['qa', 'QA', 0, 5, 6, 5],
  ['seguranca', 'SEGURANÇA', 6, 5, 6, 5],
  ['infra', 'INFRA', 12, 5, 6, 5],
  ['copa', 'COPA', 18, 5, 4, 5],
  ['growth', 'GROWTH', 0, 10, 6, 4],
  ['suporte', 'SUPORTE', 6, 10, 6, 4],
  ['arquiteto', 'ARQUITETO', 12, 10, 6, 4],
  ['recepcao', 'RECEPÇÃO', 18, 10, 4, 4],
];

export const ROOMS: Room[] = ROOM_DEFS.map(([id, label, x, y, w, h]) => ({
  id,
  label,
  x,
  y,
  w,
  h,
  floor: FLOOR[id],
}));

const SHIRT: Partial<Record<SectorId, string>> = {
  backend: '#3d7bff',
  frontend: '#38b6ff',
  ui: '#8b7bff',
  qa: '#3fd39a',
  seguranca: '#ff6b6b',
  infra: '#9aa7c7',
  growth: '#ff9f43',
  suporte: '#5ad1e6',
  arquiteto: '#c58bff',
  gestao: '#e8edf8',
};

const HAIRS = ['#2b1d16', '#5a3a22', '#141414', '#c9a26b', '#7a2e1d', '#3b3b4f'];
const SKINS = ['#f2c9a0', '#d9a679', '#a9714b', '#7a4a2e', '#f5d6b8'];

interface Staff {
  sector: SectorId;
  chief: [string, string];
  members: [string, string][];
}

const STAFF: Staff[] = [
  { sector: 'backend', chief: ['Bento', 'Chefe de Backend'], members: [['Rafa', 'Backend'], ['Kai', 'Backend']] },
  { sector: 'frontend', chief: ['Lia', 'Chefe de Frontend'], members: [['Teo', 'Frontend'], ['Nina', 'Frontend']] },
  { sector: 'ui', chief: ['Iris', 'Chefe de UI'], members: [['Uri', 'UX'], ['Duda', 'UI']] },
  { sector: 'qa', chief: ['Vera', 'Chefe de QA'], members: [['Caio', 'QA'], ['Juno', 'QA']] },
  { sector: 'seguranca', chief: ['Otto', 'Chefe de Segurança'], members: [['Zara', 'Segurança']] },
  { sector: 'infra', chief: ['Rui', 'Chefe de Infra'], members: [['Ana', 'Infra']] },
  { sector: 'growth', chief: ['Gael', 'Chefe de Growth'], members: [['Mel', 'Growth']] },
  { sector: 'suporte', chief: ['Sol', 'Chefe de Suporte'], members: [['Dani', 'Suporte']] },
  { sector: 'arquiteto', chief: ['Hugo', 'Arquiteto'], members: [['Pia', 'Simulação de clientes']] },
];

export const BUBBLES: Partial<Record<SectorId, string[]>> = {
  backend: ['PR #214 pronto', 'migração ok', 'endpoint no ar?', 'teste verde'],
  frontend: ['tela de checkout ok', 'pede revisão', 'build passou'],
  ui: ['ajustei o contraste', 'variante B pronta', 'grid 8pt'],
  qa: ['achei um bug', 'E2E passou', 'testei no celular'],
  seguranca: ['PR aprovado', 'segredo fora do chat', 'bloqueei o merge'],
  infra: ['deploy conferido', 'versão nova no ar', 'log limpo'],
  growth: ['campanha subiu', 'CTR +12%', 'novo teste A/B'],
  suporte: ['cliente respondido', 'ticket fechado'],
  arquiteto: ['sala nova montada', 'luz da copa ok'],
  gestao: ['quem tá parado?', 'destravei o Rafa', 'resumo pro dono'],
};

export interface Furniture {
  fridgeOpen: boolean;
  coffeeUntil: number;
  gateOpen: boolean;
}

export interface World {
  agents: Agent[];
  desks: Desk[];
  furniture: Furniture;
  owner: Pt;
  time: number;
  nextHelper: number;
  helperSeq: number;
  rand: () => number;
}

export const COFFEE: Pt = { x: 20.5, y: 6.6 };
export const FRIDGE: Pt = { x: 21, y: 5 };
export const COFFEE_MACHINE: Pt = { x: 19.6, y: 5 };
export const GATE: Pt = { x: 19, y: 13 };
export const OWNER: Pt = { x: 19.7, y: 12.6 };
const GATE_IN: Pt = { x: 19.9, y: 13.4 };

function mulberry32(seed: number) {
  let a = seed;
  return () => {
    a |= 0;
    a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function room(id: SectorId): Room {
  return ROOMS.find((r) => r.id === id)!;
}

function makeAgent(
  id: string,
  name: string,
  role: string,
  sector: SectorId,
  chief: boolean,
  seat: Pt,
  rand: () => number,
): Agent {
  return {
    id,
    name,
    role,
    sector,
    chief,
    helper: false,
    shirt: SHIRT[sector] ?? '#7f8db0',
    hair: HAIRS[Math.floor(rand() * HAIRS.length)],
    skin: SKINS[Math.floor(rand() * SKINS.length)],
    seat,
    pos: { ...seat },
    path: [],
    state: 'working',
    next: 'working',
    timer: 4 + rand() * 18,
    bubble: null,
    phase: rand() * Math.PI * 2,
    gone: false,
  };
}

export function createWorld(seed = 7): World {
  const rand = mulberry32(seed);
  const agents: Agent[] = [];
  const desks: Desk[] = [];

  for (const s of STAFF) {
    const r = room(s.sector);
    const chiefDesk = { x: r.x + 2, y: r.y + r.h - 2 };
    const id = `${s.sector}-chief`;
    desks.push({ ...chiefDesk, w: 2, chief: true, ownerId: id });
    agents.push(
      makeAgent(id, s.chief[0], s.chief[1], s.sector, true, { x: chiefDesk.x + 1, y: chiefDesk.y + 1.15 }, rand),
    );
    s.members.forEach(([name, role], i) => {
      const d = { x: r.x + 1 + i * 2.6, y: r.y + 1 };
      const mid = `${s.sector}-${i}`;
      desks.push({ ...d, w: 1, chief: false, ownerId: mid });
      agents.push(makeAgent(mid, name, role, s.sector, false, { x: d.x + 0.5, y: d.y + 1.15 }, rand));
    });
  }

  const g = room('gestao');
  desks.push({ x: g.x + 1, y: g.y + 2, w: 2, chief: true, ownerId: 'gestor' });
  agents.push(makeAgent('gestor', 'Leo', 'Gestor', 'gestao', true, { x: g.x + 2, y: g.y + 3.15 }, rand));

  return {
    agents,
    desks,
    furniture: { fridgeOpen: false, coffeeUntil: 0, gateOpen: false },
    owner: OWNER,
    time: 0,
    nextHelper: 6,
    helperSeq: 0,
    rand,
  };
}

/** L-shaped route: along x first, then y, so agents read as walking the grid. */
function route(from: Pt, to: Pt): Pt[] {
  return [{ x: to.x, y: from.y }, { ...to }];
}

function say(a: Agent, world: World, text?: string) {
  const pool = BUBBLES[a.sector] ?? ['ok'];
  a.bubble = { text: text ?? pool[Math.floor(world.rand() * pool.length)], t: 3.2 };
}

function walkers(world: World) {
  return world.agents.filter((a) => a.state === 'walking').length;
}

export function summonSlot(world: World): Pt {
  return { x: world.owner.x + 0.9, y: world.owner.y - 0.4 };
}

export function summon(world: World, id: string) {
  const a = world.agents.find((x) => x.id === id && !x.gone);
  if (!a) return;
  const slot = summonSlot(world);
  a.path = route(a.pos, slot);
  a.state = 'walking';
  a.next = 'summoned';
  a.bubble = { text: 'indo!', t: 1.6 };
}

export function toggleFridge(world: World) {
  world.furniture.fridgeOpen = !world.furniture.fridgeOpen;
}

export function brewCoffee(world: World) {
  world.furniture.coffeeUntil = world.time + 4;
}

export function toggleGate(world: World) {
  world.furniture.gateOpen = !world.furniture.gateOpen;
}

function spawnHelper(world: World) {
  const host = world.agents.filter((a) => a.chief && !a.helper && a.sector !== 'gestao');
  const chief = host[Math.floor(world.rand() * host.length)];
  const r = room(chief.sector);
  const seq = ++world.helperSeq;
  const spot = { x: r.x + r.w - 1.2, y: r.y + r.h - 1.4 };
  const h = makeAgent(`aux-${seq}`, `Aux ${seq}`, `Auxiliar de ${chief.role.replace('Chefe de ', '')}`, chief.sector, false, spot, world.rand);
  h.helper = true;
  h.pos = { ...GATE_IN };
  h.path = route(GATE_IN, spot);
  h.state = 'walking';
  h.next = 'helping';
  h.timer = 14 + world.rand() * 6;
  world.furniture.gateOpen = true;
  world.agents.push(h);
  say(chief, world, 'contratei um auxiliar');
}

const SPEED = 2.4; // tiles per second

export function tick(world: World, dt: number) {
  world.time += dt;

  if (world.time > world.nextHelper) {
    if (world.agents.filter((a) => a.helper && !a.gone).length < 2) spawnHelper(world);
    world.nextHelper = world.time + 16 + world.rand() * 10;
  }

  for (const a of world.agents) {
    if (a.gone) continue;
    if (a.bubble) {
      a.bubble.t -= dt;
      if (a.bubble.t <= 0) a.bubble = null;
    }

    if (a.state === 'walking') {
      const target = a.path[0];
      if (!target) {
        a.state = a.next;
        continue;
      }
      const dx = target.x - a.pos.x;
      const dy = target.y - a.pos.y;
      const dist = Math.hypot(dx, dy);
      const step = (a.next === 'summoned' ? SPEED * 1.8 : SPEED) * dt;
      if (dist <= step) {
        a.pos = { ...target };
        a.path.shift();
        if (a.path.length === 0) arrive(world, a);
      } else {
        a.pos = { x: a.pos.x + (dx / dist) * step, y: a.pos.y + (dy / dist) * step };
      }
      continue;
    }

    a.timer -= dt;
    if (a.timer > 0) continue;

    switch (a.state) {
      case 'working': {
        if (!a.chief && walkers(world) < 3 && world.rand() < 0.4) {
          a.path = route(a.pos, { x: COFFEE.x - world.rand() * 1.4, y: COFFEE.y + world.rand() * 1.6 });
          a.state = 'walking';
          a.next = 'break';
        } else {
          if (world.rand() < 0.55) say(a, world);
          a.timer = 6 + world.rand() * 14;
        }
        break;
      }
      case 'break':
      case 'summoned':
        a.path = route(a.pos, a.seat);
        a.state = 'walking';
        a.next = 'working';
        break;
      case 'helping':
        a.path = route(a.pos, GATE_IN);
        a.state = 'walking';
        a.next = 'working';
        a.seat = GATE_IN;
        world.furniture.gateOpen = true;
        break;
    }
  }

  world.agents = world.agents.filter((a) => !a.gone);
}

function arrive(world: World, a: Agent) {
  a.state = a.next;
  if (a.helper && a.next === 'working') {
    a.gone = true;
    world.furniture.gateOpen = false;
    return;
  }
  if (a.helper && a.next === 'helping') {
    world.furniture.gateOpen = false;
    say(a, world, 'pego a parte 2');
    return;
  }
  if (a.state === 'break') {
    a.timer = 3 + world.rand() * 4;
    if (world.rand() < 0.5) brewCoffee(world);
  } else if (a.state === 'summoned') {
    a.timer = 6;
    a.bubble = { text: 'cheguei. manda.', t: 4 };
  } else {
    a.timer = 8 + world.rand() * 16;
  }
}

export function stats(world: World) {
  let working = 0;
  let free = 0;
  let helpers = 0;
  for (const a of world.agents) {
    if (a.helper) helpers++;
    else if (a.state === 'working') working++;
    else free++;
  }
  return { working, free, helpers, total: world.agents.length };
}

import { useEffect, useMemo, useRef, useState } from 'react';
import { useReducedMotion } from '../hooks';
import { Panel } from './Panel';

type Kind = 'regra' | 'decisao' | 'licao' | 'estrategia';
type TaskId = 'pix' | 'bf';

interface Mem {
  id: string;
  short: string;
  label: string;
  kind: Kind;
  w: number;
  tags: TaskId[];
  locked?: boolean;
  archived?: boolean;
  mergedInto?: string;
  absorbed?: number;
  fresh?: boolean;
}

const INITIAL: Mem[] = [
  { id: 'r1', short: 'prova de fora', label: 'Deploy só vale com a versão nova conferida no ar, de fora.', kind: 'regra', w: 1, tags: ['pix', 'bf'], locked: true },
  { id: 'r2', short: 'ok escrito', label: 'Ação irreversível só com confirmação escrita do dono.', kind: 'regra', w: 1, tags: ['pix', 'bf'], locked: true },
  { id: 'd2', short: 'texto curto', label: 'O dono prefere texto curto no checkout.', kind: 'decisao', w: 0.7, tags: ['pix', 'bf'] },
  { id: 'd1', short: 'QR expira', label: 'O QR do Pix expira em 15 minutos: mostrar o tempo na tela.', kind: 'decisao', w: 0.55, tags: ['pix'] },
  { id: 's1', short: 'botão = ação', label: 'Botão primário diz a ação: “Pagar com Pix”.', kind: 'estrategia', w: 0.5, tags: ['pix'] },
  { id: 'l1', short: 'CPF antes', label: 'Validar o CPF antes de gerar o QR.', kind: 'licao', w: 0.45, tags: ['pix'] },
  { id: 'l2', short: 'CPF no início', label: 'Checar o CPF logo no início do fluxo.', kind: 'licao', w: 0.35, tags: ['pix'] },
  { id: 'l3', short: 'E2E no celular', label: 'O teste no celular falhou duas vezes: viewport de desktop não pega o bug.', kind: 'licao', w: 0.4, tags: ['pix'] },
  { id: 'd3', short: 'cupom no carrinho', label: 'Black Friday: cupom só aparece no carrinho.', kind: 'decisao', w: 0.5, tags: ['bf'] },
  { id: 's2', short: 'prova social', label: 'Landing: prova social logo abaixo do hero.', kind: 'estrategia', w: 0.45, tags: ['bf'] },
  { id: 'l4', short: 'vigia na sexta', label: 'Deploy de sexta precisa de vigia extra.', kind: 'licao', w: 0.4, tags: ['bf'] },
  { id: 'o1', short: 'fonte do e-mail', label: 'Usar a fonte X nos e-mails.', kind: 'decisao', w: 0.2, tags: [] },
];

// Links between memories; a linked memory comes along as a neighbour.
const EDGES: [string, string][] = [
  ['d1', 'l1'],
  ['d1', 'l2'],
  ['s1', 'd2'],
  ['d1', 's1'],
  ['r1', 'l4'],
  ['d3', 's2'],
  ['d2', 's2'],
  ['l3', 'd1'],
  ['l4', 'd3'],
  ['o1', 'd2'],
];

const TASKS: { id: TaskId; label: string; who: string; p: string }[] = [
  { id: 'pix', label: 'Checkout com Pix', who: 'Lia · Frontend', p: 'P1' },
  { id: 'bf', label: 'Landing Black Friday', who: 'Gael · Growth', p: 'P2' },
];

const KIND_LABEL: Record<Kind, string> = {
  regra: 'regra fixa',
  decisao: 'decisão',
  licao: 'lição',
  estrategia: 'estratégia',
};

const clamp = (v: number) => Math.max(0.1, Math.min(1, v));

type LaneId = 'fixas' | 'ligadas' | 'vizinhas' | 'fora' | 'arquivadas';
const LANES: { id: LaneId; title: string; note: string }[] = [
  { id: 'fixas', title: 'Fixas', note: 'suas regras e as de segurança: entram sempre e nunca são esquecidas' },
  { id: 'ligadas', title: 'Ligadas a esta tarefa', note: 'entram no contexto do agente' },
  { id: 'vizinhas', title: 'Vizinhas', note: 'ligadas às de cima, vêm junto' },
  { id: 'fora', title: 'Fora desta tarefa', note: 'guardadas, sem pesar no contexto' },
  { id: 'arquivadas', title: 'Arquivadas', note: 'sem uso ou erradas: saem de cena, nunca somem de vez' },
];

function Meter({ w, locked }: { w: number; locked?: boolean }) {
  const on = Math.round(w * 10);
  return (
    <span
      className={`meter${locked ? ' is-locked' : ''}`}
      role="img"
      aria-label={locked ? 'fixa, peso máximo' : `peso ${Math.round(w * 100)} de 100`}
    >
      {Array.from({ length: 10 }, (_, i) => (
        <i key={i} className={i < on ? 'on' : ''} />
      ))}
    </span>
  );
}

export function Brain() {
  const reduced = useReducedMotion();
  const [mems, setMems] = useState<Mem[]>(INITIAL);
  const [extra, setExtra] = useState<[string, string][]>([]);
  const [task, setTask] = useState<TaskId>('pix');
  const [dream, setDream] = useState<string[]>([]);
  const [dreaming, setDreaming] = useState(false);
  const [deltas, setDeltas] = useState<Record<string, number>>({});
  const timers = useRef<number[]>([]);

  useEffect(() => () => timers.current.forEach((t) => window.clearTimeout(t)), []);

  const byId = useMemo(() => Object.fromEntries(mems.map((m) => [m.id, m])), [mems]);
  const resolve = (id: string): Mem => {
    const m = byId[id];
    return m?.mergedInto ? resolve(m.mergedInto) : m;
  };

  const live = mems.filter((m) => !m.mergedInto);
  const direct = new Set(live.filter((m) => !m.archived && !m.locked && m.tags.includes(task)).map((m) => m.id));
  const near = new Set<string>();
  for (const [a, b] of [...EDGES, ...extra]) {
    const A = resolve(a);
    const B = resolve(b);
    if (!A || !B) continue;
    if (direct.has(A.id) && !direct.has(B.id) && !B.archived && !B.locked) near.add(B.id);
    if (direct.has(B.id) && !direct.has(A.id) && !A.archived && !A.locked) near.add(A.id);
  }

  const laneOf = (m: Mem): LaneId =>
    m.locked ? 'fixas' : m.archived ? 'arquivadas' : direct.has(m.id) ? 'ligadas' : near.has(m.id) ? 'vizinhas' : 'fora';

  const lanes = LANES.map((l) => ({
    ...l,
    items: live.filter((m) => laneOf(m) === l.id).sort((a, b) => b.w - a.w),
  }));
  const pulled = lanes.filter((l) => l.id !== 'fora' && l.id !== 'arquivadas').reduce((s, l) => s + l.items.length, 0);

  const nudge = (dir: 1 | -1) => {
    const d: Record<string, number> = {};
    setMems((ms) =>
      ms.map((m) => {
        if (!direct.has(m.id)) return m;
        const w = clamp(m.w + (dir > 0 ? 0.2 : -0.25));
        d[m.id] = Math.round((w - m.w) * 100);
        return { ...m, w, archived: w <= 0.12 };
      }),
    );
    setDeltas(d);
    timers.current.push(window.setTimeout(() => setDeltas({}), 1800));
  };

  const runDream = () => {
    if (dreaming) return;
    setDreaming(true);
    setDream([]);
    const steps: [string, () => void][] = [
      [
        'juntou duas lições repetidas sobre o CPF em uma só, mais forte',
        () =>
          setMems((ms) => {
            const a = ms.find((m) => m.id === 'l1')!;
            const b = ms.find((m) => m.id === 'l2')!;
            if (b.mergedInto || b.archived) return ms;
            return ms.map((m) =>
              m.id === 'l1'
                ? { ...m, w: clamp(a.w + b.w * 0.6), absorbed: 2, label: 'Validar o CPF no início, antes de gerar o QR.' }
                : m.id === 'l2'
                  ? { ...m, mergedInto: 'l1' }
                  : m,
            );
          }),
      ],
      [
        'ligou “botão = ação” a “prova social”: as duas falam de clareza',
        () => setExtra((e) => (e.some(([x, y]) => x === 's1' && y === 's2') ? e : [...e, ['s1', 's2']])),
      ],
      [
        'arquivou “fonte do e-mail”: 30 dias sem uso (continua guardada)',
        () => setMems((ms) => ms.map((m) => (m.id === 'o1' ? { ...m, archived: true, w: 0.1 } : m))),
      ],
      [
        'o teste no celular falhou duas vezes: propôs uma estratégia nova',
        () =>
          setMems((ms) =>
            ms.some((m) => m.id === 'n1')
              ? ms
              : [
                  ...ms,
                  {
                    id: 'n1',
                    short: 'celular primeiro',
                    label: 'O QA testa primeiro no celular real, depois no desktop.',
                    kind: 'estrategia',
                    w: 0.4,
                    tags: ['pix'],
                    fresh: true,
                  },
                ],
          ),
      ],
      ['regras do dono e de segurança: intactas', () => undefined],
    ];
    const gap = reduced ? 0 : 900;
    steps.forEach(([text, fn], i) => {
      timers.current.push(
        window.setTimeout(() => {
          fn();
          setDream((d) => [...d, text]);
          if (i === steps.length - 1) setDreaming(false);
        }, gap * (i + 1)),
      );
    });
  };

  const reset = () => {
    timers.current.forEach((t) => window.clearTimeout(t));
    timers.current = [];
    setMems(INITIAL);
    setExtra([]);
    setDream([]);
    setDeltas({});
    setDreaming(false);
  };

  const t = TASKS.find((x) => x.id === task)!;

  return (
    <section className="section brain" id="cerebro" aria-labelledby="brain-title">
      <div className="wrap">
        <div className="split-head">
          <h2 id="brain-title" className="h2">
            Um cérebro que aprende com <span className="you-text">você</span>.
          </h2>
          <p className="body">
            Cada agente tem um cérebro de memórias: decisões, regras e estratégias que deram certo no seu projeto. O que você
            aprova ganha força; o que foi reaberto perde. O modelo continua o mesmo. Quem evolui é a memória do time.
          </p>
        </div>

        <Panel
          className={`brain-panel${dreaming ? ' is-dreaming' : ''}`}
          title="cérebro do time"
          meta={`${live.filter((m) => !m.archived).length} memórias ativas · ${live.filter((m) => m.archived).length} arquivadas`}
        >
          <div className="recall">
            <aside className="recall-side">
              <p className="side-k">1 · escolha a tarefa</p>
              <div className="task-pick" role="group" aria-label="Tarefa atual">
                {TASKS.map((x) => (
                  <button key={x.id} type="button" aria-pressed={task === x.id} onClick={() => setTask(x.id)}>
                    <span className="tp-top">
                      <strong>{x.label}</strong>
                      <span className="prio">{x.p}</span>
                    </span>
                    <span className="tp-who">{x.who}</span>
                  </button>
                ))}
              </div>
              <p className="pull-count" aria-live="polite">
                <strong>{pulled}</strong> memórias entram em “{t.label}”
              </p>

              <p className="side-k">2 · dê o seu retorno</p>
              <div className="brain-actions">
                <button type="button" className="act act-up" onClick={() => nudge(1)}>
                  <span>Você aprovou a entrega</span>
                  <em>as ligadas ganham peso</em>
                </button>
                <button type="button" className="act act-down" onClick={() => nudge(-1)}>
                  <span>Você reabriu a tarefa</span>
                  <em>as ligadas perdem peso</em>
                </button>
              </div>

              <p className="side-k">3 · de madrugada</p>
              <button type="button" className="act act-dream" onClick={runDream} disabled={dreaming}>
                <span>{dreaming ? 'Sonhando…' : 'Rodar o sonho das 03:00'}</span>
                <em>junta, liga, arquiva e propõe</em>
              </button>
              {dream.length > 0 && (
                <ol className="dream-log mono" aria-live="polite">
                  {dream.map((d) => (
                    <li key={d}>{d}</li>
                  ))}
                </ol>
              )}
              <button type="button" className="link-btn" onClick={reset}>
                recomeçar
              </button>
            </aside>

            <div className="lanes" aria-live="polite">
              {lanes.map((l) => {
                if (l.id === 'arquivadas' && l.items.length === 0) return null;
                const compact = l.id === 'fora' || l.id === 'arquivadas';
                return (
                  <section key={l.id} className={`lane lane-${l.id}${compact ? ' is-compact' : ' is-pulled'}`}>
                    <header>
                      <h3>{l.title}</h3>
                      <span className="lane-count">{l.items.length}</span>
                      <p>{l.note}</p>
                    </header>
                    {l.items.length === 0 ? (
                      <p className="lane-empty">nenhuma agora</p>
                    ) : compact ? (
                      <ul className="chips">
                        {l.items.map((m) => (
                          <li key={m.id} title={m.label}>
                            {m.short}
                          </li>
                        ))}
                      </ul>
                    ) : (
                      <ul className="rows">
                        {l.items.map((m) => (
                          <li key={`${l.id}-${m.id}`} className={`row${m.fresh ? ' is-fresh' : ''}`}>
                            <span className={`kind kind-${m.kind}`}>{KIND_LABEL[m.kind]}</span>
                            <span className="row-label">
                              {m.label}
                              {m.absorbed && <span className="tag">juntou {m.absorbed}</span>}
                              {m.fresh && <span className="tag tag-new">nova</span>}
                            </span>
                            <Meter w={m.w} locked={m.locked} />
                            <span
                              className={`delta${deltas[m.id] ? (deltas[m.id] > 0 ? ' is-up' : ' is-down') : ''}`}
                              aria-hidden="true"
                            >
                              {deltas[m.id] ? `${deltas[m.id] > 0 ? '+' : ''}${deltas[m.id]}` : ''}
                            </span>
                          </li>
                        ))}
                      </ul>
                    )}
                  </section>
                );
              })}
            </div>
          </div>
        </Panel>
      </div>
    </section>
  );
}

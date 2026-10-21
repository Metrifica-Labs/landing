import { useEffect, useRef, useState } from 'react';
import { useInView, useReducedMotion, useSeen } from '../hooks';
import { GESTOR_SHIRT, OWNER_SHIRT, look, sectorColor } from '../data/team';
import { Sprite } from './PixelAvatar';
import { Panel } from './Panel';

type Mode = 'hoje' | 'tower';
type P = [number, number];

const WORK = [
  { label: 'Backend', id: 'backend' },
  { label: 'Frontend', id: 'frontend' },
  { label: 'UI · UX', id: 'ui' },
  { label: 'QA', id: 'qa' },
  { label: 'Segurança', id: 'seguranca' },
  { label: 'Infra', id: 'infra' },
  { label: 'Growth', id: 'growth' },
];

const COMPARE = [
  ['Quem distribui o trabalho', 'você, um pedido por vez', 'o gestor, pelo quadro'],
  ['Quem revisa', 'você, depois do expediente', 'o chefe, o QA e a Segurança'],
  ['Quem cobra quem está parado', 'você, quando lembra', 'o vigia, a cada 15 minutos'],
  ['Onde você entra', 'em tudo', 'no que só você decide'],
] as const;

// Narrow screens get their own portrait composition so labels stay legible.
const NARROW_SLOTS: P[] = [
  [62, 300],
  [180, 300],
  [298, 300],
  [62, 380],
  [180, 380],
  [298, 380],
  [180, 460],
];

function layout(mode: Mode, narrow: boolean): { owner: P; gestor: P; work: P[] } {
  const W = narrow ? 360 : 680;
  const H = narrow ? 520 : 400;
  if (mode === 'hoje') {
    const [rx, ry] = narrow ? [120, 200] : [250, 150];
    return {
      owner: [W / 2, H / 2],
      gestor: [W / 2, H / 2],
      work: WORK.map((_, i) => {
        const a = -Math.PI / 2 + (i / WORK.length) * Math.PI * 2;
        return [W / 2 + Math.cos(a) * rx, H / 2 + Math.sin(a) * ry];
      }),
    };
  }
  if (narrow) return { owner: [W / 2, 52], gestor: [W / 2, 176], work: NARROW_SLOTS };
  return {
    owner: [W / 2, 52],
    gestor: [W / 2, 166],
    work: WORK.map((_, i) => {
      const k = i / (WORK.length - 1);
      return [70 + k * (W - 140), i % 2 ? 350 : 280];
    }),
  };
}

const lerp = (a: P, b: P, t: number): P => [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t];
const ease = (t: number) => 1 - Math.pow(1 - t, 4);

export function Bottleneck() {
  const reduced = useReducedMotion();
  const [seenRef, seen] = useSeen<HTMLDivElement>(0.4);
  const [viewRef, inView] = useInView<HTMLDivElement>('0px');
  const [mode, setMode] = useState<Mode>('hoje');
  const [touched, setTouched] = useState(false);
  const [frame, setFrame] = useState({ t: 0, clock: 0 });
  const [narrow, setNarrow] = useState(false);
  const tRef = useRef(0);

  useEffect(() => {
    const el = viewRef.current;
    if (!el) return;
    const ro = new ResizeObserver(() => setNarrow(el.clientWidth < 560));
    ro.observe(el);
    return () => ro.disconnect();
  }, [viewRef]);

  useEffect(() => {
    if (!seen || touched) return;
    const id = window.setTimeout(() => setMode('tower'), 3200);
    return () => window.clearTimeout(id);
  }, [seen, touched]);

  useEffect(() => {
    const target = mode === 'tower' ? 1 : 0;
    if (reduced || !inView) {
      tRef.current = target;
      setFrame((f) => ({ ...f, t: target }));
      return;
    }
    let raf = 0;
    let last = performance.now();
    const loop = (now: number) => {
      const dt = Math.min(0.05, (now - last) / 1000);
      last = now;
      const dir = Math.sign(target - tRef.current);
      tRef.current = Math.max(0, Math.min(1, tRef.current + dir * dt * 0.9));
      setFrame((f) => ({ t: tRef.current, clock: f.clock + dt }));
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(raf);
  }, [mode, reduced, inView]);

  const t = ease(frame.t);
  const a = layout('hoje', narrow);
  const b = layout('tower', narrow);
  const W = narrow ? 360 : 680;
  const H = narrow ? 520 : 400;
  const owner = lerp(a.owner, b.owner, t);
  const gestor = lerp(a.gestor, b.gestor, t);
  const work = a.work.map((p, i) => lerp(p, b.work[i], t));

  // Before, every node talks only to the owner; after, the gestor routes work
  // and neighbours review each other.
  const edges: { from: P; to: P; kind: 'owner' | 'team' | 'approve' }[] = [];
  work.forEach((p) => edges.push({ from: p, to: t < 0.5 ? owner : gestor, kind: t < 0.5 ? 'owner' : 'team' }));
  if (t > 0.5) {
    for (let i = 0; i < work.length - 1; i++) edges.push({ from: work[i], to: work[i + 1], kind: 'team' });
    edges.push({ from: gestor, to: owner, kind: 'approve' });
  }

  const queue = Math.round(14 * (1 - t));
  const pick = (m: Mode) => {
    setTouched(true);
    setMode(m);
  };

  return (
    <section className="section gargalo" id="gargalo" aria-labelledby="gargalo-title">
      <div className="wrap">
        <div className="split-head">
          <h2 id="gargalo-title" className="h2">
            Se tudo passa por você, <span className="you-text">você</span> é o teto da empresa.
          </h2>
          <p className="body">
            Mandar prompt é fazer o trabalho com outra ferramenta. O salto é montar um time que roda sem você no meio e
            treinar esse time até ele entregar no seu nível.
          </p>
        </div>

        <div className="bottleneck" ref={seenRef}>
          <Panel
            className="bn-panel"
            title="fluxo de trabalho"
            meta={mode === 'hoje' ? 'hoje' : 'com a Tower'}
            actions={
              <span className="seg" role="group" aria-label="Comparar">
                <button type="button" aria-pressed={mode === 'hoje'} onClick={() => pick('hoje')}>
                  Hoje
                </button>
                <button type="button" aria-pressed={mode === 'tower'} onClick={() => pick('tower')}>
                  Com a Tower
                </button>
              </span>
            }
          >
            <div ref={viewRef} className={`bn-stage is-${mode}`}>
              <svg viewBox={`0 0 ${W} ${H}`} role="img" aria-labelledby="bn-desc">
                <desc id="bn-desc">
                  {mode === 'hoje'
                    ? 'Hoje: você no centro, ligado a cada setor. Tudo passa por você e a fila acumula.'
                    : 'Com a Tower: você no topo, ligado só ao gestor por uma aprovação. O gestor distribui e os setores revisam entre si.'}
                </desc>
                {edges.map((e, i) => (
                  <line
                    key={i}
                    x1={e.from[0]}
                    y1={e.from[1]}
                    x2={e.to[0]}
                    y2={e.to[1]}
                    className={`edge edge-${e.kind}`}
                  />
                ))}
                {!reduced &&
                  edges.map((e, i) => {
                    const k = (frame.clock * (e.kind === 'owner' ? 0.32 : 0.55) + i * 0.17) % 1;
                    const pt = lerp(e.from, e.to, k);
                    return (
                      <rect
                        key={`d${i}`}
                        x={pt[0] - 3}
                        y={pt[1] - 3}
                        width={6}
                        height={6}
                        className={`pkt pkt-${e.kind}`}
                      />
                    );
                  })}
                {work.map((p, i) => {
                  const w = narrow ? 100 : 108;
                  return (
                    <g key={WORK[i].id} transform={`translate(${p[0]} ${p[1]})`} className="node">
                      <rect x={-w / 2} y={-17} width={w} height={34} rx={5} />
                      <rect
                        x={-w / 2 + 10}
                        y={-4}
                        width={8}
                        height={8}
                        fill={sectorColor(WORK[i].id)}
                        className="node-swatch"
                      />
                      <text x={-w / 2 + 26} dy="0.35em">
                        {WORK[i].label}
                      </text>
                    </g>
                  );
                })}
                <g
                  transform={`translate(${gestor[0]} ${gestor[1]})`}
                  className="node node-gestor"
                  style={{ opacity: Math.max(0, (t - 0.25) / 0.75) }}
                >
                  <rect x={-66} y={-20} width={132} height={40} rx={6} />
                  <g transform="translate(-54 -12) scale(1.2)" shapeRendering="crispEdges">
                    <Sprite shirt={GESTOR_SHIRT} chief {...look('Leo')} />
                  </g>
                  <text x={-26} dy="0.35em">
                    Leo · Gestor
                  </text>
                </g>
                <g transform={`translate(${owner[0]} ${owner[1]})`} className="node node-owner">
                  {mode === 'hoje' && !reduced && <circle r={34} className="owner-ring" />}
                  <circle r={34} className="owner-disc" />
                  <g transform="translate(-12 -17) scale(1.5)" shapeRendering="crispEdges">
                    <Sprite shirt={OWNER_SHIRT} {...look('Você')} />
                  </g>
                  <text x={-46} dy="0.35em" textAnchor="end" className="owner-label">
                    Você
                  </text>
                  {queue > 0 && (
                    <g transform="translate(46 -30)" className="queue">
                      {Array.from({ length: Math.min(7, Math.ceil(queue / 2)) }, (_, k) => (
                        <rect key={k} x={k * 2} y={-k * 5} width={34} height={22} rx={3} />
                      ))}
                      <text x={52} y={6}>
                        {narrow ? `fila ${queue}` : `${queue} esperando você`}
                      </text>
                    </g>
                  )}
                  {t > 0.6 && (
                    <text className="approve-label" x={48} y={6} style={{ opacity: (t - 0.6) / 0.4 }}>
                      {narrow ? 'só aprova' : 'só aprova o que importa'}
                    </text>
                  )}
                </g>
              </svg>
            </div>
          </Panel>

          <table className={`compare is-${mode}`}>
            <caption className="sr-only">Hoje comparado com a Tower</caption>
            <thead>
              <tr>
                <th scope="col">
                  <span className="sr-only">Pergunta</span>
                </th>
                <th scope="col" className="c-hoje">
                  Hoje
                </th>
                <th scope="col" className="c-tower">
                  Com a Tower
                </th>
              </tr>
            </thead>
            <tbody>
              {COMPARE.map(([q, h, w]) => (
                <tr key={q}>
                  <th scope="row">{q}</th>
                  <td className="c-hoje">{h}</td>
                  <td className="c-tower">{w}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}

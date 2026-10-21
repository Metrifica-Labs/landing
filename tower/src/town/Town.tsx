import { useCallback, useEffect, useRef, useState } from 'react';
import { useInView, useReducedMotion } from '../hooks';
import { render, VIEW_H, VIEW_W, type Hit } from './draw';
import {
  brewCoffee,
  createWorld,
  stats,
  summon,
  summonSlot,
  tick,
  toggleFridge,
  toggleGate,
  type Agent,
  type World,
} from './scene';

export type TownStats = ReturnType<typeof stats>;

const STATE_LABEL: Record<Agent['state'], string> = {
  working: 'trabalhando',
  walking: 'andando pelo prédio',
  break: 'pegando café',
  summoned: 'com você',
  helping: 'auxiliar temporário',
};

interface Props {
  seed?: number;
  controls?: boolean;
  onStats?: (s: TownStats) => void;
  label: string;
}

interface Hover {
  kind: Hit['kind'];
  id?: string;
  x: number;
  y: number;
}

export function Town({ seed = 7, controls = false, onStats, label }: Props) {
  const [wrapRef, visible] = useInView<HTMLDivElement>();
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const worldRef = useRef<World>(createWorld(seed));
  const hitsRef = useRef<Hit[]>([]);
  const scaleRef = useRef(1);
  const buildRef = useRef(0);
  const hoverRef = useRef<string | null>(null);
  const reduced = useReducedMotion();
  const [hover, setHover] = useState<Hover | null>(null);
  const [fontsReady, setFontsReady] = useState(false);
  const [announce, setAnnounce] = useState('');
  const [summonId, setSummonId] = useState('backend-0');
  const [, force] = useState(0);

  useEffect(() => {
    document.fonts
      .load('600 9px "Pixelify Sans"')
      .catch(() => undefined)
      .finally(() => setFontsReady(true));
  }, []);

  // Fit the fixed logical scene to the container width, crisp on HiDPI.
  useEffect(() => {
    const wrap = wrapRef.current;
    const canvas = canvasRef.current;
    if (!wrap || !canvas) return;
    const ro = new ResizeObserver(() => {
      const cw = wrap.clientWidth;
      const dpr = Math.min(window.devicePixelRatio || 1, 2);
      const s = cw / VIEW_W;
      scaleRef.current = s;
      canvas.width = Math.round(cw * dpr);
      canvas.height = Math.round(VIEW_H * s * dpr);
      canvas.style.height = `${VIEW_H * s}px`;
      const ctx = canvas.getContext('2d');
      ctx?.setTransform(s * dpr, 0, 0, s * dpr, 0, 0);
      if (ctx) hitsRef.current = render(ctx, worldRef.current, { build: buildRef.current, hoverId: hoverRef.current });
    });
    ro.observe(wrap);
    return () => ro.disconnect();
  }, [wrapRef]);

  useEffect(() => {
    if (!fontsReady) return;
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext('2d');
    if (!ctx) return;
    if (reduced) buildRef.current = 1;

    const draw = () => {
      hitsRef.current = render(ctx, worldRef.current, { build: buildRef.current, hoverId: hoverRef.current });
    };
    if (!visible) {
      draw();
      return;
    }

    let raf = 0;
    let last = performance.now();
    let statAcc = 0;
    const loop = (now: number) => {
      const dt = Math.min(0.05, (now - last) / 1000);
      last = now;
      if (buildRef.current < 1) buildRef.current = Math.min(1, buildRef.current + dt / 1.3);
      else if (!reduced) tick(worldRef.current, dt);
      draw();
      statAcc += dt;
      if (onStats && statAcc > 0.5) {
        statAcc = 0;
        onStats(stats(worldRef.current));
      }
      raf = requestAnimationFrame(loop);
    };
    if (reduced) {
      draw();
      onStats?.(stats(worldRef.current));
      return;
    }
    raf = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(raf);
  }, [visible, reduced, fontsReady, onStats]);

  const redrawIfStill = useCallback(() => {
    if (!reduced) return;
    const ctx = canvasRef.current?.getContext('2d');
    if (ctx) hitsRef.current = render(ctx, worldRef.current, { build: 1, hoverId: hoverRef.current });
  }, [reduced]);

  const pick = (e: React.PointerEvent<HTMLCanvasElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const lx = (e.clientX - rect.left) / scaleRef.current;
    const ly = (e.clientY - rect.top) / scaleRef.current;
    const hits = hitsRef.current;
    for (let i = hits.length - 1; i >= 0; i--) {
      const h = hits[i];
      if (lx >= h.x && lx <= h.x + h.w && ly >= h.y && ly <= h.y + h.h) {
        return { hit: h, x: e.clientX - rect.left, y: e.clientY - rect.top };
      }
    }
    return null;
  };

  const act = (kind: Hit['kind'], id?: string) => {
    const w = worldRef.current;
    if (kind === 'fridge') {
      toggleFridge(w);
      setAnnounce(w.furniture.fridgeOpen ? 'Geladeira aberta.' : 'Geladeira fechada.');
    } else if (kind === 'coffee') {
      brewCoffee(w);
      setAnnounce('Café passando na copa.');
    } else if (kind === 'gate') {
      toggleGate(w);
      setAnnounce(w.furniture.gateOpen ? 'Portão aberto.' : 'Portão fechado.');
    } else if (kind === 'agent' && id) {
      callAgent(id);
    }
    redrawIfStill();
    force((n) => n + 1);
  };

  const callAgent = (id: string) => {
    const w = worldRef.current;
    const a = w.agents.find((x) => x.id === id);
    if (!a) return;
    summon(w, id);
    if (reduced) {
      a.pos = summonSlot(w);
      a.path = [];
      a.state = 'summoned';
      a.bubble = { text: 'cheguei. manda.', t: 4 };
    }
    setAnnounce(`${a.name} (${a.role}) está vindo até você.`);
    redrawIfStill();
  };

  const onMove = (e: React.PointerEvent<HTMLCanvasElement>) => {
    const r = pick(e);
    const key = r ? (r.hit.id ?? r.hit.kind) : null;
    hoverRef.current = r?.hit.kind === 'agent' || r?.hit.kind === 'owner' ? (r.hit.id ?? null) : null;
    e.currentTarget.style.cursor = r && r.hit.kind !== 'owner' ? 'pointer' : 'default';
    setHover((prev) => {
      if (!r) return null;
      if (prev && (prev.id ?? prev.kind) === key) return { ...prev, x: r.x, y: r.y };
      return { kind: r.hit.kind, id: r.hit.id, x: r.x, y: r.y };
    });
  };

  const hoveredAgent =
    hover?.kind === 'agent' ? worldRef.current.agents.find((a) => a.id === hover.id) : undefined;
  const tip =
    hover &&
    (hoveredAgent
      ? {
          title: hoveredAgent.name,
          body: `${hoveredAgent.role} · ${STATE_LABEL[hoveredAgent.state]}`,
          hint: hoveredAgent.helper ? 'Sai quando a tarefa acaba' : 'Clique: “vem até mim”',
        }
      : hover.kind === 'fridge'
        ? { title: 'Geladeira', body: 'Móvel interativo', hint: 'Clique para abrir' }
        : hover.kind === 'coffee'
          ? { title: 'Cafeteira', body: 'Móvel interativo', hint: 'Clique para passar um café' }
          : hover.kind === 'gate'
            ? { title: 'Portão', body: 'Entrada dos auxiliares', hint: 'Clique para abrir' }
            : hover.kind === 'owner'
              ? { title: 'Você', body: 'Dono · aprova e treina', hint: '' }
              : null);

  const agents = worldRef.current.agents.filter((a) => !a.helper);

  return (
    <div className="town">
      <div className="town-stage" ref={wrapRef}>
        <canvas
          ref={canvasRef}
          role="img"
          aria-label={label}
          onPointerMove={onMove}
          onPointerLeave={() => {
            hoverRef.current = null;
            setHover(null);
          }}
          onClick={(e) => {
            const r = pick(e as unknown as React.PointerEvent<HTMLCanvasElement>);
            if (r) act(r.hit.kind, r.hit.id);
          }}
        />
        {tip && hover && (
          <div className="town-tip" style={{ left: hover.x, top: hover.y }} aria-hidden="true">
            <strong>{tip.title}</strong>
            <span>{tip.body}</span>
            {tip.hint && <em>{tip.hint}</em>}
          </div>
        )}
      </div>
      {controls && (
        <div className="town-controls">
          <div className="town-call">
            <label htmlFor="town-summon">Chamar agente</label>
            <select id="town-summon" value={summonId} onChange={(e) => setSummonId(e.target.value)}>
              {agents.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.name} · {a.role}
                </option>
              ))}
            </select>
            <button type="button" className="btn btn-ink" onClick={() => callAgent(summonId)}>
              Vem até mim
            </button>
          </div>
          <div className="town-props" role="group" aria-label="Móveis interativos">
            <button type="button" className="chip-btn" onClick={() => act('fridge')}>
              {worldRef.current.furniture.fridgeOpen ? 'Fechar geladeira' : 'Abrir geladeira'}
            </button>
            <button type="button" className="chip-btn" onClick={() => act('coffee')}>
              Passar café
            </button>
            <button type="button" className="chip-btn" onClick={() => act('gate')}>
              {worldRef.current.furniture.gateOpen ? 'Fechar portão' : 'Abrir portão'}
            </button>
          </div>
          <p className="sr-only" aria-live="polite">
            {announce}
          </p>
        </div>
      )}
    </div>
  );
}

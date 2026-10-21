import { useEffect, useRef, useState } from 'react';

// The page is the building: you start on the top floor and ride down.
export const FLOORS = [
  { id: 'topo', n: '10', label: 'Topo' },
  { id: 'virada', n: '9', label: 'A virada' },
  { id: 'gargalo', n: '8', label: 'O gargalo' },
  { id: 'time', n: '7', label: 'O time' },
  { id: 'canais', n: '6', label: 'Canais' },
  { id: 'fluxo', n: '5', label: 'Quadro' },
  { id: 'conversa', n: '4', label: 'Conversa' },
  { id: 'cerebro', n: '3', label: 'Cérebro' },
  { id: 'seguranca', n: '2', label: 'Segurança' },
  { id: 'resultados', n: '1', label: 'Resultados' },
  { id: 'contato', n: 'T', label: 'Térreo' },
] as const;

export function Elevator() {
  const [cur, setCur] = useState(0);
  const [down, setDown] = useState(true);
  const prev = useRef(0);

  useEffect(() => {
    const els = FLOORS.map((f) => document.getElementById(f.id)).filter((e): e is HTMLElement => !!e);
    const io = new IntersectionObserver(
      (entries) => {
        for (const e of entries) {
          if (!e.isIntersecting) continue;
          const i = FLOORS.findIndex((f) => f.id === e.target.id);
          if (i < 0) continue;
          setDown(i >= prev.current);
          prev.current = i;
          setCur(i);
        }
      },
      { rootMargin: '-45% 0px -54% 0px' },
    );
    els.forEach((el) => io.observe(el));
    return () => io.disconnect();
  }, []);

  const f = FLOORS[cur];

  return (
    <nav className="elevator" aria-label="Andares da página">
      <div className="elev-display" aria-hidden="true">
        <span className={`elev-arrow${down ? '' : ' is-up'}`}>▼</span>
        <span className="elev-n" key={f.n}>
          {f.n}
        </span>
      </div>
      <ol>
        {FLOORS.map((x, i) => (
          <li key={x.id}>
            <a href={`#${x.id}`} aria-current={i === cur ? 'location' : undefined}>
              <span className="elev-tick" aria-hidden="true" />
              <span className="elev-name">
                <span className="elev-num">{x.n}</span> {x.label}
              </span>
            </a>
          </li>
        ))}
      </ol>
    </nav>
  );
}

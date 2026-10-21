import { useEffect, useState } from 'react';
import { CONTACT_URL } from '../links';

const LINKS = [
  ['#time', 'Time'],
  ['#canais', 'Canais'],
  ['#fluxo', 'Quadro'],
  ['#cerebro', 'Cérebro'],
  ['#resultados', 'Resultados'],
] as const;

export function Nav() {
  const [scrolled, setScrolled] = useState(false);
  useEffect(() => {
    const on = () => setScrolled(window.scrollY > 24);
    on();
    window.addEventListener('scroll', on, { passive: true });
    return () => window.removeEventListener('scroll', on);
  }, []);

  return (
    <header className={`nav${scrolled ? ' is-scrolled' : ''}`}>
      <div className="nav-inner">
        <a className="brand" href="#topo" aria-label="Tower, por Metrifica Labs. Voltar ao topo">
          <img src="/tower/metrifica.svg" alt="" width={28} height={28} />
          <span className="brand-name">Tower</span>
          <span className="brand-by">por Metrifica Labs</span>
        </a>
        <nav aria-label="Seções">
          <ul className="nav-links">
            {LINKS.map(([href, label]) => (
              <li key={href}>
                <a href={href}>{label}</a>
              </li>
            ))}
          </ul>
        </nav>
        <a className="btn btn-blue btn-sm" href={CONTACT_URL}>
          Quero meu time
        </a>
      </div>
    </header>
  );
}

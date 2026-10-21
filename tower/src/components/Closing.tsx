import { CONTACT_URL } from '../links';
import { GESTOR_SHIRT, OWNER_SHIRT, SECTORS, look } from '../data/team';
import { PixelAvatar } from './PixelAvatar';

const CREW = [
  { name: 'Leo', shirt: GESTOR_SHIRT, chief: true },
  ...SECTORS.flatMap((s) => [
    { name: s.chief, shirt: s.color, chief: true },
    ...s.members.map((m) => ({ name: m.name, shirt: s.color, chief: false })),
  ]),
];

export function FinalCta() {
  return (
    <section className="final" id="contato" aria-labelledby="final-title">
      <div className="wrap final-inner">
        <h2 id="final-title" className="final-title">
          Saia do meio.
          <br />
          <span className="you-text">Fique no topo.</span>
        </h2>
        <div className="final-side">
          <p className="body">
            Conte como sua operação funciona hoje. A gente mostra onde um time da Tower tira você do caminho e o que você
            passa a só aprovar.
          </p>
          <a className="btn btn-blue btn-lg" href={CONTACT_URL}>
            Quero montar meu time
          </a>
        </div>
      </div>
      <div className="crew" aria-hidden="true">
        <span className="crew-you">
          <PixelAvatar shirt={OWNER_SHIRT} size={30} {...look('Você')} />
          <em>você</em>
        </span>
        {CREW.map((c, i) => (
          <span key={c.name} className="crew-p" style={{ animationDelay: `${(i * 137) % 1600}ms` }}>
            <PixelAvatar shirt={c.shirt} chief={c.chief} size={22} {...look(c.name)} />
          </span>
        ))}
      </div>
    </section>
  );
}

export function Footer() {
  return (
    <footer className="footer">
      <div className="wrap footer-inner">
        <a className="brand" href="/" aria-label="Metrifica Labs, página inicial">
          <img src="/tower/metrifica.svg" alt="" width={24} height={24} />
          <span className="brand-name">Metrifica Labs</span>
        </a>
        <p>Tower é a orquestra de agentes que a Metrifica usa para operar. © 2026</p>
      </div>
    </footer>
  );
}

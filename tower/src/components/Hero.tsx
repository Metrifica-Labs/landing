import { useEffect, useState } from 'react';
import { Town, type TownStats } from '../town/Town';
import { CONTACT_URL } from '../links';
import { GESTOR_SHIRT, look, sectorColor } from '../data/team';
import { useReducedMotion } from '../hooks';
import { PixelAvatar } from './PixelAvatar';

const FEED = [
  { id: 'f1', who: 'Vera', sector: 'qa', text: 'testando o checkout no celular' },
  { id: 'f2', who: 'Otto', sector: 'seguranca', text: 'aprovou o merge do PR #212' },
  { id: 'f3', who: 'Bento', sector: 'backend', text: 'chamou 2 auxiliares pro webhook' },
  { id: 'f4', who: 'Leo', sector: 'gestor', text: 'destravou o Rafa: a chave da API chegou' },
  { id: 'f5', who: 'Lia', sector: 'frontend', text: 'v1.8.2 no ar, conferida de fora' },
  { id: 'f6', who: 'Iris', sector: 'ui', text: 'deixou 2 versões do texto pra você escolher' },
] as const;

const AGO = ['agora', '1 min', '3 min'];

export function Hero() {
  const reduced = useReducedMotion();
  const [s, setS] = useState<TownStats | null>(null);
  const [head, setHead] = useState(0);

  useEffect(() => {
    if (reduced) return;
    const id = window.setInterval(() => setHead((h) => (h + 1) % FEED.length), 2800);
    return () => window.clearInterval(id);
  }, [reduced]);

  const feed = [0, 1, 2].map((k) => FEED[(head - k + FEED.length * 2) % FEED.length]);

  return (
    <section className="hero" id="topo" aria-labelledby="hero-title">
      <div className="hero-copy">
        <h1 id="hero-title" className="hero-title">
          <span className="line">Você não é mais</span>
          <span className="line">o gargalo.</span>
        </h1>
        <p className="hero-sub">
          Seu trabalho agora é <mark className="you">treinar</mark> quem trabalha.
        </p>
        <p className="lead">
          Um time de agentes de IA que funciona como empresa: cada um tem nome, papel e mesa. Você pede, acompanha e
          aprova. Eles se organizam, revisam um ao outro e aprendem o seu padrão.
        </p>
        <div className="hero-cta">
          <a className="btn btn-blue btn-lg hero-cta-main" href={CONTACT_URL}>
            Quero montar meu time
            <svg className="btn-arrow" viewBox="0 0 16 16" aria-hidden="true">
              <path d="M3 8h10M9 4l4 4-4 4" />
            </svg>
          </a>
          <a className="hero-cta-more" href="#gargalo">
            <span className="hero-cta-more-icon" aria-hidden="true">
              <svg viewBox="0 0 16 16">
                <path d="M8 3v10M4 9l4 4 4-4" />
              </svg>
            </span>
            Ver como funciona
          </a>
        </div>
      </div>

      <div className="hero-town">
        <div className="hero-stage">
          <Town
            label="Simulação do Town: um prédio isométrico com setores de Backend, Frontend, UI e UX, QA, Segurança, Infra, Growth, Suporte, Arquiteto, Gestão, Copa e Recepção. Agentes trabalham nas mesas, vão à copa e auxiliares entram pelo portão."
            onStats={setS}
          />

          <div className="hud hud-pending" aria-hidden="true">
            <span className="hud-k">pendência sua</span>
            <strong>Escolher o texto do checkout</strong>
            <span className="hud-time">leva 2 min</span>
          </div>

          <div className="hud hud-feed">
            <div className="hud-head">
              <span>quadro · agora</span>
              <span className="dot" aria-hidden="true" />
            </div>
            <ol aria-live="off">
              {feed.map((f, i) => (
                <li key={f.id} className={i === 0 ? 'is-new' : ''}>
                  <PixelAvatar
                    size={16}
                    shirt={f.sector === 'gestor' ? GESTOR_SHIRT : sectorColor(f.sector)}
                    chief={f.sector === 'gestor'}
                    {...look(f.who)}
                  />
                  <span className="hud-text">
                    <strong>{f.who}</strong> {f.text}
                  </span>
                  <time>{AGO[i]}</time>
                </li>
              ))}
            </ol>
          </div>
        </div>

        <dl className="hero-meter">
          <div>
            <dt>trabalhando</dt>
            <dd>{s ? s.working : '—'}</dd>
          </div>
          <div>
            <dt>livres</dt>
            <dd>{s ? s.free : '—'}</dd>
          </div>
          <div>
            <dt>auxiliares</dt>
            <dd>{s ? s.helpers : '—'}</dd>
          </div>
          <div className="hero-meter-note">
            <dt className="sr-only">Sobre</dt>
            <dd>Simulação ao vivo do Town, com a mesma lógica do real</dd>
          </div>
        </dl>
      </div>
    </section>
  );
}

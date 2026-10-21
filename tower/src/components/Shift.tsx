import { SOURCES } from '../links';

const STATS = [
  { n: '6×', text: 'Em agosto, as horas de agentes de IA já eram seis vezes as horas dos funcionários.' },
  { n: '20%', text: 'dos funcionários disseram que o papel deles mudou de fazer o trabalho para gerenciar Claudes.' },
  {
    n: '10→22%',
    text: 'do tempo com o Claude virou meta-trabalho: escrever instruções fixas, montar painéis e pôr um agente para revisar o outro.',
  },
] as const;

export function Shift() {
  return (
    <section className="virada" id="virada" aria-labelledby="virada-title">
      <div className="wrap">
        <h2 id="virada-title" className="sr-only">
          A virada: quem trabalha com IA deixou de mandar prompt
        </h2>
        <figure className="quote">
          <span className="quote-mark" aria-hidden="true">
            “
          </span>
          <blockquote>
            <p>
              Eu não mando mais prompt pro Claude. Tenho loops rodando que mandam prompt pro Claude e descobrem o que
              fazer. <strong>Meu trabalho é escrever loops.</strong>
            </p>
          </blockquote>
          <figcaption>
            <span className="quote-who">Boris Cherny</span>
            <span className="quote-role">criador do Claude Code, Anthropic · junho de 2026</span>
            <a className="src src-dark" href={SOURCES.cherny} target="_blank" rel="noreferrer">
              fonte
            </a>
          </figcaption>
        </figure>

        <div className="ledger">
          <p className="ledger-intro">
            Não é só ele. Em outubro de 2026 a Anthropic mediu a própria empresa:
          </p>
          <dl>
            {STATS.map((s) => (
              <div key={s.n}>
                <dt>{s.n}</dt>
                <dd>{s.text}</dd>
              </div>
            ))}
          </dl>
          <a className="src src-dark" href={SOURCES.anthropicReport} target="_blank" rel="noreferrer">
            Anthropic, “How employment is changing at Anthropic”, out. 2026
          </a>
        </div>
      </div>
    </section>
  );
}

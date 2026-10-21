import { CASES, CASE_SLOTS, type Case } from '../data/cases';

function Frame({ url, children }: { url: string; children: React.ReactNode }) {
  return (
    <div className="case-frame">
      <div className="case-bar" aria-hidden="true">
        <span className="case-url">{url}</span>
      </div>
      <div className="case-media">{children}</div>
    </div>
  );
}

function CaseItem({ c, lead }: { c: Case; lead: boolean }) {
  const host = c.link ? new URL(c.link).host : 'metrifica.com.br';
  return (
    <li className={`case${lead ? ' case-lead' : ''}`}>
      <Frame url={host}>
        {c.media?.kind === 'video' ? (
          <video src={c.media.src} aria-label={c.media.alt} muted loop playsInline autoPlay preload="metadata" />
        ) : c.media ? (
          <img src={c.media.src} alt={c.media.alt} loading="lazy" decoding="async" />
        ) : null}
      </Frame>
      <div className="case-body">
        <h3>{c.title}</h3>
        <p>{c.summary}</p>
        <p className="case-meta mono">
          {c.kind && <span>{c.kind}</span>}
          {c.duration && <span>{c.duration}</span>}
          {c.sectors && <span>{c.sectors.join(' · ')}</span>}
        </p>
        {c.link && (
          <a className="src" href={c.link} target="_blank" rel="noreferrer">
            ver no ar
          </a>
        )}
      </div>
    </li>
  );
}

export function Results() {
  const empty = Math.max(0, CASE_SLOTS - CASES.length);

  return (
    <section className="section results" id="resultados" aria-labelledby="results-title">
      <div className="wrap">
        <div className="split-head">
          <h2 id="results-title" className="h2">
            Feito por essa orquestra.
          </h2>
          <p className="body">
            A Metrifica já opera com a Tower no dia a dia. Estes produtos estão no ar e foram construídos por esse time de
            agentes.
          </p>
        </div>

        <ul className="cases">
          {CASES.map((c, i) => (
            <CaseItem key={c.id} c={c} lead={i === 0 && CASES.length % 2 === 1} />
          ))}
          {Array.from({ length: empty }, (_, i) => {
            const n = String(CASES.length + i + 1).padStart(2, '0');
            return (
              <li key={`slot${i}`} className={`case case-slot${CASES.length === 0 && i === 0 ? ' case-lead' : ''}`}>
                <Frame url={`case-${n}`}>
                  <div className="slot" aria-hidden="true">
                    <span className="slot-line w60" />
                    <span className="slot-line w40" />
                    <span className="slot-block" />
                    <span className="slot-mark">case {n} · em preparação</span>
                  </div>
                </Frame>
                <div className="case-body">
                  <h3>Em preparação</h3>
                  <p>Print, prazo e setores envolvidos entram aqui assim que o case for publicado.</p>
                  {import.meta.env.DEV && <p className="dev-hint mono">dev: preencher tower/src/data/cases.ts</p>}
                </div>
              </li>
            );
          })}
        </ul>
      </div>
    </section>
  );
}

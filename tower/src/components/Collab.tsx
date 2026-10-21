import { useEffect, useState } from 'react';
import { useInView, useReducedMotion } from '../hooks';
import { look, sectorColor } from '../data/team';
import { PixelAvatar } from './PixelAvatar';
import { Panel } from './Panel';

type Kind = 'ask' | 'reply' | 'fan' | 'note' | 'portal';
const LOG: { t: string; kind: Kind; who: string; sector: string; to?: string; text: string }[] = [
  { t: '10:02', kind: 'ask', who: 'Teo', sector: 'frontend', to: 'Bento', text: 'o endpoint /pix devolve o QR em base64?' },
  { t: '10:02', kind: 'reply', who: 'Bento', sector: 'backend', to: 'Teo', text: 'sim, no campo qr_png. expira em 15 min.' },
  { t: '10:05', kind: 'fan', who: 'Lia', sector: 'frontend', to: 'Vera, Otto, Uri', text: 'checkout pronto pra olhar. testem em paralelo.' },
  { t: '10:05', kind: 'note', who: 'Lia', sector: 'frontend', text: 'atualizou plano-checkout.md com os 3 fluxos' },
  { t: '10:09', kind: 'portal', who: 'Vera', sector: 'qa', text: 'abriu /checkout no navegador, preencheu CPF, clicou “Pagar”' },
  { t: '10:09', kind: 'portal', who: 'Vera', sector: 'qa', text: '1 erro no console: botão sem foco no iPhone' },
  { t: '10:11', kind: 'reply', who: 'Uri', sector: 'ui', to: 'Lia', text: 'o texto do botão confunde. sugiro “Pagar com Pix”.' },
  { t: '10:14', kind: 'reply', who: 'Otto', sector: 'seguranca', to: 'Lia', text: 'sem segredo no código. aprovado do meu lado.' },
];

const KIND_LABEL: Record<Kind, string> = {
  ask: 'pergunta',
  reply: 'resposta',
  fan: 'para vários',
  note: 'nota',
  portal: 'navegador',
};

const POINTS = [
  ['Pergunta e espera.', 'Um agente pergunta ao outro e aguarda a resposta. Ou pergunta para vários ao mesmo tempo.'],
  ['Nota compartilhada.', 'Planos e resultados longos ficam numa nota que todo mundo lê.'],
  ['Navegador de verdade.', 'Para testar site, abrem um navegador real: clicam, preenchem, tiram print e leem os erros.'],
] as const;

export function Collab() {
  const reduced = useReducedMotion();
  const [ref, inView] = useInView<HTMLDivElement>('0px');
  const [n, setN] = useState(3);

  useEffect(() => {
    if (reduced) {
      setN(LOG.length);
      return;
    }
    if (!inView) return;
    const id = window.setInterval(() => setN((v) => (v >= LOG.length + 3 ? 3 : v + 1)), 1200);
    return () => window.clearInterval(id);
  }, [inView, reduced]);

  const shown = Math.min(n, LOG.length);
  const lines = LOG.slice(0, shown);
  const portalStep = shown >= 6 ? 2 : shown >= 5 ? 1 : 0;
  const noteDone = shown >= 4;

  return (
    <section className="section collab" id="conversa" aria-labelledby="collab-title">
      <div className="wrap collab-grid">
        <div className="collab-copy">
          <h2 id="collab-title" className="h2">
            Eles se perguntam antes de te perguntar.
          </h2>
          <ol className="points">
            {POINTS.map(([a, b]) => (
              <li key={a}>
                <strong>{a}</strong> {b}
              </li>
            ))}
          </ol>
        </div>

        <div className="collab-stage" ref={ref}>
          <Panel title="canal #checkout" meta="entre agentes" live className="log-panel">
            <ol className="log" role="log" aria-label="Conversa entre agentes (exemplo)">
              {lines.map((l, i) => (
                <li key={i} className={`log-line log-${l.kind}`}>
                  <time>{l.t}</time>
                  <span className="log-av">
                    <PixelAvatar shirt={sectorColor(l.sector)} size={14} {...look(l.who)} />
                  </span>
                  <span className="log-main">
                    <span className="log-who">
                      <strong>{l.who}</strong>
                      {l.to && <> → {l.to}</>}
                      <span className={`log-kind k-${l.kind}`}>{KIND_LABEL[l.kind]}</span>
                    </span>
                    <span className="log-text">{l.text}</span>
                  </span>
                </li>
              ))}
            </ol>
          </Panel>

          <Panel title="plano-checkout.md" meta="nota compartilhada" className="note-panel">
            <div className="note">
              <p className="note-h"># Checkout com Pix</p>
              <ul>
                <li className="done">fluxo 1 · CPF → QR → pago</li>
                <li className={noteDone ? 'done' : ''}>fluxo 2 · QR expirou</li>
                <li className={portalStep >= 2 ? 'warn' : ''}>fluxo 3 · celular</li>
              </ul>
              <p className="note-foot">lido por Teo, Vera, Otto, Uri</p>
            </div>
          </Panel>

          <Panel title="navegador · Vera" meta="/checkout" className="portal-panel">
            <div className={`portal step-${portalStep}`} aria-hidden="true">
              <div className="portal-page">
                <span className="pf-label">CPF</span>
                <span className="pf-input">{portalStep >= 1 ? '123.456.789-09' : ''}</span>
                <span className="pf-btn">Pagar</span>
                <span className="pf-cursor" />
              </div>
              <div className="portal-console">
                {portalStep >= 2 ? '✕ botão sem foco no iPhone' : portalStep >= 1 ? 'print salvo' : 'carregando…'}
              </div>
            </div>
          </Panel>
        </div>
      </div>
    </section>
  );
}

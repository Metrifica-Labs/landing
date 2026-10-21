import { useEffect, useState } from 'react';
import { useReducedMotion, useSeen } from '../hooks';
import { GESTOR_SHIRT, look } from '../data/team';
import { PixelAvatar } from './PixelAvatar';

type Msg =
  | { who: 'bot'; text: string; time: string }
  | { who: 'you'; text: string; time: string }
  | { who: 'card'; time: string };

const CHAT: Msg[] = [
  { who: 'bot', text: 'Bom dia. Ontem o time fechou 6 itens. Hoje sobem o checkout e a landing.', time: '08:30' },
  { who: 'card', time: '10:12' },
  { who: 'you', text: 'B', time: '10:14' },
  { who: 'bot', text: 'Fechado. A Lia sobe com a B e te aviso quando estiver no ar.', time: '10:14' },
  { who: 'bot', text: 'No ar: v1.8.2, conferida de fora. Print anexado.', time: '11:02' },
];

type Line = { kind: 'cmd' | 'out' | 'ok' | 'warn' | 'dim'; text: string };

const TERM: Line[] = [
  { kind: 'cmd', text: 'tower ask frontend "quanto falta pro checkout?"' },
  { kind: 'dim', text: '→ Lia, chefe de Frontend' },
  { kind: 'out', text: 'lia › Pix pronto, cartão em revisão. Faltam ~3h.' },
  { kind: 'cmd', text: 'tower board --mine' },
  { kind: 'out', text: 'P1  Checkout com Pix ······ Lia   em revisão' },
  { kind: 'ok', text: 'P2  Landing Black Friday ·· Gael  fazendo' },
  { kind: 'warn', text: 'P1  Bug no login ·········· Caio  bloqueado · precisa de você' },
  { kind: 'cmd', text: 'tower ok "bug no login" --nota "pode usar o token novo"' },
  { kind: 'ok', text: '✓ Caio destravado · gestor avisado' },
];

function useReveal(total: number, seen: boolean, reduced: boolean, every: number) {
  const [n, setN] = useState(0);
  useEffect(() => {
    if (reduced) {
      setN(total);
      return;
    }
    if (!seen) return;
    let k = 0;
    setN(0);
    const id = window.setInterval(() => {
      k += 1;
      setN(k);
      if (k >= total) window.clearInterval(id);
    }, every);
    return () => window.clearInterval(id);
  }, [seen, reduced, total, every]);
  return n;
}

export function Channels() {
  const reduced = useReducedMotion();
  const [ref, seen] = useSeen<HTMLDivElement>(0.3);
  const [picked, setPicked] = useState<'A' | 'B' | null>(null);
  const chatN = useReveal(CHAT.length, seen, reduced, 1500);
  const termN = useReveal(TERM.length, seen, reduced, 900);

  return (
    <section className="section channels" id="canais" aria-labelledby="channels-title">
      <div className="wrap">
        <div className="split-head">
          <h2 id="channels-title" className="h2">
            Fale com o time de onde estiver.
          </h2>
          <p className="body">
            No celular, pelo Telegram. No computador, pelo terminal. É o mesmo time e o mesmo quadro. O que é importante
            chega sozinho; o que depende de você vem como um cartão curto, com o tempo que leva.
          </p>
        </div>

        <div className="channels-stage" ref={ref}>
          <div className="term" role="log" aria-label="Terminal: conversa com o time (exemplo)">
            <div className="term-bar">
              <span>~/operacao</span>
              <span className="term-tag">terminal</span>
            </div>
            <ol className="term-body">
              {TERM.slice(0, termN).map((l, i) => (
                <li key={i} className={`tl tl-${l.kind}`}>
                  {l.kind === 'cmd' && (
                    <span className="prompt" aria-hidden="true">
                      ❯
                    </span>
                  )}
                  {l.text}
                </li>
              ))}
              {termN < TERM.length && (
                <li className="tl tl-cmd" aria-hidden="true">
                  <span className="prompt">❯</span>
                  <span className="caret" />
                </li>
              )}
            </ol>
          </div>

          <div className="phone" role="log" aria-label="Telegram: avisos do time no celular (exemplo)">
            <div className="phone-notch" aria-hidden="true" />
            <div className="phone-status" aria-hidden="true">
              <span>11:02</span>
              <span>●●●● 5G</span>
            </div>
            <div className="phone-head">
              <span className="phone-av">
                <PixelAvatar shirt={GESTOR_SHIRT} chief size={18} {...look('Leo')} />
              </span>
              <span>
                <strong>Tower</strong>
                <em>Leo, gestor · bot no Telegram</em>
              </span>
            </div>
            <ol className="chat">
              {CHAT.slice(0, chatN).map((m, i) => {
                if (m.who === 'card')
                  return (
                    <li key={i} className="bubble bubble-card">
                      <span className="card-k">pendência sua · leva 2 min</span>
                      <p>A Iris deixou duas versões do texto do checkout. Qual sobe?</p>
                      <div className="card-opts">
                        {(['A', 'B'] as const).map((o) => (
                          <button
                            key={o}
                            type="button"
                            aria-pressed={picked === o || (picked === null && chatN > 2 && o === 'B')}
                            onClick={() => setPicked(o)}
                          >
                            Versão {o}
                          </button>
                        ))}
                      </div>
                      <time>{m.time}</time>
                    </li>
                  );
                return (
                  <li key={i} className={`bubble bubble-${m.who}`}>
                    <p>{m.who === 'you' ? (picked ?? m.text) : m.text.replace('com a B', `com a ${picked ?? 'B'}`)}</p>
                    <time>{m.time}</time>
                  </li>
                );
              })}
            </ol>
            <div className="phone-input" aria-hidden="true">
              <span>Mensagem</span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

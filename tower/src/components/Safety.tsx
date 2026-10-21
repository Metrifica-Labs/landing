import { useId, useState } from 'react';
import { Panel } from './Panel';

const RULES = [
  {
    icon: 'sign',
    title: 'Irreversível pede sua assinatura.',
    text: 'Deploy de cliente, apagar dados ou mexer em produção só com confirmação escrita sua. Recado solto não vale.',
  },
  { icon: 'key', title: 'Segredo não circula.', text: 'Senha, chave e token nunca vão para chat ou nota. Nem entre agentes.' },
  { icon: 'pr', title: 'Cliente só por PR.', text: 'Produto de cliente muda por pull request, revisado pelas camadas e com o seu ok.' },
] as const;

function RuleIcon({ kind }: { kind: (typeof RULES)[number]['icon'] }) {
  return (
    <svg viewBox="0 0 16 16" width="22" height="22" shapeRendering="crispEdges" aria-hidden="true">
      {kind === 'sign' && (
        <>
          <rect x="4" y="7" width="8" height="7" />
          <rect x="5" y="3" width="1.5" height="4" />
          <rect x="9.5" y="3" width="1.5" height="4" />
          <rect x="5" y="2" width="6" height="1.5" />
        </>
      )}
      {kind === 'key' && (
        <>
          <rect x="2" y="5" width="6" height="6" />
          <rect x="8" y="7" width="7" height="2" />
          <rect x="12" y="9" width="1.5" height="2.5" />
          <rect x="14" y="9" width="1" height="2" />
        </>
      )}
      {kind === 'pr' && (
        <>
          <rect x="3" y="2" width="2" height="12" />
          <rect x="11" y="6" width="2" height="8" />
          <rect x="6" y="3" width="5" height="2" />
          <rect x="10" y="3" width="2" height="4" />
        </>
      )}
    </svg>
  );
}

type Result = { ok: boolean; text: string } | null;

export function Safety() {
  const inputId = useId();
  const [loose, setLoose] = useState(false);
  const [value, setValue] = useState('');
  const [result, setResult] = useState<Result>(null);
  const unlocked = !!result?.ok;

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    const v = value.trim().toLowerCase();
    if (!v.startsWith('confirmo') || !v.includes('loja-cliente')) {
      setResult({ ok: false, text: 'Ainda travado. Escreva “confirmo” e o nome do alvo: loja-cliente.' });
      return;
    }
    const now = new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
    setResult({ ok: true, text: `Liberado por você, por escrito, às ${now}. O Rui sobe, confere de fora e registra no quadro.` });
  };

  return (
    <section className="section safety" id="seguranca" aria-labelledby="safety-title">
      <div className="wrap safety-grid">
        <div className="safety-copy">
          <h2 id="safety-title" className="h2">
            Seguro por padrão. Não por favor.
          </h2>
          <ol className="rules">
            {RULES.map((r) => (
              <li key={r.title}>
                <span className="rule-icon">
                  <RuleIcon kind={r.icon} />
                </span>
                <span>
                  <strong>{r.title}</strong> {r.text}
                </span>
              </li>
            ))}
          </ol>
        </div>

        <Panel
          className={`gate${unlocked ? ' is-open' : ''}`}
          title="deploy · loja-cliente · produção"
          meta="ação irreversível"
        >
          <div className="gate-lock" role="status">
            <span className="gate-state">{unlocked ? 'liberado' : 'travado'}</span>
            <span className="gate-why">
              {unlocked ? 'confirmação escrita recebida' : 'esperando a confirmação escrita do dono'}
            </span>
          </div>

          <div className="gate-step">
            <p className="gate-label">Recado solto no Telegram</p>
            <button type="button" className="chip-btn" onClick={() => setLoose(true)} disabled={unlocked}>
              “pode subir aí”
            </button>
            {loose && (
              <p className="gate-res gate-no">
                <strong>Rui · Infra:</strong> Não subo com recado solto. Para produção preciso de “confirmo deploy
                loja-cliente”, por escrito.
              </p>
            )}
          </div>

          <form className="gate-step" onSubmit={submit}>
            <label className="gate-label" htmlFor={inputId}>
              Confirmação escrita
            </label>
            <div className="gate-row">
              <input
                id={inputId}
                value={value}
                onChange={(e) => setValue(e.target.value)}
                placeholder="confirmo deploy loja-cliente"
                autoComplete="off"
                spellCheck={false}
                disabled={unlocked}
              />
              <button type="submit" className="btn btn-blue btn-sm" disabled={unlocked}>
                Enviar
              </button>
            </div>
            {result && (
              <p className={`gate-res ${result.ok ? 'gate-ok' : 'gate-no'}`} role="status">
                {result.text}
              </p>
            )}
          </form>
        </Panel>
      </div>
    </section>
  );
}

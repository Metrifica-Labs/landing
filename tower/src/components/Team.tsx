import { useEffect, useRef, useState } from 'react';
import { GESTOR_SHIRT, OWNER_SHIRT, SECTORS, look } from '../data/team';
import { PixelAvatar } from './PixelAvatar';
import { Panel } from './Panel';

// What each person is on right now, by sector: [chief, ...members].
const NOW: Record<string, { state: 'work' | 'review' | 'free' | 'break'; task: string }[]> = {
  backend: [
    { state: 'review', task: 'revisando o PR do webhook' },
    { state: 'work', task: 'endpoint /pix' },
    { state: 'work', task: 'migração do banco' },
  ],
  frontend: [
    { state: 'review', task: 'revisando o checkout' },
    { state: 'work', task: 'tela de pagamento' },
    { state: 'free', task: 'livre' },
  ],
  ui: [
    { state: 'work', task: '2 versões do texto do checkout' },
    { state: 'work', task: 'fluxo de onboarding' },
    { state: 'break', task: 'na copa' },
  ],
  qa: [
    { state: 'work', task: 'checkout no celular real' },
    { state: 'work', task: 'regressão do login' },
    { state: 'free', task: 'livre' },
  ],
  seguranca: [
    { state: 'review', task: 'aprovando o merge do #212' },
    { state: 'work', task: 'varredura de segredos' },
  ],
  infra: [
    { state: 'work', task: 'conferindo v1.8.2 de fora' },
    { state: 'free', task: 'livre' },
  ],
  growth: [
    { state: 'work', task: 'teste A/B da landing' },
    { state: 'work', task: 'campanha Black Friday' },
  ],
  suporte: [
    { state: 'work', task: 'virando reclamação em demanda' },
    { state: 'work', task: 'FAQ do Pix' },
  ],
  arquiteto: [
    { state: 'work', task: 'montando a sala nova do QA' },
    { state: 'work', task: 'simulando cliente na oferta' },
  ],
};

const STATE_LABEL = { work: 'trabalhando', review: 'revisando', free: 'livre', break: 'pausa' } as const;

const PLAN = ['parte 1: a integração', 'parte 2: os testes', 'parte 3: a documentação'];

export function Team() {
  const [sel, setSel] = useState(SECTORS[0].id);
  const [phase, setPhase] = useState<'idle' | 'hired' | 'done'>('idle');
  const timers = useRef<number[]>([]);
  const sector = SECTORS.find((s) => s.id === sel)!;
  const now = NOW[sector.id];

  const clear = () => {
    timers.current.forEach((t) => window.clearTimeout(t));
    timers.current = [];
  };
  useEffect(() => clear, []);

  const simulate = () => {
    clear();
    setPhase('hired');
    timers.current.push(window.setTimeout(() => setPhase('done'), 5200));
    timers.current.push(window.setTimeout(() => setPhase('idle'), 8200));
  };

  const people = [
    { name: sector.chief, role: sector.id === 'arquiteto' ? 'Arquiteto' : `Chefe de ${sector.name}`, chief: true },
    ...sector.members.map((m) => ({ ...m, chief: false })),
  ];

  return (
    <section className="section team" id="time" aria-labelledby="team-title">
      <div className="wrap">
        <div className="split-head">
          <h2 id="team-title" className="h2">
            Um time com organograma. Não um chatbot.
          </h2>
          <p className="body">
            Cada agente tem nome, papel e personalidade. Cada setor tem um chefe que tria, planeja e divide o trabalho.
            Acima deles, um gestor que distribui as demandas, cobra e reporta pra você.
          </p>
        </div>

        <div className="org">
          <div className="org-top">
            <div className="org-tier org-owner">
              <span className="org-av">
                <PixelAvatar shirt={OWNER_SHIRT} size={30} {...look('Você')} />
              </span>
              <div>
                <strong>Você</strong>
                <span>dá a direção, treina e aprova</span>
              </div>
            </div>
            <div className="org-tier org-gestor">
              <span className="org-av">
                <PixelAvatar shirt={GESTOR_SHIRT} chief size={30} {...look('Leo')} />
              </span>
              <div>
                <strong>Leo · Gestor</strong>
                <span>distribui, cobra a cada 15 min e reporta</span>
              </div>
            </div>
          </div>

          <div className="org-sectors" role="tablist" aria-label="Setores">
            {SECTORS.map((s) => (
              <button
                key={s.id}
                type="button"
                role="tab"
                id={`tab-${s.id}`}
                aria-selected={sel === s.id}
                aria-controls="sector-panel"
                className="plaque"
                style={{ '--c': s.color } as React.CSSProperties}
                onClick={() => {
                  setSel(s.id);
                  clear();
                  setPhase('idle');
                }}
              >
                <span className="plaque-name">{s.name}</span>
                <span className="plaque-crew" aria-hidden="true">
                  <PixelAvatar shirt={s.color} chief size={14} {...look(s.chief)} />
                  {s.members.map((m) => (
                    <PixelAvatar key={m.name} shirt={s.color} size={14} {...look(m.name)} />
                  ))}
                </span>
                <span className="plaque-count">{s.members.length + 1}</span>
              </button>
            ))}
          </div>

          <Panel
            id="sector-panel"
            role="tabpanel"
            aria-labelledby={`tab-${sector.id}`}
            className="sector-panel"
            style={{ '--c': sector.color } as React.CSSProperties}
            title={`sala · ${sector.name}`}
            meta={`${people.length + (phase === 'hired' ? PLAN.length : 0)} na sala`}
            live
          >
            <div className="sector-body">
              <div className="sector-job">
                <h3>{sector.name}</h3>
                <p>{sector.job}</p>
              </div>

              <ul className="badges">
                {people.map((p, i) => (
                  <li key={p.name} className={`badge${p.chief ? ' is-chief' : ''}`}>
                    <span className="badge-av">
                      <PixelAvatar shirt={sector.color} chief={p.chief} size={30} {...look(p.name)} />
                    </span>
                    <span className="badge-id">
                      <strong>{p.name}</strong>
                      <span>{p.role}</span>
                    </span>
                    <span className={`badge-state st-${now[i]?.state ?? 'work'}`}>
                      <i aria-hidden="true" /> {STATE_LABEL[now[i]?.state ?? 'work']}
                      <em>{now[i]?.task}</em>
                    </span>
                  </li>
                ))}
                {phase === 'hired' &&
                  PLAN.map((part, i) => (
                    <li key={part} className="badge is-helper" style={{ animationDelay: `${300 + i * 180}ms` }}>
                      <span className="badge-av">
                        <PixelAvatar shirt={sector.color} helper size={30} {...look(`aux${i}`)} />
                      </span>
                      <span className="badge-id">
                        <strong>Aux {i + 1}</strong>
                        <span>temporário</span>
                      </span>
                      <span className="badge-state st-work">
                        <i aria-hidden="true" /> trabalhando
                        <em>{part}</em>
                      </span>
                    </li>
                  ))}
              </ul>

              <div className="sector-aux">
                <p>
                  <strong>Tarefa grande?</strong> O chefe divide em partes, contrata auxiliares temporários para tocar em
                  paralelo e dispensa quando acaba.
                </p>
                <button type="button" className="chip-btn" onClick={simulate} disabled={phase !== 'idle'}>
                  {phase === 'idle' ? 'Simular tarefa grande' : phase === 'hired' ? 'Auxiliares trabalhando…' : 'Dispensados'}
                </button>
                <ol className="aux-log mono" aria-live="polite">
                  {phase !== 'idle' && (
                    <li>
                      {sector.chief} dividiu a tarefa em {PLAN.length} partes
                    </li>
                  )}
                  {phase !== 'idle' && <li>contratou Aux 1, Aux 2 e Aux 3</li>}
                  {phase === 'done' && <li className="ok">partes entregues · auxiliares dispensados</li>}
                </ol>
              </div>
            </div>
          </Panel>
        </div>
      </div>
    </section>
  );
}

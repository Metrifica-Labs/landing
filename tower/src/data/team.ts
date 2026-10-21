// Mirrors the staff in town/scene.ts so the org chart and the Town agree.

export interface Sector {
  id: string;
  name: string;
  color: string;
  chief: string;
  members: { name: string; role: string }[];
  job: string;
}

export const SECTORS: Sector[] = [
  {
    id: 'backend',
    name: 'Backend',
    color: '#3d7bff',
    chief: 'Bento',
    members: [
      { name: 'Rafa', role: 'Backend' },
      { name: 'Kai', role: 'Backend' },
    ],
    job: 'APIs, banco, integrações e migrações.',
  },
  {
    id: 'frontend',
    name: 'Frontend',
    color: '#38b6ff',
    chief: 'Lia',
    members: [
      { name: 'Teo', role: 'Frontend' },
      { name: 'Nina', role: 'Frontend' },
    ],
    job: 'Telas, performance e tudo que roda no navegador.',
  },
  {
    id: 'ui',
    name: 'UI · UX',
    color: '#8b7bff',
    chief: 'Iris',
    members: [
      { name: 'Uri', role: 'UX' },
      { name: 'Duda', role: 'UI' },
    ],
    job: 'Interface, fluxo e o texto de cada botão.',
  },
  {
    id: 'qa',
    name: 'QA',
    color: '#3fd39a',
    chief: 'Vera',
    members: [
      { name: 'Caio', role: 'QA' },
      { name: 'Juno', role: 'QA' },
    ],
    job: 'Testa como usuário: clica, preenche e quebra antes do seu cliente.',
  },
  {
    id: 'seguranca',
    name: 'Segurança',
    color: '#ff6b6b',
    chief: 'Otto',
    members: [{ name: 'Zara', role: 'Segurança' }],
    job: 'Revisa todo PR e aprova antes do merge.',
  },
  {
    id: 'infra',
    name: 'Infra',
    color: '#9aa7c7',
    chief: 'Rui',
    members: [{ name: 'Ana', role: 'Infra' }],
    job: 'Deploy, servidores e a prova de que a versão nova está no ar.',
  },
  {
    id: 'growth',
    name: 'Growth',
    color: '#ff9f43',
    chief: 'Gael',
    members: [{ name: 'Mel', role: 'Growth' }],
    job: 'Campanhas, testes A/B e funil.',
  },
  {
    id: 'suporte',
    name: 'Suporte',
    color: '#5ad1e6',
    chief: 'Sol',
    members: [{ name: 'Dani', role: 'Suporte' }],
    job: 'Responde cliente e transforma reclamação em demanda no quadro.',
  },
  {
    id: 'arquiteto',
    name: 'Arquiteto',
    color: '#c58bff',
    chief: 'Hugo',
    members: [{ name: 'Pia', role: 'Simulação de clientes' }],
    job: 'Hugo monta salas, luz e móveis do Town. Pia se comporta como seu cliente para testar oferta e fluxo.',
  },
];

const HAIRS = ['#2b1d16', '#5a3a22', '#141414', '#c9a26b', '#7a2e1d', '#3b3b4f'];
const SKINS = ['#f2c9a0', '#d9a679', '#a9714b', '#7a4a2e', '#f5d6b8'];

/** Stable hair/skin per name, so the same agent looks the same everywhere. */
export const look = (name: string) => {
  const n = [...name].reduce((s, c) => s + c.charCodeAt(0), 0);
  return { hair: HAIRS[n % HAIRS.length], skin: SKINS[(n >> 1) % SKINS.length] };
};

export const OWNER_SHIRT = '#ffb547';
export const GESTOR_SHIRT = '#e8edf8';

export const sectorColor = (id: string) => SECTORS.find((s) => s.id === id)?.color ?? GESTOR_SHIRT;

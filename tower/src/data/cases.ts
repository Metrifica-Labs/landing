// Real results produced with the Tower orchestra. Only list what actually
// shipped. Media goes in tower/public/cases/ and is referenced as
// '/tower/cases/<file>'.
//
// Example:
// {
//   id: 'loja-pix',
//   title: 'Checkout com Pix para a Loja X',
//   summary: 'O time refez o checkout, com QA no celular e deploy conferido de fora.',
//   duration: '3 dias',
//   sectors: ['Frontend', 'Backend', 'QA', 'Segurança'],
//   media: { kind: 'image', src: '/tower/cases/loja-pix.png', alt: 'Tela do checkout com QR do Pix' },
//   link: 'https://lojax.com.br',
// },

export interface Case {
  id: string;
  title: string;
  summary: string;
  duration?: string;
  /** Short label for what the product is. */
  kind?: string;
  sectors?: string[];
  media?: { kind: 'image' | 'video'; src: string; alt: string };
  link?: string;
}

export const CASES: Case[] = [
  {
    id: 'speake',
    title: 'Speake',
    summary:
      'Plataforma de estações de áudio por assinatura: o criador publica episódios exclusivos e a audiência assina para ouvir.',
    kind: 'Plataforma de áudio por assinatura',
    media: { kind: 'image', src: '/tower/cases/speake.jpg', alt: 'Página inicial da Speake: crie sua estação de áudio por assinatura' },
    link: 'https://speake.com.br/',
  },
  {
    id: 'ordenare',
    title: 'Ordenare',
    summary:
      'CRM conversacional que junta WhatsApp, a SDR Joana e a equipe num funil só: cada conversa entra sabendo a origem, a etapa e o próximo passo.',
    kind: 'CRM conversacional',
    media: { kind: 'image', src: '/tower/cases/ordenare.jpg', alt: 'Página inicial da Ordenare: o norte da sua operação comercial' },
    link: 'https://agenciaordenare.com.br/',
  },
];

/** How many slots to show while the list is still short. */
export const CASE_SLOTS = 2;

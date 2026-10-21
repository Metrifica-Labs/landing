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
  sectors: string[];
  media?: { kind: 'image' | 'video'; src: string; alt: string };
  link?: string;
}

export const CASES: Case[] = [];

/** How many slots to show while the list is still short. */
export const CASE_SLOTS = 3;

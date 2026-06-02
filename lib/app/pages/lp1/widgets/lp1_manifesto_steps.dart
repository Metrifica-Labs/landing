import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// Dark manifesto
// ---------------------------------------------------------------------------
class Lp1ManifestoSection extends StatelessWidget {
  const Lp1ManifestoSection({super.key});

  static const _items = <String>[
    'Atrai os clientes certos, todos os dias',
    'Gera autoridade e desejo pela sua oferta',
    'Conecta, qualifica e prepara para a compra',
    'Converte seguidores em clientes High Ticket',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final h2Size = lpClampVw(34, 4.6, 62, width);

    return LpSection(
      background: LpColors.noir,
      clipChildren: true,
      stackBehind: const MonogramBg(
        letter: 'Ó',
        vw: 60,
        alignment: Alignment.centerLeft,
        color: Colors.white,
        opacity: 0.05,
        dxFraction: -0.26,
      ),
      child: LpSplit(
        crossAxisAlignment: CrossAxisAlignment.center,
        left: Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('A virada', color: LpColors.gold2),
              const SizedBox(height: 22),
              Text.rich(
                TextSpan(
                  style: LpType.serif(
                    size: h2Size,
                    weight: FontWeight.w500,
                    color: LpColors.cream,
                    height: 1.05,
                  ),
                  children: [
                    const TextSpan(text: 'É assim que o seu Instagram '),
                    TextSpan(
                      text: 'deveria',
                      style: LpType.serif(
                        size: h2Size,
                        weight: FontWeight.w500,
                        color: LpColors.gold2,
                        height: 1.05,
                        italic: true,
                      ),
                    ),
                    const TextSpan(text: ' trabalhar por você.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        right: Reveal(
          delayMs: 80,
          child: Column(
            children: [for (final item in _items) _ManifestoItem(text: item)],
          ),
        ),
      ),
    );
  }
}

class _ManifestoItem extends StatelessWidget {
  const _ManifestoItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1FFFFFFF))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LpColors.gold2),
            ),
            child: const Icon(Icons.check, size: 18, color: LpColors.gold2),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              text,
              style: LpType.sans(
                size: 16,
                weight: FontWeight.w300,
                color: LpColors.cream,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// How it works — steps
// ---------------------------------------------------------------------------
class Lp1StepsSection extends StatelessWidget {
  const Lp1StepsSection({super.key});

  static const _steps = <(String, IconData, String, String)>[
    (
      '01',
      Icons.search,
      'Diagnóstico',
      'Entendemos seu momento atual e os principais desafios do seu negócio.'
    ),
    (
      '02',
      Icons.assignment_outlined,
      'Estratégia',
      'Criamos um plano personalizado para atrair e converter clientes.'
    ),
    (
      '03',
      Icons.bolt,
      'Execução',
      'Implementamos conteúdos e ações com foco em resultados reais.'
    ),
    (
      '04',
      Icons.trending_up,
      'Escala',
      'Acompanhamos, ajustamos e escalamos para você vender todos os dias.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = lpColumns(width, wide: 4, tablet: 2, mobile: 1);

    return LpSection(
      background: LpColors.cream,
      child: Column(
        children: [
          const LpCenteredHead(
            eyebrow: 'Como funciona',
            title: 'Quatro passos até a previsibilidade.',
            bottomGap: 60,
          ),
          LpGrid(
            columns: cols,
            gap: 24,
            runGap: 40,
            children: [
              for (var i = 0; i < _steps.length; i++)
                Reveal(
                  delayMs: 80 * ((i % cols) + 1),
                  child: _StepCard(
                    number: _steps[i].$1,
                    icon: _steps[i].$2,
                    title: _steps[i].$3,
                    body: _steps[i].$4,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
  });

  final String number;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: LpColors.line)),
      ),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: LpType.serif(
              size: 15,
              weight: FontWeight.w500,
              color: LpColors.goldDeep,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Icon(icon, size: 38, color: LpColors.ink),
          const SizedBox(height: 22),
          Text(
            title.toUpperCase(),
            style: LpType.sans(
              size: 13,
              weight: FontWeight.w600,
              color: LpColors.ink,
              letterSpacing: 2.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: LpType.sans(
              size: 14.5,
              weight: FontWeight.w300,
              color: LpColors.ink2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

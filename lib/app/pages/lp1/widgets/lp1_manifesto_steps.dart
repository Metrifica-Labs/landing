import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// Dark manifesto
// ---------------------------------------------------------------------------
class Lp1ManifestoSection extends StatelessWidget {
  const Lp1ManifestoSection({super.key});

  static const _items = <String>[
    'Com processos que rodam sem você no centro de tudo.',
    'Com automações que eliminam o retrabalho manual.',
    'Com dados centralizados e visibilidade em tempo real.',
    'Com tecnologia que escala junto com o seu faturamento.',
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Eyebrow('Como deve ser', color: LpColors.gold2),
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
                    const TextSpan(text: 'É assim que a sua operação '),
                    TextSpan(
                      text: 'deve',
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
            mainAxisSize: MainAxisSize.min,
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
      'Diagnóstico Real',
      'Mapeamos onde estão os gargalos que travam sua escala, o que está sendo feito manualmente e o que já deveria estar automatizado.'
    ),
    (
      '02',
      Icons.map_outlined,
      'Mapeamento Escalável',
      'Você vai entender exatamente onde está o "vazamento" que impede sua operação de escalar — integração, automação ou processo.'
    ),
    (
      '03',
      Icons.rocket_launch_outlined,
      'Plano de Implementação',
      'O caminho mais direto para sua operação parar de depender de você e começar a escalar com tecnologia na ordem certa.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = lpColumns(width, wide: 3, tablet: 2, mobile: 1);

    return LpSection(
      background: LpColors.cream,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LpCenteredHead(
            eyebrow: 'Entregas',
            title: 'O que você recebe na consultoria gratuita.',
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
            style: LpType.numeral(
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

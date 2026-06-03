import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// "Se você" — features
// ---------------------------------------------------------------------------
class Lp1FeaturesSection extends StatelessWidget {
  const Lp1FeaturesSection({super.key});

  static const _features = <(IconData, String, String)>[
    (
      Icons.search,
      'Diagnóstico de Gargalos Operacionais',
      'Mapeamos o que trava a escala antes de tocar em qualquer ferramenta.',
    ),
    (
      Icons.sync_alt,
      'Integrações e Automações',
      'Seus sistemas conversando e o retrabalho manual eliminado.',
    ),
    (
      Icons.smart_toy_outlined,
      'Conteúdo em Volume com IA Própria',
      'Volume com qualidade, sem depender do seu tempo.',
    ),
    (
      Icons.code,
      'Desenvolvimento de Tecnologia Sob Medida',
      'Quando nada no mercado resolve, a gente constrói do zero.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final sideBySide = width > kLpTabletBreak;

    final left = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Eyebrow('A transformação'),
          const SizedBox(height: 20),
          Text(
            'Unimos estratégia e tecnologia para destravar a sua escala.',
            style: LpType.sectionTitle(width),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              'Entramos na sua operação, mapeamos onde está o vazamento, '
              'o que está sendo feito e os processos que deveriam ser '
              'automatizados para gerar escala de leads, vendas e faturamento.',
              style: LpType.sans(
                size: 16.5,
                weight: FontWeight.w300,
                color: LpColors.ink2,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 36),
          // Editorial remate that ties the copy to the four service cards and
          // fills the lower-left whitespace on desktop.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 34, height: 1, color: LpColors.gold),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  'Quatro frentes. Uma operação que escala sozinha.',
                  style: LpType.serif(
                    size: 19,
                    weight: FontWeight.w500,
                    color: LpColors.ink2,
                    height: 1.25,
                    italic: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final right = _FeaturesGrid(features: _features, fill: sideBySide);

    if (sideBySide) {
      return LpSection(
        background: LpColors.cream,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 9, child: left),
              SizedBox(width: lpClampVw(40, 6, 90, width)),
              Expanded(flex: 11, child: right),
            ],
          ),
        ),
      );
    }

    return LpSection(
      background: LpColors.cream,
      child: LpSplit(
        flexLeft: 9,
        flexRight: 11,
        gap: lpClampVw(40, 6, 90, width),
        left: left,
        right: right,
      ),
    );
  }
}

/// 2×2 service grid. When [fill] it stretches to the height of the adjacent
/// copy column (desktop), distributing each card's content top-to-bottom so
/// the block reads as a deliberate composition instead of leaving dead space.
class _FeaturesGrid extends StatelessWidget {
  const _FeaturesGrid({required this.features, required this.fill});

  final List<(IconData, String, String)> features;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    Widget card(int i) => Reveal(
          delayMs: 80 * (i ~/ 2 + 1),
          child: _FeatCard(
            index: i + 1,
            icon: features[i].$1,
            title: features[i].$2,
            desc: features[i].$3,
            fill: fill,
          ),
        );

    if (fill) {
      Widget row(int a, int b) => Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: card(a)),
                const SizedBox(width: 16),
                Expanded(child: card(b)),
              ],
            ),
          );
      return Column(
        children: [
          row(0, 1),
          const SizedBox(height: 16),
          row(2, 3),
        ],
      );
    }

    final cols = width <= kLpMobileBreak ? 1 : 2;
    return LpGrid(
      columns: cols,
      gap: 16,
      children: [for (var i = 0; i < features.length; i++) card(i)],
    );
  }
}

class _FeatCard extends StatelessWidget {
  const _FeatCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.desc,
    required this.fill,
  });

  final int index;
  final IconData icon;
  final String title;
  final String desc;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: kLpEase,
          transform: Matrix4.translationValues(0, hovering ? -5 : 0, 0),
          padding: const EdgeInsets.fromLTRB(26, 26, 26, 28),
          decoration: BoxDecoration(
            color: LpColors.paper,
            border: Border.all(
              color: hovering ? LpColors.gold : LpColors.lineSoft,
            ),
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color: const Color(0xFF1D1A15).withValues(alpha: 0.25),
                      blurRadius: 50,
                      spreadRadius: -30,
                      offset: const Offset(0, 24),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment:
                fill ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: kLpEase,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hovering ? LpColors.gold : Colors.transparent,
                      border: Border.all(color: LpColors.gold),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: hovering ? Colors.white : LpColors.goldDeep,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    index.toString().padLeft(2, '0'),
                    style: LpType.numeral(
                      size: 22,
                      weight: FontWeight.w500,
                      color: LpColors.gold2,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: fill ? 28 : 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: LpType.sans(
                      size: 15.5,
                      weight: FontWeight.w500,
                      color: LpColors.ink,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: LpType.sans(
                      size: 13,
                      weight: FontWeight.w300,
                      color: LpColors.ink3,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Stats bar
// ---------------------------------------------------------------------------
class Lp1StatsSection extends StatelessWidget {
  const Lp1StatsSection({super.key});

  /// (number, unit, label) — the unit is rendered in gold-deep.
  static const _stats = <(String, String, String)>[
    ('+15', 'M', 'Gerados para os clientes'),
    ('+5', '', 'Anos no mercado'),
    ('+150', '', 'Operações transformadas'),
    ('+2', 'M', 'Faturados com serviços próprios'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = lpColumns(width, wide: 4, tablet: 2, mobile: 1);
    final numSize = lpClampVw(38, 5, 62, width);

    return LpSection(
      background: LpColors.cream2,
      verticalPad: lpClampVw(50, 6, 80, width),
      child: LpGrid(
        columns: cols,
        gap: 20,
        runGap: 30,
        children: [
          for (var i = 0; i < _stats.length; i++)
            Reveal(
              delayMs: 80 * i,
              child: _StatItem(
                number: _stats[i].$1,
                unit: _stats[i].$2,
                label: _stats[i].$3,
                numSize: numSize,
                showDivider: (i + 1) % cols != 0 && i != _stats.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.number,
    required this.unit,
    required this.label,
    required this.numSize,
    required this.showDivider,
  });

  final String number;
  final String unit;
  final String label;
  final double numSize;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: LpType.numeral(
                    size: numSize,
                    weight: FontWeight.w500,
                    color: LpColors.ink,
                    height: 1,
                  ),
                  children: [
                    TextSpan(text: number),
                    if (unit.isNotEmpty)
                      TextSpan(
                        text: unit,
                        style: LpType.numeral(
                          size: numSize,
                          weight: FontWeight.w500,
                          color: LpColors.goldDeep,
                          height: 1,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label.toUpperCase(),
                style: LpType.sans(
                  size: 11,
                  weight: FontWeight.w500,
                  color: LpColors.ink3,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Positioned(
            right: -10,
            top: 8,
            bottom: 8,
            child: Container(width: 1, color: LpColors.line),
          ),
      ],
    );
  }
}

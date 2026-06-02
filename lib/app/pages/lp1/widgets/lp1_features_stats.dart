import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// "Se você" — features
// ---------------------------------------------------------------------------
class Lp1FeaturesSection extends StatelessWidget {
  const Lp1FeaturesSection({super.key});

  static const _features = <(IconData, String)>[
    (Icons.adjust, 'Posicionamento estratégico'),
    (Icons.notes, 'Conteúdos que vendem'),
    (Icons.person_outline, 'Perfil que atrai'),
    (Icons.trending_up, 'Vendas previsíveis'),
    (Icons.favorite_border, 'Relacionamento que converte'),
    (Icons.check, 'Estratégia com resultado'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = width <= kLpMobileBreak ? 1 : 2;

    return LpSection(
      background: LpColors.cream,
      child: LpSplit(
        flexLeft: 9,
        flexRight: 11,
        gap: lpClampVw(40, 6, 90, width),
        left: Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Se você'),
              const SizedBox(height: 20),
              Text(
                'Presta serviços e sente que seu Instagram ainda não trabalha '
                'por você?',
                style: LpType.sectionTitle(width),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'Eu posso te ajudar a ter um perfil que atrai os clientes '
                  'certos, comunica com clareza e converte seguidores em '
                  'oportunidades reais de negócio.',
                  style: LpType.sans(
                    size: 16.5,
                    weight: FontWeight.w300,
                    color: LpColors.ink2,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        right: LpGrid(
          columns: cols,
          gap: 16,
          children: [
            for (var i = 0; i < _features.length; i++)
              Reveal(
                delayMs: 80 * (i ~/ 2 + 1),
                child: _FeatCard(
                  icon: _features[i].$1,
                  label: _features[i].$2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeatCard extends StatelessWidget {
  const _FeatCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: kLpEase,
          transform: Matrix4.translationValues(0, hovering ? -5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
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
          child: Row(
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
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: LpType.sans(
                    size: 15,
                    weight: FontWeight.w400,
                    color: LpColors.ink,
                    height: 1.3,
                  ),
                ),
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
    ('+500', '', 'Alunas'),
    ('+3', 'M', 'Em faturamento gerado'),
    ('+98', '%', 'De satisfação'),
    ('8', ' anos', 'De mercado'),
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
                  style: LpType.serif(
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
                        style: LpType.serif(
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

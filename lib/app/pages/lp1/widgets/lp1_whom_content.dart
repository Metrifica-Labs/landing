import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// "Para quem é"
// ---------------------------------------------------------------------------
class Lp1WhomSection extends StatelessWidget {
  const Lp1WhomSection({super.key});

  static const _items = <(IconData?, String)>[
    (Icons.check_circle_outline,
        'Já faturam mas estão travados por processos manuais que não escalam.'),
    (Icons.check_circle_outline,
        'Têm sistemas que não conversam e dados espalhados em múltiplas ferramentas.'),
    (Icons.check_circle_outline,
        'Estão cansados de depender de tudo passar por eles para funcionar.'),
    (Icons.check_circle_outline,
        'Viram o concorrente crescer mais rápido e sabem que a diferença é estrutura tecnológica.'),
    (Icons.check_circle_outline,
        'Querem escalar sem contratar linearmente — dobrar faturamento sem dobrar equipe.'),
    (null,
        'Quem está começando do zero ou ainda não tem operação rodando.'),
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
            eyebrow: 'Qualificação',
            title: 'Para quem está pronto para escalar com tecnologia.',
          ),
          _EqualHeightGrid(
            columns: cols,
            gap: 16,
            items: _items,
          ),
        ],
      ),
    );
  }
}

// Grid that renders rows of cards all with the same height per row.
class _EqualHeightGrid extends StatelessWidget {
  const _EqualHeightGrid({
    required this.columns,
    required this.gap,
    required this.items,
  });

  final int columns;
  final double gap;
  final List<(IconData?, String)> items;

  @override
  Widget build(BuildContext context) {
    final rows = (items.length / columns).ceil();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var col = 0; col < columns; col++) ...[
                      if (col > 0) SizedBox(width: gap),
                      Builder(builder: (_) {
                        final i = row * columns + col;
                        if (i >= items.length) {
                          return Expanded(child: const SizedBox());
                        }
                        return Expanded(
                          child: Reveal(
                            delayMs: 80 * (col + 1),
                            child: _WhomCard(
                              icon: items[i].$1,
                              text: items[i].$2,
                              isNo: items[i].$1 == null,
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _WhomCard extends StatelessWidget {
  const _WhomCard({this.icon, required this.text, required this.isNo});

  final IconData? icon;
  final String text;
  final bool isNo;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: kLpEase,
          transform: Matrix4.translationValues(0, hovering ? -5 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
          decoration: BoxDecoration(
            color: isNo ? null : LpColors.paper,
            gradient: isNo
                ? const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFFEFE3D0), LpColors.cream2],
                  )
                : null,
            border: Border.all(
              color: isNo ? LpColors.gold : LpColors.lineSoft,
            ),
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color: const Color(0xFF1D1A15).withValues(alpha: 0.2),
                      blurRadius: 50,
                      spreadRadius: -30,
                      offset: const Offset(0, 24),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNo)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'NÃO É PARA QUEM',
                    style: LpType.sans(
                      size: 11,
                      weight: FontWeight.w600,
                      color: LpColors.goldDeep,
                      letterSpacing: 2.2,
                    ),
                  ),
                )
              else ...[
                Icon(icon, size: 30, color: LpColors.goldDeep),
                const SizedBox(height: 20),
              ],
              Text(
                text,
                style: LpType.sans(
                  size: 15.5,
                  weight: FontWeight.w300,
                  color: isNo ? LpColors.ink : LpColors.ink2,
                  height: 1.5,
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
// Content cards
// ---------------------------------------------------------------------------
class Lp1ContentSection extends StatelessWidget {
  const Lp1ContentSection({super.key, this.onContato});

  final VoidCallback? onContato;

  static const _cards = <(String, String)>[
    (
      'Diagnóstico Operacional Real',
      'Mapeamos onde estão os gargalos que travam sua escala e o que já deveria estar automatizado.'
    ),
    (
      'Automações & Integrações',
      'Fazemos seus sistemas conversarem, eliminamos o retrabalho e criamos fluxos automáticos que processam volume.'
    ),
    (
      'IA Própria para Conteúdo',
      'Nossa IA treinada com a sua voz produz volume de conteúdo com qualidade sem depender do seu tempo.'
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
            eyebrow: 'Diferenciais',
            title: 'Os diferenciais da Metrifica.',
          ),
          LpGrid(
            columns: cols,
            gap: 20,
            children: [
              for (var i = 0; i < _cards.length; i++)
                Reveal(
                  delayMs: 80 * ((i % cols) + 1),
                  child: _ContentCard(
                    title: _cards[i].$1,
                    body: _cards[i].$2,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 48),
          Reveal(
            child: LpButton(
              label: 'Quero uma vaga',
              gold: false,
              onTap: onContato,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: kLpEase,
          transform: Matrix4.translationValues(0, hovering ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: LpColors.paper,
            border: Border.all(color: LpColors.lineSoft),
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color: const Color(0xFF1D1A15).withValues(alpha: 0.25),
                      blurRadius: 60,
                      spreadRadius: -34,
                      offset: const Offset(0, 30),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  color: LpColors.cream2,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: LpColors.ink3.withValues(alpha: 0.45),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 26, 26, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: LpType.serif(
                        size: 22,
                        weight: FontWeight.w500,
                        color: LpColors.ink,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
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
              ),
            ],
          ),
        );
      },
    );
  }
}

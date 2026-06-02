import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// "Para quem é"
// ---------------------------------------------------------------------------
class Lp1WhomSection extends StatelessWidget {
  const Lp1WhomSection({super.key});

  static const _items = <(IconData?, String)>[
    (Icons.home_outlined,
        'Empresárias e prestadoras de serviços que querem vender todos os dias.'),
    (Icons.description_outlined,
        'Consultores e infoprodutores que desejam escalar o digital.'),
    (Icons.person_outline,
        'Profissionais que querem se posicionar com autoridade e estratégia.'),
    (Icons.trending_up,
        'Negócios que já faturam bem, mas querem crescer com previsibilidade.'),
    (Icons.error_outline,
        'Quem está cansada de postar sem resultado e viver de altos e baixos.'),
    (null,
        'Procura fórmulas mágicas ou quer resultado sem estratégia e sem consistência.'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = lpColumns(width, wide: 3, tablet: 2, mobile: 1);

    return LpSection(
      background: LpColors.cream,
      child: Column(
        children: [
          const LpCenteredHead(
            eyebrow: 'Para quem é',
            title: 'Feito para quem leva o próprio negócio a sério.',
          ),
          LpGrid(
            columns: cols,
            gap: 16,
            children: [
              for (var i = 0; i < _items.length; i++)
                Reveal(
                  delayMs: 80 * ((i % cols) + 1),
                  child: _WhomCard(
                    icon: _items[i].$1,
                    text: _items[i].$2,
                    isNo: _items[i].$1 == null,
                  ),
                ),
            ],
          ),
        ],
      ),
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
      'Estratégias práticas',
      'Dicas e direção para atrair clientes prontos para comprar todos os dias.'
    ),
    (
      'Bastidores & método',
      'A mentalidade e os métodos por trás de um negócio digital de sucesso.'
    ),
    (
      'Tendências & insights',
      'Análises do mercado digital e do universo High Ticket que importam.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = lpColumns(width, wide: 3, tablet: 2, mobile: 1);

    return LpSection(
      background: LpColors.cream,
      child: Column(
        children: [
          const LpCenteredHead(
            eyebrow: 'Conteúdos',
            title: 'Conteúdos que geram valor,\nconexão e resultado.',
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
              label: 'Quero receber conteúdos exclusivos',
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

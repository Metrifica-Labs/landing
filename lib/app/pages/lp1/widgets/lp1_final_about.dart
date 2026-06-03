import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// Final CTA
// ---------------------------------------------------------------------------
class Lp1FinalCtaSection extends StatelessWidget {
  const Lp1FinalCtaSection({super.key, this.onContato});

  final VoidCallback? onContato;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final h2Size = lpClampVw(32, 4.4, 58, width);

    return LpSection(
      background: LpColors.cream2,
      child: LpSplit(
        flexLeft: 11,
        flexRight: 9,
        gap: lpClampVw(40, 6, 90, width),
        crossAxisAlignment: CrossAxisAlignment.center,
        left: Reveal(
          child: Text.rich(
            TextSpan(
              style: LpType.serif(
                size: h2Size,
                weight: FontWeight.w500,
                color: LpColors.ink,
                height: 1.05,
              ),
              children: [
                const TextSpan(
                  text: 'Vagas limitadas para quem quer escalar com tecnologia, lucro e previsibilidade. ',
                ),
                TextSpan(
                  text: 'Não prometemos hype. Prometemos resultado.',
                  style: LpType.serif(
                    size: h2Size,
                    weight: FontWeight.w500,
                    color: LpColors.goldDeep,
                    height: 1.05,
                    italic: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        right: Reveal(
          delayMs: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Text(
                  'Se você quer entender exatamente onde está o gargalo '
                  'que trava a sua escala e qual tecnologia resolve isso agora.',
                  style: LpType.sans(
                    size: 16.5,
                    weight: FontWeight.w300,
                    color: LpColors.ink2,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              LpButton(
                label: 'Quero destravar minha escala agora',
                onTap: onContato,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// About
// ---------------------------------------------------------------------------
class Lp1AboutSection extends StatelessWidget {
  const Lp1AboutSection({super.key});

  static const _stats = <(String, String)>[
    ('+55M', 'Gerados para clientes'),
    ('+18', 'Anos no mercado digital'),
    ('+150', 'Operações transformadas'),
  ];

  static const _accordion = <(String, String)>[
    (
      'Diagnóstico de Gargalos Operacionais',
      'Entramos na sua operação, mapeamos o que está quebrando a escala, '
          'onde está o gargalo invisível que impede você de crescer e o que '
          'implementar de forma personalizada.'
    ),
    (
      'Integrações e Automações',
      'Fazemos os seus sistemas conversarem, eliminamos o retrabalho manual '
          'e criamos fluxos automáticos que processam volume sem precisar de '
          'mais gente. Sua operação escala sem você estar no centro de tudo.'
    ),
    (
      'Conteúdo em Volume com IA Própria',
      'Nossa IA treinada com a sua personalização produz volume de conteúdo '
          'com qualidade para suas redes sociais sem depender do seu tempo, '
          'sem perder a identidade da marca.'
    ),
    (
      'Desenvolvimento de Tecnologia Sob Medida',
      'Quando nenhuma ferramenta do mercado resolve, construímos. Sistemas, '
          'softwares e aplicativos desenvolvidos do zero para as necessidades '
          'específicas do seu negócio que viram ativos e diferenciais reais.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stacked = width <= kLpTabletBreak;

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow('Sobre nós'),
        const SizedBox(height: 18),
        Text('Metrifica', style: LpType.sectionTitle(width)),
        const SizedBox(height: 22),
        Text(
          'Somos uma empresa de tecnologia fundada por um estrategista de '
          'negócios e um gestor de tráfego que cansaram de ver empresários '
          'talentosos travados por falta de estrutura tecnológica.',
          style: _bodyStyle,
        ),
        const SizedBox(height: 14),
        Text(
          'Antes de falar de ferramenta, entendemos o negócio. Antes de '
          'implementar, diagnosticamos. Antes de cobrar, provamos que funciona.',
          style: _bodyStyle,
        ),
        const SizedBox(height: 30),
        _StatsRow(stats: _stats),
      ],
    );

    const accordion = _Accordion(items: _accordion);

    final Widget header;
    if (stacked) {
      // Photo banner fading at the bottom, intro stacked beneath it.
      header = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Reveal(
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: _AboutPhoto(axis: Axis.vertical),
            ),
          ),
          const SizedBox(height: 30),
          Reveal(delayMs: 80, child: intro),
        ],
      );
    } else {
      // Desktop: intro overlaps the open, faded right side of the photo.
      header = Reveal(
        child: Stack(
          children: [
            const AspectRatio(
              aspectRatio: 3 / 2,
              child: _AboutPhoto(axis: Axis.horizontal),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: intro,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LpSection(
      background: LpColors.cream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          SizedBox(height: stacked ? 36 : 48),
          const Reveal(delayMs: 120, child: accordion),
        ],
      ),
    );
  }

  static final TextStyle _bodyStyle = LpType.sans(
    size: 16,
    weight: FontWeight.w300,
    color: LpColors.ink2,
    height: 1.6,
  );
}

// Inline stats row (value + label) shared by the about header.
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<(String, String)> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 18,
      children: [
        for (final s in stats)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s.$1,
                style: LpType.numeral(
                  size: 34,
                  weight: FontWeight.w500,
                  color: LpColors.goldDeep,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s.$2.toUpperCase(),
                style: LpType.sans(
                  size: 11,
                  weight: FontWeight.w400,
                  color: LpColors.ink3,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// About photo — `bottom.png` with a directional fade so it melts into the
// cream section: horizontal (right edge fades) on desktop, where the intro
// copy is laid over the open faded side; vertical (bottom fades) on mobile,
// where the copy stacks beneath it.
// ---------------------------------------------------------------------------
class _AboutPhoto extends StatelessWidget {
  const _AboutPhoto({required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final horizontal = axis == Axis.horizontal;
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: horizontal ? Alignment.centerLeft : Alignment.topCenter,
        end: horizontal ? Alignment.centerRight : Alignment.bottomCenter,
        colors: const [Colors.white, Colors.white, Colors.transparent],
        stops: horizontal ? const [0.0, 0.42, 0.9] : const [0.0, 0.68, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        'assets/images/lp1/bottom.png',
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class _Accordion extends StatefulWidget {
  const _Accordion({required this.items});

  final List<(String, String)> items;

  @override
  State<_Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<_Accordion> {
  int _open = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: LpColors.line)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < widget.items.length; i++)
            _AccordionItem(
              title: widget.items[i].$1,
              body: widget.items[i].$2,
              open: _open == i,
              onTap: () => setState(() => _open = _open == i ? -1 : i),
            ),
        ],
      ),
    );
  }
}

class _AccordionItem extends StatelessWidget {
  const _AccordionItem({
    required this.title,
    required this.body,
    required this.open,
    required this.onTap,
  });

  final String title;
  final String body;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LpColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: LpType.serif(
                          size: 21,
                          weight: FontWeight.w500,
                          color: LpColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 400),
                      curve: kLpEase,
                      turns: open ? 0.125 : 0,
                      child: Text(
                        '+',
                        style: LpType.sans(
                          size: 24,
                          weight: FontWeight.w300,
                          color: LpColors.goldDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: kLpEase,
              alignment: Alignment.topCenter,
              child: open
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 22),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Text(
                          body,
                          style: LpType.sans(
                            size: 15,
                            weight: FontWeight.w300,
                            color: LpColors.ink2,
                            height: 1.6,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}

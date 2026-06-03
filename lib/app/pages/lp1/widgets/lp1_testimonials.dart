import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

class Lp1TestimonialsSection extends StatefulWidget {
  const Lp1TestimonialsSection({super.key});

  @override
  State<Lp1TestimonialsSection> createState() => _Lp1TestimonialsSectionState();
}

class _Lp1TestimonialsSectionState extends State<Lp1TestimonialsSection> {
  static const _gap = 20.0;
  static const _cards = <_Testi>[
    _Testi(
      'A Metrifica identificou em dias o que estava travando nossa operação há meses. Automatizamos processos que consumiam horas e hoje rodam sozinhos.',
      'Marcos Freitas',
      'APN — Maior imersão para empresários do Brasil',
    ),
    _Testi(
      'Finalmente temos visibilidade real da nossa operação. Os sistemas conversam, o retrabalho acabou e a escala ficou previsível.',
      'Matheus Shark',
      'Milhas Inteligentes',
    ),
    _Testi(
      'O diagnóstico foi cirúrgico. Identificaram exatamente onde estava o gargalo e implementaram a solução certa sem enrolação.',
      'Érika Aragão',
      'Cílios Design — Franquias',
    ),
    _Testi(
      'Em 30 dias automatizamos mais do que tentamos fazer em 2 anos. Resultado real, mensurável e sem precisar ampliar o time.',
      'BlitzPay',
      'Plataforma de infoprodutores — mais de R\$100M faturados',
    ),
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoplay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _perView(double width) {
    if (width <= kLpMobileBreak) return 1;
    if (width <= kLpTabletBreak) return 2;
    return 3;
  }

  int _maxIndex(double width) => math.max(0, _cards.length - _perView(width));

  void _startAutoplay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 5500), (_) {
      if (!mounted) return;
      final maxI = _maxIndex(MediaQuery.sizeOf(context).width);
      setState(() => _index = _index >= maxI ? 0 : _index + 1);
    });
  }

  void _go(int delta) {
    final maxI = _maxIndex(MediaQuery.sizeOf(context).width);
    setState(() {
      if (delta > 0) {
        _index = _index >= maxI ? 0 : _index + 1;
      } else {
        _index = _index <= 0 ? maxI : _index - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stacked = width <= kLpMobileBreak;

    final head = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Eyebrow('Prova social'),
          const SizedBox(height: 16),
          Text('Alguns nomes que já passaram por aqui.', style: LpType.sectionTitle(width)),
        ],
      ),
    );

    final nav = Reveal(
      delayMs: 80,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavButton(icon: Icons.chevron_left, onTap: () => _go(-1)),
          const SizedBox(width: 12),
          _NavButton(icon: Icons.chevron_right, onTap: () => _go(1)),
        ],
      ),
    );

    return LpSection(
      background: LpColors.cream2,
      clipChildren: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (stacked) ...[
            head,
            const SizedBox(height: 24),
            nav,
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Expanded(child: head), nav],
            ),
          const SizedBox(height: 44),
          MouseRegion(
            onEnter: (_) => _timer?.cancel(),
            onExit: (_) => _startAutoplay(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final perView = _perView(width);
                final maxI = math.max(0, _cards.length - perView);
                final index = _index.clamp(0, maxI);
                final cardW =
                    (constraints.maxWidth - _gap * (perView - 1)) / perView;
                final dx = -index * (cardW + _gap);

                return SizedBox(
                  width: constraints.maxWidth,
                  child: ClipRect(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(end: dx),
                      duration: const Duration(milliseconds: 700),
                      curve: kLpEase,
                      builder: (context, value, child) => Transform.translate(
                        offset: Offset(value, 0),
                        child: child,
                      ),
                      child: UnconstrainedBox(
                        constrainedAxis: Axis.vertical,
                        alignment: Alignment.topLeft,
                        child: IntrinsicHeight(
                         child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var i = 0; i < _cards.length; i++)
                              Padding(
                                padding: EdgeInsets.only(
                                  right: i == _cards.length - 1 ? 0 : _gap,
                                ),
                                child: SizedBox(
                                  width: cardW,
                                  child: _TestiCard(data: _cards[i]),
                                ),
                              ),
                          ],
                        ),
                       ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Testi {
  const _Testi(this.quote, this.name, this.handle);

  final String quote;
  final String name;
  final String handle;
}

class _TestiCard extends StatelessWidget {
  const _TestiCard({required this.data});

  final _Testi data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
      decoration: BoxDecoration(
        color: LpColors.paper,
        border: Border.all(color: LpColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '★★★★★',
            style: LpType.sans(
              size: 14,
              color: LpColors.gold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '"${data.quote}"',
            style: LpType.serif(
              size: 20,
              weight: FontWeight.w500,
              color: LpColors.ink,
              height: 1.35,
              italic: true,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LpColors.cream2,
                ),
                child: const Icon(Icons.person, size: 22, color: LpColors.ink3),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: LpType.sans(
                        size: 14,
                        weight: FontWeight.w500,
                        color: LpColors.ink,
                      ),
                    ),
                    Text(
                      data.handle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: LpType.sans(
                        size: 12.5,
                        weight: FontWeight.w300,
                        color: LpColors.ink3,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: kLpEase,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hovering ? LpColors.ink : Colors.transparent,
            border: Border.all(
              color: hovering ? LpColors.ink : LpColors.line,
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: hovering ? LpColors.cream : LpColors.ink,
          ),
        );
      },
    );
  }
}

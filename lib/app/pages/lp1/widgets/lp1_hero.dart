import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

class Lp1HeroSection extends StatelessWidget {
  const Lp1HeroSection({super.key, this.onContato});

  final VoidCallback? onContato;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stacked = width <= kLpTabletBreak;
    final isMobile = width <= kLpMobileBreak;

    final copy = _HeroCopy(onContato: onContato, isMobile: isMobile);
    final portrait = Reveal(
      delayMs: 160,
      child: _HeroPortrait(floatingChips: !stacked),
    );

    final Widget grid;
    if (stacked) {
      grid = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: portrait,
            ),
          ),
          const SizedBox(height: 26),
          const Reveal(delayMs: 220, child: _HeroChipsRow()),
          SizedBox(height: lpClampVw(30, 5, 70, width)),
          copy,
        ],
      );
    } else {
      grid = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 105, child: copy),
          SizedBox(width: lpClampVw(30, 5, 70, width)),
          Expanded(flex: 95, child: portrait),
        ],
      );
    }

    return Container(
      color: LpColors.cream,
      child: Stack(
        children: [
          // Bottom gradient fade into next section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 440,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      LpColors.cream.withValues(alpha: 0),
                      LpColors.cream.withValues(alpha: 0.35),
                      LpColors.cream.withValues(alpha: 0.78),
                      LpColors.cream,
                    ],
                    stops: const [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: isMobile ? 118 : 140),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: kLpMaxW),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: lpPad(width)),
                      child: grid,
                    ),
                  ),
                ),
              ),
              SizedBox(height: lpClampVw(60, 8, 110, width)),
              const Marquee(
                items: [
                  'Estratégia',
                  'Tecnologia',
                  'Automação',
                  'Integração',
                  'Escala',
                ],
              ),
              SizedBox(height: lpSectionPad(width)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({this.onContato, required this.isMobile});

  final VoidCallback? onContato;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final h1Size = isMobile
        ? lpClampVw(34, 6, 52, width)
        : lpClampVw(36, 3.6, 64, width);
    final h1 = LpType.serif(
      size: h1Size,
      weight: FontWeight.w500,
      color: LpColors.ink,
      height: 1.0,
      letterSpacing: -0.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Reveal(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 46, height: 1, color: LpColors.gold),
              const SizedBox(width: 14),
              const Flexible(
                child: Eyebrow('Estratégia, Tecnologia & Escala'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          delayMs: 80,
          child: Text.rich(
            TextSpan(
              style: h1,
              children: [
                const TextSpan(
                  text: 'Sua operação está travada porque você ainda não tem a tecnologia certa para escalar. ',
                ),
                TextSpan(
                  text: 'Você já fatura. Já tem time mas a escala está sendo um grande desafio…',
                  style: h1.copyWith(
                    fontStyle: FontStyle.italic,
                    color: LpColors.goldDeep,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Reveal(
          delayMs: 160,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'Agora é hora da tecnologia trabalhar por você: automações, '
              'integrações e sistemas que escalam a operação enquanto você '
              'foca no que realmente importa.',
              style: LpType.sans(
                size: 17,
                weight: FontWeight.w300,
                color: LpColors.ink2,
                height: 1.7,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Reveal(
          delayMs: 240,
          child: LpButton(
            label: 'Quero uma vaga',
            onTap: onContato,
          ),
        ),
        const SizedBox(height: 36),
        Reveal(delayMs: 320, child: const _HeroProof()),
      ],
    );
  }
}

class _HeroProof extends StatelessWidget {
  const _HeroProof();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42 + 30 * 2,
          height: 42,
          child: Stack(
            children: [
              for (var i = 0; i < 3; i++)
                Positioned(
                  left: i * 30,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: LpColors.cream2,
                      border: Border.all(color: LpColors.cream, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: LpColors.ink3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Flexible(
          child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text.rich(
            TextSpan(
              style: LpType.sans(
                size: 13.5,
                weight: FontWeight.w300,
                color: LpColors.ink2,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '+150 operações',
                  style: LpType.sans(
                    size: 13.5,
                    weight: FontWeight.w500,
                    color: LpColors.ink,
                    height: 1.4,
                  ),
                ),
                const TextSpan(
                  text: ' diagnosticadas e transformadas.',
                ),
              ],
            ),
          ),
          ),
        ),
      ],
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait({this.floatingChips = true});

  /// On stacked/mobile layouts the floating chips overlap the small portrait
  /// and look unpolished — they're rendered as a clean static row instead
  /// (see [_HeroChipsRow]), so the portrait suppresses them.
  final bool floatingChips;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth - 110;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // O.svg: gradiente vermelho em camada única (sem blur), com bordas
            // suaves via fade no topo e na base — sem emendas/faixas.
            Positioned(
              top: -w * 0.06,
              left: -w * 0.1,
              child: IgnorePointer(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.24, 0.62, 0.96],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xC07B2D3A),
                        Color(0x99935060),
                        Color(0x33A5455A),
                        Color(0x00AB4A60),
                      ],
                      stops: [0.0, 0.45, 0.75, 1.0],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: SvgPicture.asset(
                      'assets/images/lp1/o.svg',
                      width: w * 1.35,
                    ),
                  ),
                ),
              ),
            ),
            // The portrait itself fades out toward the bottom so its hard cut
            // dissolves into the gradient instead of showing a seam…
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 0.78, 0.94],
                colors: [
                  Colors.white,
                  Colors.white,
                  Color(0x40FFFFFF),
                  Colors.transparent,
                ],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/lp1/top_landing.png',
                width: w,
                fit: BoxFit.contain,
              ),
            ),
            // …and a cream wash sits underneath/over it finishing on opaque
            // cream, so whatever remains of the cut is fully covered.
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.55, 0.86, 1.0],
                          colors: [
                            LpColors.cream.withValues(alpha: 0),
                            LpColors.cream.withValues(alpha: 0.7),
                            LpColors.cream,
                            LpColors.cream,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Floating chips — desktop only. On stacked/mobile they're rendered
            // as a static row beneath the portrait (see [_HeroChipsRow]).
            if (floatingChips) ...[
              Positioned(
                top: w * 0.12,
                left: -w * 0.06,
                child: const FloatyChip(
                  label: '+150 operações',
                  icon: Icons.check_circle,
                  heart: false,
                  delayMs: 0,
                ),
              ),
              Positioned(
                bottom: w * 0.18,
                right: -w * 0.08,
                child: const FloatyChip(
                  label: '20h salvas/semana',
                  icon: Icons.schedule,
                  delayMs: 1400,
                ),
              ),
              Positioned(
                top: w * 0.5,
                right: -w * 0.12,
                child: const FloatyChip(
                  label: 'Nova vaga',
                  icon: Icons.send,
                  delayMs: 700,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// Static, centered chip row shown beneath the portrait on stacked/mobile
// layouts — replaces the floating chips that overlap the small portrait.
class _HeroChipsRow extends StatelessWidget {
  const _HeroChipsRow();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        FloatyChip(
          label: '+150 operações',
          icon: Icons.check_circle,
          float: false,
        ),
        FloatyChip(
          label: '20h salvas/semana',
          icon: Icons.schedule,
          float: false,
        ),
        FloatyChip(
          label: 'Nova vaga',
          icon: Icons.send,
          float: false,
        ),
      ],
    );
  }
}

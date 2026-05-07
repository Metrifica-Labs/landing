import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/pages/home/widgets/hero_3d_scene.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({
    super.key,
    required this.isMobile,
    this.onScrollToTop,
    this.onScrollToServices,
    this.onScrollToProcess,
    this.onScrollToCases,
  });

  final bool isMobile;
  final VoidCallback? onScrollToTop;
  final VoidCallback? onScrollToServices;
  final VoidCallback? onScrollToProcess;
  final VoidCallback? onScrollToCases;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEBF0FF), width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 13 : 16),
          child: MaxWidthContainer(
            maxWidth: 1280,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 32),
            child: isMobile
                ? _MobileTopBar(onScrollToTop: onScrollToTop)
                : _DesktopTopBar(
                    onScrollToTop: onScrollToTop,
                    onScrollToServices: onScrollToServices,
                    onScrollToProcess: onScrollToProcess,
                    onScrollToCases: onScrollToCases,
                  ),
          ),
        ),
      ),
    );
  }
}

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.isMobile,
    this.onScrollToServices,
  });

  final bool isMobile;
  final VoidCallback? onScrollToServices;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _HeroBackground()),
        MaxWidthContainer(
          maxWidth: 1280,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 32),
          child: Padding(
            padding: EdgeInsets.only(
              top: isMobile ? 36 : 52,
              bottom: isMobile ? 28 : 40,
            ),
            child: isMobile
                ? _MobileHeroBody(onScrollToServices: onScrollToServices)
                : _DesktopHeroBody(onScrollToServices: onScrollToServices),
          ),
        ),
      ],
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({
    this.onScrollToTop,
    this.onScrollToServices,
    this.onScrollToProcess,
    this.onScrollToCases,
  });

  final VoidCallback? onScrollToTop;
  final VoidCallback? onScrollToServices;
  final VoidCallback? onScrollToProcess;
  final VoidCallback? onScrollToCases;

  @override
  Widget build(BuildContext context) {
    final navStyle = GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1F2F52),
      letterSpacing: -0.2,
    );

    final navItems = [
      ('Serviços', onScrollToServices),
      ('Processo', onScrollToProcess),
      ('FAQ', onScrollToCases),
    ];

    return Row(
      children: [
        _LogoMark(iconSize: 52, onTap: onScrollToTop),
        const Spacer(),
        for (final item in navItems) ...[
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: item.$2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(item.$1, style: navStyle),
            ),
          ),
          const SizedBox(width: 34),
        ],
        _PrimaryButton(
          text: 'Agendar consultoria',
          onPressed: () => context.go('/contato'),
          compact: true,
        ),
      ],
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({this.onScrollToTop});

  final VoidCallback? onScrollToTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(children: [_LogoMark(iconSize: 50, onTap: onScrollToTop)]),
    );
  }
}

class _DesktopHeroBody extends StatelessWidget {
  const _DesktopHeroBody({this.onScrollToServices});

  final VoidCallback? onScrollToServices;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 640,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: -100,
            right: -360,
            width: 960,
            height: 840,
            child: Hero3DScene(),
          ),
          const Positioned(
            top: 48,
            left: 0,
            width: 640,
            child: _HeroCopy(isMobile: false),
          ),
        ],
      ),
    );
  }
}

class _MobileHeroBody extends StatelessWidget {
  const _MobileHeroBody({this.onScrollToServices});

  final VoidCallback? onScrollToServices;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          top: 12,
          right: -178,
          width: 560,
          height: 520,
          child: Hero3DScene(pointerEvents: false, opacity: 0.15),
        ),
        _HeroCopy(isMobile: true, onScrollToServices: onScrollToServices),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.isMobile, this.onScrollToServices});

  final bool isMobile;
  final VoidCallback? onScrollToServices;

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.plusJakartaSans(
      fontSize: isMobile ? 43 : 62,
      fontWeight: FontWeight.w800,
      height: isMobile ? 1.08 : 1.02,
      letterSpacing: isMobile ? -1.6 : -2.4,
      color: const Color(0xFF0B1C45),
    );

    final bodyStyle = GoogleFonts.plusJakartaSans(
      fontSize: isMobile ? 16 : 17,
      fontWeight: FontWeight.w500,
      height: isMobile ? 1.55 : 1.6,
      color: const Color(0xFF7A879F),
      letterSpacing: -0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MicroLabel(),
        SizedBox(height: isMobile ? 28 : 26),
        RichText(
          text: TextSpan(
            style: titleStyle,
            children: [
              const TextSpan(
                text:
                    'O seu negócio já cresceu.\nA tecnologia precisa acompanhar',
              ),
              TextSpan(
                text: '.',
                style: titleStyle.copyWith(color: const Color(0xFF1763FF)),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 24 : 28),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 340 : 560),
          child: Text(
            'Aqui na Metrifica construímos a sua infraestrutura tecnológica própria que sustenta seu crescimento com escala de verdade.',
            style: bodyStyle,
          ),
        ),
        SizedBox(height: isMobile ? 24 : 34),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PrimaryButton(
                    text: 'Agendar consultoria gratuita',
                    onPressed: () => context.go('/contato'),
                  ),
                  const SizedBox(height: 18),
                  _GhostLink(text: 'Ver serviços', onTap: onScrollToServices),
                ],
              )
            : Row(
                children: [
                  _PrimaryButton(
                    text: 'Agendar consultoria gratuita',
                    onPressed: () => context.go('/contato'),
                  ),
                  const SizedBox(width: 30),
                  _GhostLink(text: 'Ver serviços', onTap: onScrollToServices),
                ],
              ),
        SizedBox(height: isMobile ? 26 : 42),
        _ProofRow(isMobile: isMobile),
      ],
    );
  }
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Tecnologia própria. Construída do zero.',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: const Color(0xFF2864E8),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    this.compact = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 54 : 56,
      constraints: BoxConstraints(minWidth: compact ? 220 : 248),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A74FF), Color(0xFF1659E8)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A74FF).withValues(alpha: 0.34),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 18),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostLink extends StatelessWidget {
  const _GhostLink({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF24345A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 14),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF24345A),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProofRow extends StatelessWidget {
  const _ProofRow({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    const items = [
      'Apps desenvolvidos do zero, sem atalhos',
      'Nada de sistemas genéricos, no-code ou IA milagrosa',
      'Uma infraestrutura construída para o seu negócio',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE1E9FF)),
                  ),
                  child: Text(
                    item,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 12 : 11,
                      color: const Color(0xFF53627E),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.iconSize, this.onTap});

  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MouseCursor.defer,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(iconSize * 0.28),
            //   child: SvgPicture.asset(
            //     'assets/images/metrifica.svg',
            //     width: iconSize,
            //     height: iconSize,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // const SizedBox(width: 14),
            Text(
              'metrifica',
              style: GoogleFonts.crimsonText(
                fontSize: iconSize * 0.42,
                color: const Color(0xFF102B58),
                fontWeight: FontWeight.w700,
                height: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white],
        ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: IgnorePointer(
          child: Container(
            width: 580,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.4, -0.35),
                radius: 1.1,
                colors: [Color(0x35BFD2FF), Color(0x00BFD2FF)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

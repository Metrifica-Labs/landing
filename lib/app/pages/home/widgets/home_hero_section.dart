import 'dart:math' as math;

import 'package:flutter/material.dart';
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
        border: Border(
          bottom: BorderSide(color: Color(0xFFEBF0FF), width: 1),
        ),
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
      ('Cases', onScrollToCases),
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
          text: 'Vamos conversar',
          onPressed: () {},
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
    return Row(
      children: [
        _LogoMark(iconSize: 50, onTap: onScrollToTop),
        const Spacer(),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDCE6FF)),
          ),
          child: const Icon(
            Icons.menu_rounded,
            color: Color(0xFF4A5C81),
            size: 30,
          ),
        ),
      ],
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
            top: -118,
            right: -96,
            width: 990,
            height: 850,
            child: Hero3DScene(),
          ),
          const Positioned(
            top: 48,
            left: 0,
            width: 535,
            child: _HeroCopy(isMobile: false),
          ),
          Positioned(
            right: 64,
            bottom: 28,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 140,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF2A74FF).withValues(alpha: 0.14),
                      const Color(0xFF2A74FF).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCopy(isMobile: true, onScrollToServices: onScrollToServices),
        SizedBox(height: 12),
        SizedBox(height: 360, child: Hero3DScene()),
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
      fontSize: isMobile ? 56 : 72,
      fontWeight: FontWeight.w700,
      height: isMobile ? 1.05 : 0.98,
      letterSpacing: isMobile ? -2.4 : -3.2,
      color: const Color(0xFF0B1C45),
    );

    final bodyStyle = GoogleFonts.plusJakartaSans(
      fontSize: isMobile ? 18 : 16,
      fontWeight: FontWeight.w500,
      height: isMobile ? 1.45 : 1.55,
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
              const TextSpan(text: 'Ideias que\nmovem negocios'),
              TextSpan(
                text: '.',
                style: titleStyle.copyWith(color: const Color(0xFF1763FF)),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 24 : 28),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 340 : 490),
          child: Text(
            'Desenvolvemos solucoes digitais personalizadas para transformar ideias em resultados reais.',
            style: bodyStyle,
          ),
        ),
        SizedBox(height: isMobile ? 24 : 34),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PrimaryButton(text: 'Vamos conversar', onPressed: null),
                  const SizedBox(height: 18),
                  _GhostLink(text: 'Ver serviços', onTap: onScrollToServices),
                ],
              )
            : Row(
                children: [
                  const _PrimaryButton(text: 'Vamos conversar', onPressed: null),
                  const SizedBox(width: 30),
                  _GhostLink(text: 'Ver serviços', onTap: onScrollToServices),
                ],
              ),
        SizedBox(height: isMobile ? 26 : 42),
        _TechnologiesRow(isMobile: isMobile),
      ],
    );
  }
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'SOFTWARE QUE IMPULSIONA',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
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
      height: compact ? 56 : 58,
      constraints: BoxConstraints(minWidth: compact ? 230 : 238),
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
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: compact ? 14 : 14,
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

class _TechnologiesRow extends StatelessWidget {
  const _TechnologiesRow({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final iconColor = '9FA8BA';
    final icons = <_TechIconData>[
      _TechIconData(
        label: 'react',
        svgUrl: 'https://cdn.simpleicons.org/react/$iconColor',
      ),
      _TechIconData(
        label: 'node',
        svgUrl: 'https://cdn.simpleicons.org/nodedotjs/$iconColor',
      ),
      _TechIconData(
        label: 'ts',
        svgUrl: 'https://cdn.simpleicons.org/typescript/$iconColor',
      ),
      _TechIconData(
        label: 'js',
        svgUrl: 'https://cdn.simpleicons.org/javascript/$iconColor',
      ),
      _TechIconData(
        label: 'python',
        svgUrl: 'https://cdn.simpleicons.org/python/$iconColor',
      ),
      _TechIconData(label: 'aws', svgUrl: null),
      _TechIconData(
        label: 'docker',
        svgUrl: 'https://cdn.simpleicons.org/docker/$iconColor',
      ),
      _TechIconData(
        label: 'firebase',
        svgUrl: 'https://cdn.simpleicons.org/firebase/$iconColor',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tecnologias que utilizamos:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isMobile ? 14 : 12,
            color: const Color(0xFF98A4B8),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: isMobile ? 16 : 18,
          runSpacing: 10,
          children: icons.map((item) => _TechIcon(data: item)).toList(),
        ),
      ],
    );
  }
}

class _TechIconData {
  const _TechIconData({required this.label, required this.svgUrl});

  final String label;
  final String? svgUrl;
}

class _TechIcon extends StatelessWidget {
  const _TechIcon({required this.data});

  final _TechIconData data;

  Widget fallbackLabel() {
    return Center(
      child: Text(
        data.label.substring(0, math.min(2, data.label.length)).toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFFA0AABD),
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: data.svgUrl == null
          ? fallbackLabel()
          : Image.network(
              data.svgUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => fallbackLabel(),
            ),
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
        Container(
          width: iconSize,
          height: iconSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3690FF), Color(0xFF175BE8)],
            ),
          ),
          child: Center(
            child: Text(
              'm.',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: iconSize * 0.42,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'metrifica\nlabs',
          style: GoogleFonts.plusJakartaSans(
            fontSize: iconSize * 0.36,
            color: const Color(0xFF102B58),
            fontWeight: FontWeight.w800,
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


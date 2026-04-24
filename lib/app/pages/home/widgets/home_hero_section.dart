import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 47,
          child: Padding(
            padding: const EdgeInsets.only(top: 34, right: 42),
            child: _HeroCopy(isMobile: false, onScrollToServices: onScrollToServices),
          ),
        ),
        Expanded(
          flex: 53,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 600,
              child: ClipRect(child: _CubeCluster(isMobile: false)),
            ),
          ),
        ),
      ],
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
        SizedBox(
          height: 360,
          child: ClipRect(child: _CubeCluster(isMobile: true)),
        ),
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
      fontSize: isMobile ? 56 : 68,
      fontWeight: FontWeight.w700,
      height: 1.05,
      letterSpacing: -2.4,
      color: const Color(0xFF0B1C45),
    );

    final bodyStyle = GoogleFonts.plusJakartaSans(
      fontSize: isMobile ? 18 : 15,
      fontWeight: FontWeight.w500,
      height: 1.45,
      color: const Color(0xFF7A879F),
      letterSpacing: -0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MicroLabel(),
        SizedBox(height: isMobile ? 28 : 30),
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
        SizedBox(height: isMobile ? 24 : 32),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 340 : 460),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: data.svgUrl == null
          ? Center(
              child: Text(
                data.label
                    .substring(0, math.min(2, data.label.length))
                    .toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFA0AABD),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            )
          : SvgPicture.network(
              data.svgUrl!,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => Center(
                child: Text(
                  data.label
                      .substring(0, math.min(2, data.label.length))
                      .toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFA0AABD),
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
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
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
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

class _CubeCluster extends StatefulWidget {
  const _CubeCluster({required this.isMobile});

  final bool isMobile;

  @override
  State<_CubeCluster> createState() => _CubeClusterState();
}

class _CubeClusterState extends State<_CubeCluster>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset _pointer = Offset.zero;
  bool _hovering = false;

  static const List<_CubeData> _cubes = [
    _CubeData(left: 0.34, top: 0.05, size: 88, depth: 0.45, phase: 0.3),
    _CubeData(left: 0.46, top: 0.06, size: 112, depth: 0.9, phase: 1.1),
    _CubeData(left: 0.58, top: 0.12, size: 96, depth: 0.7, phase: 1.8),
    _CubeData(left: 0.24, top: 0.22, size: 106, depth: 0.62, phase: 2.5),
    _CubeData(left: 0.36, top: 0.22, size: 124, depth: 1.15, phase: 2.9),
    _CubeData(left: 0.50, top: 0.24, size: 142, depth: 1.25, phase: 3.2),
    _CubeData(left: 0.66, top: 0.23, size: 114, depth: 0.85, phase: 3.7),
    _CubeData(left: 0.28, top: 0.39, size: 126, depth: 1.0, phase: 4.2),
    _CubeData(left: 0.42, top: 0.40, size: 136, depth: 1.35, phase: 4.8),
    _CubeData(left: 0.57, top: 0.42, size: 132, depth: 1.18, phase: 5.2),
    _CubeData(left: 0.71, top: 0.40, size: 108, depth: 0.84, phase: 5.7),
    _CubeData(left: 0.18, top: 0.57, size: 96, depth: 0.55, phase: 0.9),
    _CubeData(left: 0.33, top: 0.56, size: 108, depth: 0.78, phase: 1.4),
    _CubeData(left: 0.48, top: 0.58, size: 140, depth: 1.28, phase: 2.1),
    _CubeData(left: 0.65, top: 0.58, size: 124, depth: 1.06, phase: 2.6),
    _CubeData(left: 0.79, top: 0.60, size: 102, depth: 0.62, phase: 3.4),
    _CubeData(left: 0.11, top: 0.73, size: 82, depth: 0.34, phase: 4.0),
    _CubeData(left: 0.35, top: 0.74, size: 114, depth: 0.94, phase: 4.4),
    _CubeData(left: 0.71, top: 0.75, size: 106, depth: 0.72, phase: 4.9),
    _CubeData(left: 0.90, top: 0.20, size: 30, depth: 0.2, phase: 5.8),
    _CubeData(left: 0.02, top: 0.64, size: 24, depth: 0.16, phase: 1.6),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePointer(Offset localPosition, Size size) {
    final dx = ((localPosition.dx / size.width) * 2 - 1).clamp(-1.0, 1.0);
    final dy = ((localPosition.dy / size.height) * 2 - 1).clamp(-1.0, 1.0);
    setState(() {
      _pointer = Offset(dx, dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() {
            _hovering = false;
            _pointer = Offset.zero;
          }),
          onHover: (event) => _updatePointer(event.localPosition, size),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final time = _controller.value * math.pi * 2;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0.1, 0.15),
                            radius: 0.62,
                            colors: [
                              const Color(0x5A2A6BFF),
                              const Color(0x002A6BFF),
                            ],
                            stops: const [0.1, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DotPainter(
                        opacity: widget.isMobile ? 0.18 : 0.28,
                      ),
                    ),
                  ),
                  for (final cube in _cubes)
                    _CubeTile(
                      data: cube,
                      time: time,
                      isMobile: widget.isMobile,
                      pointer: _hovering ? _pointer : Offset.zero,
                      sceneSize: size,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _CubeTile extends StatelessWidget {
  const _CubeTile({
    required this.data,
    required this.time,
    required this.isMobile,
    required this.pointer,
    required this.sceneSize,
  });

  final _CubeData data;
  final double time;
  final bool isMobile;
  final Offset pointer;
  final Size sceneSize;

  @override
  Widget build(BuildContext context) {
    final waveStrength = isMobile ? 6.0 : 9.0;
    final parallaxStrength = isMobile ? 9.0 : 24.0;
    final wave = math.sin(time + data.phase) * waveStrength * data.depth;
    final parallax = Offset(
      pointer.dx * parallaxStrength * data.depth,
      pointer.dy * (parallaxStrength * 0.75) * data.depth,
    );

    return Positioned(
      left: data.left * sceneSize.width,
      top: data.top * sceneSize.height,
      child: Transform.translate(
        offset: Offset(parallax.dx, parallax.dy + wave),
        child: _IsoCube(
          size: data.size * (isMobile ? 0.73 : 1),
          depth: data.depth,
        ),
      ),
    );
  }
}

class _IsoCube extends StatelessWidget {
  const _IsoCube({required this.size, required this.depth});

  final double size;
  final double depth;

  @override
  Widget build(BuildContext context) {
    final width = size * 1.18;
    final height = size * 1.2;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _IsoCubePainter(depth: depth)),
    );
  }
}

class _IsoCubePainter extends CustomPainter {
  const _IsoCubePainter({required this.depth});

  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final dx = size.width * 0.16;
    final dy = size.height * 0.13;

    final frontRect = Rect.fromLTWH(0, dy, size.width - dx, size.height - dy);

    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(const Color(0xCCFFFFFF), const Color(0xF3EBF2FF), 0.4)!,
          Color.lerp(
            const Color(0x883F79FF),
            const Color(0xE3205DFF),
            depth.clamp(0.0, 1.0),
          )!,
        ],
      ).createShader(frontRect);

    final topPath = Path()
      ..moveTo(0, dy)
      ..lineTo(dx, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - dx, dy)
      ..close();

    final sidePath = Path()
      ..moveTo(size.width - dx, dy)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - dy)
      ..lineTo(size.width - dx, size.height)
      ..close();

    final topPaint = Paint()
      ..color = Color.lerp(
        const Color(0xB8FFFFFF),
        const Color(0x85D8E8FF),
        depth * 0.7,
      )!;

    final sidePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(
            const Color(0x7CD8E7FF),
            const Color(0x905D97FF),
            depth * 0.7,
          )!,
          Color.lerp(
            const Color(0x5573A5FF),
            const Color(0x9E2B62FF),
            depth.clamp(0.0, 1.0),
          )!,
        ],
      ).createShader(Rect.fromLTWH(size.width - dx, 0, dx, size.height));

    final borderPaint = Paint()
      ..color = const Color(0xA4DDE8FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final shadowPaint = Paint()
      ..color = const Color(0x3B377AFF)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12 * depth);

    final shadowPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(8, size.height - dy + 8, size.width - dx, dy * 0.75),
          Radius.circular(dy),
        ),
      );

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawRect(frontRect, frontPaint);
    canvas.drawPath(topPath, topPaint);
    canvas.drawPath(sidePath, sidePaint);
    canvas.drawRect(frontRect, borderPaint);
    canvas.drawPath(topPath, borderPaint);
    canvas.drawPath(sidePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _IsoCubePainter oldDelegate) {
    return oldDelegate.depth != depth;
  }
}

class _CubeData {
  const _CubeData({
    required this.left,
    required this.top,
    required this.size,
    required this.depth,
    required this.phase,
  });

  final double left;
  final double top;
  final double size;
  final double depth;
  final double phase;
}

class _DotPainter extends CustomPainter {
  const _DotPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A6BFF).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    for (double x = 22; x < size.width; x += 32) {
      for (double y = 12; y < size.height; y += 32) {
        final noise = (math.sin(x * 0.08) + math.cos(y * 0.06)) * 0.12 + 0.88;
        canvas.drawCircle(Offset(x, y), 1.2 * noise, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

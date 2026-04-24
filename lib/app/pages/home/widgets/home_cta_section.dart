import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeCtaSection extends StatelessWidget {
  const HomeCtaSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7FAFF),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 22 : 32,
        vertical: isMobile ? 32 : 48,
      ),
      child: MaxWidthContainer(
        maxWidth: 1280,
        padding: EdgeInsets.zero,
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  Widget _buildDesktop() {
    return Container(
      height: 310,
      decoration: BoxDecoration(
        color: const Color(0xFF1650D4),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Content left
          Expanded(
            flex: 46,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 44),
              child: _buildContent(false),
            ),
          ),
          // Cube cluster right
          const Expanded(
            flex: 54,
            child: _CtaCubeCluster(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1650D4),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Cube cluster decorative (top-right)
          const Positioned(
            right: -20,
            top: -20,
            width: 200,
            height: 200,
            child: _CtaCubeCluster(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: _buildContent(true),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool mobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          'VAMOS CONSTRUIR',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 10),
        // Title
        Text(
          'O próximo grande\nprojeto juntos?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: mobile ? 28 : 34,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -1.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        // Subtitle
        Text(
          'Conte sua ideia e vamos transformá-la\nem um produto de impacto.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 22),
        // Button
        _CtaButton(),
      ],
    );
  }
}

class _CtaButton extends StatefulWidget {
  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFF0F5FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Iniciar projeto',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1650D4),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1650D4).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: Color(0xFF1650D4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Cube cluster ─────────────────────────────────────────────────────────────

class _CtaCubeCluster extends StatefulWidget {
  const _CtaCubeCluster();

  @override
  State<_CtaCubeCluster> createState() => _CtaCubeClusterState();
}

class _CtaCubeClusterState extends State<_CtaCubeCluster>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Cubes positioned to fill the right area densely — matches hero layout
  static const List<_CubeData> _cubes = [
    _CubeData(left: 0.00, top: 0.00, size: 82,  depth: 0.55, phase: 0.3),
    _CubeData(left: 0.14, top: -0.08, size: 104, depth: 0.90, phase: 1.1),
    _CubeData(left: 0.30, top: 0.02,  size: 88,  depth: 0.70, phase: 1.8),
    _CubeData(left: 0.46, top: -0.05, size: 96,  depth: 0.80, phase: 2.4),
    _CubeData(left: 0.62, top: 0.00,  size: 78,  depth: 0.50, phase: 3.0),
    _CubeData(left: -0.04, top: 0.25, size: 114, depth: 1.10, phase: 3.5),
    _CubeData(left: 0.12, top: 0.20,  size: 130, depth: 1.30, phase: 4.0),
    _CubeData(left: 0.30, top: 0.22,  size: 138, depth: 1.40, phase: 4.5),
    _CubeData(left: 0.50, top: 0.18,  size: 120, depth: 1.10, phase: 5.0),
    _CubeData(left: 0.68, top: 0.20,  size: 98,  depth: 0.75, phase: 5.5),
    _CubeData(left: -0.02, top: 0.52, size: 108, depth: 0.90, phase: 0.7),
    _CubeData(left: 0.15, top: 0.48,  size: 120, depth: 1.15, phase: 1.3),
    _CubeData(left: 0.34, top: 0.50,  size: 132, depth: 1.35, phase: 2.0),
    _CubeData(left: 0.54, top: 0.46,  size: 112, depth: 1.00, phase: 2.7),
    _CubeData(left: 0.70, top: 0.50,  size: 90,  depth: 0.65, phase: 3.3),
    _CubeData(left: 0.04, top: 0.76,  size: 96,  depth: 0.80, phase: 4.1),
    _CubeData(left: 0.22, top: 0.74,  size: 110, depth: 1.05, phase: 4.6),
    _CubeData(left: 0.42, top: 0.76,  size: 118, depth: 1.20, phase: 5.2),
    _CubeData(left: 0.62, top: 0.78,  size: 100, depth: 0.85, phase: 5.8),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final time = _ctrl.value * math.pi * 2;
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            return Stack(
              clipBehavior: Clip.none,
              children: _cubes
                  .map((cube) => _buildCube(cube, time, size))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildCube(_CubeData cube, double time, Size size) {
    final wave = math.sin(time + cube.phase) * 7.0 * cube.depth;
    return Positioned(
      left: cube.left * size.width,
      top: cube.top * size.height + wave,
      child: _IsoCubeOnBlue(size: cube.size, depth: cube.depth),
    );
  }
}

class _IsoCubeOnBlue extends StatelessWidget {
  const _IsoCubeOnBlue({required this.size, required this.depth});

  final double size;
  final double depth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.18,
      height: size * 1.2,
      child: CustomPaint(painter: _IsoCubeOnBluePainter(depth: depth)),
    );
  }
}

class _IsoCubeOnBluePainter extends CustomPainter {
  const _IsoCubeOnBluePainter({required this.depth});

  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final dx = size.width * 0.16;
    final dy = size.height * 0.13;

    final frontRect = Rect.fromLTWH(0, dy, size.width - dx, size.height - dy);

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

    // Front face — lighter translucent blue/white
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(
            const Color(0x55FFFFFF),
            const Color(0x2080C0FF),
            depth.clamp(0.0, 1.0),
          )!,
          Color.lerp(
            const Color(0x204A90FF),
            const Color(0x352060D0),
            depth.clamp(0.0, 1.0),
          )!,
        ],
      ).createShader(frontRect);

    // Top face — brightest, catches the most light
    final topPaint = Paint()
      ..color = Color.lerp(
        const Color(0x70FFFFFF),
        const Color(0x50B8D8FF),
        depth * 0.6,
      )!;

    // Side face — darkest, in shadow
    final sidePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(
            const Color(0x3060A0FF),
            const Color(0x183080D0),
            depth * 0.7,
          )!,
          Color.lerp(
            const Color(0x181040A0),
            const Color(0x28205090),
            depth.clamp(0.0, 1.0),
          )!,
        ],
      ).createShader(
        Rect.fromLTWH(size.width - dx, 0, dx, size.height),
      );

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Subtle drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0x200010A0)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * depth);
    final shadowPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(6, size.height - dy + 6, size.width - dx, dy * 0.6),
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
  bool shouldRepaint(covariant _IsoCubeOnBluePainter old) =>
      old.depth != depth;
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

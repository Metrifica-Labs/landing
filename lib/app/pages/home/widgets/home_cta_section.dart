import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeCtaSection extends StatelessWidget {
  const HomeCtaSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 860;
        final hPad = narrow ? 36.0 : 56.0;
        final vPad = narrow ? 36.0 : 44.0;

        return Container(
          height: narrow ? null : 310,
          decoration: BoxDecoration(
            color: const Color(0xFF1650D4),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: narrow
              ? Stack(
                  children: [
                    // Positioned(
                    //   right: -20,
                    //   top: -20,
                    //   width: 220,
                    //   height: 220,
                    //   child: _CtaHero3DDecor(),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: hPad, vertical: vPad),
                      child: _buildContent(false),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 46,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: hPad, vertical: vPad),
                        child: _buildContent(false),
                      ),
                    ),
                    // const Expanded(
                    //   flex: 54,
                    //   child: _CtaHero3DDecor(),
                    // ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildMobile() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1650D4),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: _buildContent(true),
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


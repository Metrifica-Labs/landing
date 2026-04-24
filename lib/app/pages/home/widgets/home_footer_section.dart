import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeFooterSection extends StatelessWidget {
  const HomeFooterSection({
    super.key,
    required this.isMobile,
    this.onScrollToTop,
    this.onScrollToServices,
    this.onScrollToCases,
  });

  final bool isMobile;
  final VoidCallback? onScrollToTop;
  final VoidCallback? onScrollToServices;
  final VoidCallback? onScrollToCases;

  static const _iconColor = 'A0AABD';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Main footer content
          Padding(
            padding: EdgeInsets.only(
              left: isMobile ? 22 : 32,
              right: isMobile ? 22 : 32,
              top: isMobile ? 40 : 52,
              bottom: isMobile ? 32 : 40,
            ),
            child: MaxWidthContainer(
              maxWidth: 1280,
              padding: EdgeInsets.zero,
              child: isMobile ? _buildMobile() : _buildDesktop(context),
            ),
          ),
          // Full-width divider
          Container(
            height: 1,
            color: const Color(0xFFEBF0FF),
          ),
          // Copyright bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 22 : 32,
              vertical: 18,
            ),
            child: MaxWidthContainer(
              maxWidth: 1280,
              padding: EdgeInsets.zero,
              child: Text(
                '© 2025 Metrifica Labs. Todos os direitos reservados.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: const Color(0xFFB0BAD0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Expanded(flex: 30, child: _buildBrand()),
        const SizedBox(width: 48),
        // Nav links
        Expanded(flex: 16, child: _buildLinks()),
        const SizedBox(width: 32),
        // Contact
        Expanded(flex: 34, child: _buildContact()),
        // Social icons flush to right
        _buildSocial(),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrand(),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLinks()),
            Expanded(child: _buildContact()),
          ],
        ),
        const SizedBox(height: 28),
        _buildSocial(),
      ],
    );
  }

  Widget _buildBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo — same mark as navbar
        GestureDetector(
          onTap: onScrollToTop,
          child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
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
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'metrifica\nlabs',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 0.95,
                letterSpacing: -0.2,
                color: const Color(0xFF0B1C45),
              ),
            ),
          ],
        ),
        ),
        const SizedBox(height: 14),
        Text(
          'Transformamos ideias em\nsoluções digitais de alto impacto.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.55,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA0AABD),
          ),
        ),
      ],
    );
  }

  Widget _buildLinks() {
    final links = [
      ('Serviços', onScrollToServices),
      ('Cases', onScrollToCases),
      ('Carreiras', null),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: links
          .map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: InkWell(
                onTap: link.$2,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  link.$1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3D4E70),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactRow(
          svgUrl: 'https://cdn.simpleicons.org/maildotru/$_iconColor',
          label: 'em',
          text: 'hello@metricalabs.com',
        ),
        const SizedBox(height: 11),
        _ContactRow(
          icon: Icons.phone_outlined,
          text: '+55 (11) 99999-9999',
        ),
        const SizedBox(height: 11),
        _ContactRow(
          icon: Icons.location_on_outlined,
          text: 'São Paulo, Brasil',
        ),
      ],
    );
  }

  Widget _buildSocial() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIconBox(
          svgUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v11/icons/linkedin.svg',
          label: 'in',
        ),
        const SizedBox(width: 10),
        _SocialIconBox(
          svgUrl: 'https://cdn.simpleicons.org/github/$_iconColor',
          label: 'gh',
        ),
        const SizedBox(width: 10),
        _SocialIconBox(
          svgUrl: 'https://cdn.simpleicons.org/instagram/$_iconColor',
          label: 'ig',
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    this.svgUrl,
    this.icon,
    this.label,
    required this.text,
  }) : assert(svgUrl != null || icon != null);

  final String? svgUrl;
  final IconData? icon;
  final String? label;
  final String text;

  Widget _fallbackDot() {
    return const Icon(
      Icons.circle_outlined,
      size: 14,
      color: Color(0xFFA0AABD),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: svgUrl != null
              ? Image.network(
                  svgUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _fallbackDot(),
                )
              : Icon(
                  icon,
                  size: 15,
                  color: const Color(0xFFA0AABD),
                ),
        ),
        const SizedBox(width: 9),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7A99),
          ),
        ),
      ],
    );
  }
}

class _SocialIconBox extends StatefulWidget {
  const _SocialIconBox({required this.svgUrl, required this.label});

  final String svgUrl;
  final String label;

  @override
  State<_SocialIconBox> createState() => _SocialIconBoxState();
}

class _SocialIconBoxState extends State<_SocialIconBox> {
  bool _hovered = false;

  Widget _fallbackLabel() {
    return Text(
      widget.label.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFA0AABD),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFEDF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? const Color(0xFF2864E8).withValues(alpha: 0.3)
                : const Color(0xFFDDE4F0),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Image.network(
            widget.svgUrl,
            width: 15,
            height: 15,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _fallbackLabel(),
          ),
        ),
      ),
    );
  }
}

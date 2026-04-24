import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _services = [
    _ServiceData(
      icon: Icons.code_rounded,
      title: 'Desenvolvimento\nde Software',
      description: 'Soluções robustas e personalizadas.',
    ),
    _ServiceData(
      icon: Icons.devices_rounded,
      title: 'Web & Mobile',
      description: 'Aplicações rápidas, intuitivas e responsivas.',
    ),
    _ServiceData(
      icon: Icons.cloud_rounded,
      title: 'Cloud & DevOps',
      description: 'Infraestrutura escalável, segura e eficiente.',
    ),
    _ServiceData(
      icon: Icons.bar_chart_rounded,
      title: 'Dados & Analytics',
      description: 'Decisões inteligentes com base em dados reais.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 96),
      child: MaxWidthContainer(
        maxWidth: 1280,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 32),
        child: Column(
          children: [
            Text(
              'O QUE FAZEMOS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: const Color(0xFF2864E8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Soluções completas para cada\netapa do seu negócio.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isMobile ? 28 : 40,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -1.2,
                color: const Color(0xFF0B1C45),
              ),
            ),
            SizedBox(height: isMobile ? 40 : 60),
            isMobile ? _buildMobileCards() : _buildDesktopCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _services
          .map(
            (s) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _ServiceCard(data: s),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMobileCards() {
    return Column(
      children: _services
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ServiceCard(data: s),
            ),
          )
          .toList(),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard({required this.data});

  final _ServiceData data;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _hovered ? -8 : 0),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        builder: (context, offset, child) => Transform.translate(
          offset: Offset(0, offset),
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(28),
          constraints: const BoxConstraints(minHeight: 260),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF2864E8).withValues(alpha: 0.3)
                  : const Color(0xFFE4EAFF),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A2B5E).withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: _hovered
                    ? const Color(0xFF2864E8).withValues(alpha: 0.1)
                    : const Color(0xFF1A2B5E).withValues(alpha: 0.04),
                blurRadius: _hovered ? 30 : 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF2FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.data.icon,
                  color: const Color(0xFF2864E8),
                  size: 26,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.data.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: const Color(0xFF0B1C45),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.data.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: const Color(0xFF7A879F),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF2864E8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceData {
  const _ServiceData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

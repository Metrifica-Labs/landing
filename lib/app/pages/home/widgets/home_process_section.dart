import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeProcessSection extends StatelessWidget {
  const HomeProcessSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _steps = [
    _StepData(
      number: '01',
      icon: Icons.search_rounded,
      title: 'Descobrir',
      description: 'Entendemos seu desafio e objetivos.',
    ),
    _StepData(
      number: '02',
      icon: Icons.edit_rounded,
      title: 'Planejar',
      description: 'Definimos a estratégia e o escopo.',
    ),
    _StepData(
      number: '03',
      icon: Icons.code_rounded,
      title: 'Desenvolver',
      description: 'Construímos com qualidade, testes e transparência.',
    ),
    _StepData(
      number: '04',
      icon: Icons.send_rounded,
      title: 'Entregar',
      description: 'Lançamos, suportamos e evoluímos junto com você.',
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
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(),
              const SizedBox(height: 16),
              _title(38),
              const SizedBox(height: 52),
              _DesktopTimeline(steps: _steps),
            ],
          ),
        ),
        const SizedBox(width: 48),
        const Expanded(
          flex: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: _BlueprintCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(),
        const SizedBox(height: 16),
        _title(28),
        const SizedBox(height: 40),
        _MobileTimeline(steps: _steps),
        const SizedBox(height: 40),
        const Center(child: _BlueprintCard()),
      ],
    );
  }

  Widget _sectionLabel() {
    return Text(
      'NOSSO PROCESSO',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: const Color(0xFF2864E8),
      ),
    );
  }

  Widget _title(double fontSize) {
    return Text(
      'Do conceito ao código.\nCom clareza e colaboração.',
      style: GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1.0,
        color: const Color(0xFF0B1C45),
      ),
    );
  }
}

class _DesktopTimeline extends StatelessWidget {
  const _DesktopTimeline({required this.steps});

  final List<_StepData> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icons row with connecting lines
        Row(
          children: steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2864E8),
                    ),
                    child: Icon(step.icon, color: Colors.white, size: 24),
                  ),
                  if (i < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: const Color(0xFFCBD9FF),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        // Text row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: steps
              .map(
                (step) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.number,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: const Color(0xFF2864E8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0B1C45),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.description,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.4,
                            color: const Color(0xFF7A879F),
                          ),
                        ),
                      ],
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

class _MobileTimeline extends StatelessWidget {
  const _MobileTimeline({required this.steps});

  final List<_StepData> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key;
        final step = entry.value;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2864E8),
                  ),
                  child: Icon(step.icon, color: Colors.white, size: 22),
                ),
                if (i < steps.length - 1)
                  Container(
                    width: 2,
                    height: 36,
                    color: const Color(0xFFCBD9FF),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: i < steps.length - 1 ? 0 : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.number,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: const Color(0xFF2864E8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B1C45),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        step.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          height: 1.4,
                          color: const Color(0xFF7A879F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _BlueprintCard extends StatelessWidget {
  const _BlueprintCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < 400 ? constraints.maxWidth : 400.0;

        return SizedBox(
          height: size,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFF082B62),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0B1C45).withValues(alpha: 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/blueprint.png',
                width: size,
                height: size,
                fit: BoxFit.cover,
                isAntiAlias: true,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StepData {
  const _StepData({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeCasesSection extends StatelessWidget {
  const HomeCasesSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _cases = [
    _CaseData(
      category: 'FINTECH',
      categoryColor: Color(0xFF2864E8),
      title: 'Plataforma de Gestão Financeira',
      description:
          'Solução completa para controle financeiro empresarial com analytics em tempo real.',
    ),
    _CaseData(
      category: 'SAÚDE',
      categoryColor: Color(0xFF0D9E78),
      title: 'Aplicativo de Telemedicina',
      description:
          'Conectando pacientes e profissionais de forma simples, segura e eficiente.',
    ),
    _CaseData(
      category: 'EDUCAÇÃO',
      categoryColor: Color(0xFF7B3FE4),
      title: 'Plataforma de Ensino',
      description:
          'Conectamos alunos e professores em uma experiência moderna e envolvente.',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(),
              const SizedBox(height: 16),
              _title(32),
              const SizedBox(height: 16),
              Text(
                'Soluções que impulsionam negócios e conectam pessoas.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF7A879F),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _AllCasesLink(),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _cases
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: _CaseCard(data: c),
                    ),
                  ),
                )
                .toList(),
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
        const SizedBox(height: 32),
        ..._cases.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _CaseCard(data: c),
          ),
        ),
        _AllCasesLink(),
      ],
    );
  }

  Widget _sectionLabel() {
    return Text(
      'CASES',
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
      'Resultados que\ngeram impacto.',
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

class _AllCasesLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ver todos os cases',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2864E8),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: Color(0xFF2864E8),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.data});

  final _CaseData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4EAFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2B5E).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: data.categoryColor.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(19),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.web_rounded,
                size: 44,
                color: data.categoryColor.withValues(alpha: 0.25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.category,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: data.categoryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    letterSpacing: -0.3,
                    color: const Color(0xFF0B1C45),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: const Color(0xFF7A879F),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver case',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2864E8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF2864E8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseData {
  const _CaseData({
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.description,
  });

  final String category;
  final Color categoryColor;
  final String title;
  final String description;
}

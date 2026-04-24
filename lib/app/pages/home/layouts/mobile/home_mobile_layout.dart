import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_cases_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_cta_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_footer_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_hero_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_process_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_services_section.dart';

class HomeMobileLayout extends StatelessWidget {
  const HomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              HomeHeroSection(isMobile: true),
              HomeServicesSection(isMobile: true),
              HomeProcessSection(isMobile: true),
              HomeCasesSection(isMobile: true),
              HomeCtaSection(isMobile: true),
              HomeFooterSection(isMobile: true),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_cases_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_cta_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_footer_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_hero_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_process_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_services_section.dart';

class HomeWebLayout extends StatelessWidget {
  const HomeWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HomeHeroSection(isMobile: false),
            HomeServicesSection(isMobile: false),
            HomeProcessSection(isMobile: false),
            HomeCasesSection(isMobile: false),
            HomeCtaSection(isMobile: false),
            HomeFooterSection(isMobile: false),
          ],
        ),
      ),
    );
  }
}

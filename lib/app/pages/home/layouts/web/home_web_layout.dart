import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_hero_section.dart';

class HomeWebLayout extends StatelessWidget {
  const HomeWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeHeroSection(isMobile: false);
  }
}

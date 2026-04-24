import 'package:flutter/material.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_cases_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_cta_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_footer_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_hero_section.dart'
    show HomeHeroSection, HomeNavBar;
import 'package:metrifica_landing/app/pages/home/widgets/home_process_section.dart';
import 'package:metrifica_landing/app/pages/home/widgets/home_services_section.dart';

class HomeWebLayout extends StatefulWidget {
  const HomeWebLayout({super.key});

  @override
  State<HomeWebLayout> createState() => _HomeWebLayoutState();
}

class _HomeWebLayoutState extends State<HomeWebLayout> {
  static const double _navBarHeight = 89;

  final _scrollCtrl = ScrollController();
  final _servicesKey = GlobalKey();
  final _processKey = GlobalKey();
  final _casesKey = GlobalKey();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToTop() {
    _scrollCtrl.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              child: Column(
                children: [
                  const SizedBox(height: _navBarHeight),
                  HomeHeroSection(
                    isMobile: false,
                    onScrollToServices: () => _scrollTo(_servicesKey),
                  ),
                  HomeServicesSection(key: _servicesKey, isMobile: false),
                  HomeProcessSection(key: _processKey, isMobile: false),
                  HomeCasesSection(key: _casesKey, isMobile: false),
                  const HomeCtaSection(isMobile: false),
                  HomeFooterSection(
                    isMobile: false,
                    onScrollToTop: _scrollToTop,
                    onScrollToServices: () => _scrollTo(_servicesKey),
                    onScrollToCases: () => _scrollTo(_casesKey),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeNavBar(
              isMobile: false,
              onScrollToTop: _scrollToTop,
              onScrollToServices: () => _scrollTo(_servicesKey),
              onScrollToProcess: () => _scrollTo(_processKey),
              onScrollToCases: () => _scrollTo(_casesKey),
            ),
          ),
        ],
      ),
    );
  }
}

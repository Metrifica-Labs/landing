import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_features_stats.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_final_about.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_footer.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_hero.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_manifesto_steps.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_method_invest.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_nav.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_testimonials.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_whom_content.dart';

/// Full ÓRDINARE landing assembled in scroll order with a fixed, scroll-aware
/// nav. Sections are internally responsive (3 → 2 → 1 columns), so the same
/// tree serves both the web and mobile layouts; [isMobile] only switches the
/// nav between the full bar and the burger menu.
class Lp1Scaffold extends StatefulWidget {
  const Lp1Scaffold({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<Lp1Scaffold> createState() => _Lp1ScaffoldState();
}

class _Lp1ScaffoldState extends State<Lp1Scaffold> {
  final _scrollCtrl = ScrollController();
  final _offset = ValueNotifier<double>(0);

  final _sobreKey = GlobalKey();
  final _metodoKey = GlobalKey();
  final _investKey = GlobalKey();
  final _mentoriaKey = GlobalKey();
  final _contatoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() => _offset.value = _scrollCtrl.offset);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _offset.dispose();
    super.dispose();
  }

  void _scrollToTop() => _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    void contato() => _scrollTo(_contatoKey);

    return Scaffold(
      backgroundColor: LpColors.cream,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              child: LpScrollScope(
                offset: _offset,
                child: Column(
                  children: [
                    Lp1HeroSection(onContato: contato),
                    KeyedSubtree(
                      key: _sobreKey,
                      child: const RepaintBoundary(child: Lp1FeaturesSection()),
                    ),
                    const RepaintBoundary(child: Lp1StatsSection()),
                    KeyedSubtree(
                      key: _metodoKey,
                      child: RepaintBoundary(
                        child: Lp1MethodSection(
                          onInvest: () => _scrollTo(_investKey),
                        ),
                      ),
                    ),
                    KeyedSubtree(
                      key: _investKey,
                      child: RepaintBoundary(
                        child: Lp1InvestSection(onContato: contato),
                      ),
                    ),
                    const RepaintBoundary(child: Lp1WhomSection()),
                    KeyedSubtree(
                      key: _mentoriaKey,
                      child: RepaintBoundary(
                        child: Lp1ContentSection(onContato: contato),
                      ),
                    ),
                    const RepaintBoundary(child: Lp1TestimonialsSection()),
                    const RepaintBoundary(child: Lp1ManifestoSection()),
                    const RepaintBoundary(child: Lp1StepsSection()),
                    KeyedSubtree(
                      key: _contatoKey,
                      child: RepaintBoundary(
                        child: Lp1FinalCtaSection(onContato: contato),
                      ),
                    ),
                    const RepaintBoundary(child: Lp1AboutSection()),
                    const RepaintBoundary(child: Lp1FooterSection()),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Lp1Nav(
              offset: _offset,
              isMobile: widget.isMobile,
              onTop: _scrollToTop,
              onSobre: () => _scrollTo(_sobreKey),
              onMetodo: () => _scrollTo(_metodoKey),
              onInvest: () => _scrollTo(_investKey),
              onMentoria: () => _scrollTo(_mentoriaKey),
              onContato: contato,
            ),
          ),
        ],
      ),
    );
  }
}

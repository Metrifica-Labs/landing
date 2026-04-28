import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeServicesSection extends StatefulWidget {
  const HomeServicesSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<HomeServicesSection> createState() => _HomeServicesSectionState();
}

class _HomeServicesSectionState extends State<HomeServicesSection> {
  Timer? _animationTimer;
  int _activeIndex = -1;

  static const _services = [
    _ServiceData(
      type: _ServiceType.software,
      title: 'Back-end & Arquitetura',
      description:
          'Infraestrutura desenvolvida do zero para sustentar crescimento no longo prazo, sem reescrever tudo do início.',
      highlights: [
        _ServiceHighlight(Icons.view_in_ar_rounded, 'Código real'),
        _ServiceHighlight(Icons.shield_outlined, 'Arquitetura segura'),
        _ServiceHighlight(Icons.speed_rounded, 'Escala'),
      ],
      desktopFlex: 7,
    ),
    _ServiceData(
      type: _ServiceType.webMobile,
      title: 'Front-end & Produto',
      description:
          'Dashboards, portais e ferramentas internas criados para o fluxo real da operação.',
      highlights: [
        _ServiceHighlight(Icons.check_circle_outline_rounded, 'Uso real'),
        _ServiceHighlight(Icons.check_circle_outline_rounded, 'UX operacional'),
        _ServiceHighlight(Icons.check_circle_outline_rounded, 'Produto'),
      ],
      desktopFlex: 4,
    ),
    _ServiceData(
      type: _ServiceType.cloud,
      title: 'Automação & Integração',
      description:
          'Processos que rodam sem depender de ninguém, com dados integrados e menos retrabalho.',
      highlights: [
        _ServiceHighlight(Icons.settings_suggest_rounded, 'Automação'),
        _ServiceHighlight(Icons.all_inclusive_rounded, 'Integrações'),
        _ServiceHighlight(Icons.lock_outline_rounded, 'Menos manual'),
      ],
      desktopFlex: 5,
    ),
    _ServiceData(
      type: _ServiceType.data,
      title: 'Segurança de Dados',
      description:
          'Controle de acesso, criptografia, auditoria e LGPD como fundação da arquitetura.',
      highlights: [
        _ServiceHighlight(Icons.storage_rounded, 'LGPD'),
        _ServiceHighlight(Icons.track_changes_rounded, 'Auditoria'),
        _ServiceHighlight(Icons.av_timer_rounded, 'Proteção'),
      ],
      desktopFlex: 7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAnimationTimer();
  }

  @override
  void didUpdateWidget(covariant HomeServicesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMobile != widget.isMobile) {
      _startAnimationTimer();
    }
  }

  void _startAnimationTimer() {
    _animationTimer?.cancel();
    _animationTimer = null;

    if (widget.isMobile) {
      _activeIndex = -1;
      return;
    }

    _activeIndex = 0;
    _animationTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (!mounted) return;
      setState(() => _activeIndex = (_activeIndex + 1) % _services.length);
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFBFCFF),
      padding: EdgeInsets.symmetric(vertical: widget.isMobile ? 72 : 112),
      child: MaxWidthContainer(
        maxWidth: 1280,
        padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 22 : 32),
        child: Column(
          crossAxisAlignment: widget.isMobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            _SectionHeader(isMobile: widget.isMobile),
            SizedBox(height: widget.isMobile ? 36 : 56),
            widget.isMobile
                ? _MobileBentoGrid(
                    services: _services,
                    activeIndex: _activeIndex,
                  )
                : _DesktopBentoGrid(
                    services: _services,
                    activeIndex: _activeIndex,
                  ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          'O QUE FAZEMOS',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
            color: const Color(0xFF2864E8),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(
            'Construímos sua tecnologia própria sob medida para a escala da sua empresa.',
            textAlign: isMobile ? TextAlign.left : TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 30 : 40,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1.3,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            isMobile
                ? 'Sem no-code como solução final. Sem sistemas genéricos. Sem IA milagrosa. Código real para funcionar com segurança, performance e escala.'
                : 'Sem no-code como solução final. Sem sistemas genéricos. Sem IA milagrosa. O seu sistema é desenvolvido do zero para funcionar exatamente como o seu negócio precisa.',
            textAlign: isMobile ? TextAlign.left : TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.6,
              color: const Color(0xFF8A95AA),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopBentoGrid extends StatelessWidget {
  const _DesktopBentoGrid({required this.services, required this.activeIndex});

  final List<_ServiceData> services;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1120) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    RepaintBoundary(
                      child: _BentoServiceCard(
                        data: services[0],
                        active: activeIndex == 0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    RepaintBoundary(
                      child: _BentoServiceCard(
                        data: services[2],
                        active: activeIndex == 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    RepaintBoundary(
                      child: _BentoServiceCard(
                        data: services[1],
                        active: activeIndex == 1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    RepaintBoundary(
                      child: _BentoServiceCard(
                        data: services[3],
                        active: activeIndex == 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: services[0].desktopFlex,
                  child: RepaintBoundary(
                    child: _BentoServiceCard(
                      data: services[0],
                      active: activeIndex == 0,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: services[1].desktopFlex,
                  child: RepaintBoundary(
                    child: _BentoServiceCard(
                      data: services[1],
                      active: activeIndex == 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: services[2].desktopFlex,
                  child: RepaintBoundary(
                    child: _BentoServiceCard(
                      data: services[2],
                      active: activeIndex == 2,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: services[3].desktopFlex,
                  child: RepaintBoundary(
                    child: _BentoServiceCard(
                      data: services[3],
                      active: activeIndex == 3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MobileBentoGrid extends StatelessWidget {
  const _MobileBentoGrid({required this.services, required this.activeIndex});

  final List<_ServiceData> services;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < services.length; i++) ...[
          RepaintBoundary(
            child: _BentoServiceCard(
              data: services[i],
              compact: true,
              active: activeIndex == i,
            ),
          ),
          const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _BentoServiceCard extends StatefulWidget {
  const _BentoServiceCard({
    required this.data,
    required this.active,
    this.compact = false,
  });

  final _ServiceData data;
  final bool active;
  final bool compact;

  @override
  State<_BentoServiceCard> createState() => _BentoServiceCardState();
}

class _BentoServiceCardState extends State<_BentoServiceCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = widget.compact || constraints.maxWidth < 380;
        final active = widget.active;
        final cardHeight = widget.compact ? null : (isCompact ? 520.0 : 320.0);
        final visualWidth = isCompact
            ? double.infinity
            : (constraints.maxWidth * 0.38).clamp(150.0, 210.0).toDouble();
        final contentGap = constraints.maxWidth < 500 ? 20.0 : 26.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          height: cardHeight,
          padding: EdgeInsets.all(isCompact ? 20 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: active ? const Color(0xFFD7E2FF) : const Color(0xFFEAF0FB),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0B1C45).withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(
                  0xFF2864E8,
                ).withValues(alpha: active ? 0.09 : 0.02),
                blurRadius: active ? 42 : 20,
                offset: Offset(0, active ? 22 : 10),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Flex(
                direction: isCompact ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isCompact)
                    _ServiceCopy(
                      data: widget.data,
                      hovered: active,
                      compact: true,
                    )
                  else
                    Expanded(
                      flex: 5,
                      child: _ServiceCopy(data: widget.data, hovered: active),
                    ),
                  SizedBox(
                    width: isCompact ? 0 : contentGap,
                    height: isCompact ? 22 : 0,
                  ),
                  if (isCompact && !widget.compact) const Spacer(),
                  SizedBox(
                    width: visualWidth,
                    height: isCompact ? 180 : double.infinity,
                    child: _VisualShowcase(
                      type: widget.data.type,
                      hovered: active,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceCopy extends StatelessWidget {
  const _ServiceCopy({
    required this.data,
    required this.hovered,
    this.compact = false,
  });

  final _ServiceData data;
  final bool hovered;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dense = compact || constraints.maxWidth < 300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: compact
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.easeOutCubic,
                    width: hovered ? 48 : 24,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2864E8),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                SizedBox(height: dense ? 20 : 24),
                Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: dense ? 20 : 21,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: -0.7,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.description,
                  maxLines: dense ? 4 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: dense ? 13 : 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.42,
                    color: const Color(0xFF69758B),
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 16 : 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 1, color: const Color(0xFFE5ECFA)),
                SizedBox(height: dense ? 12 : 16),
                _ServiceHighlights(highlights: data.highlights, dense: dense),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ServiceHighlights extends StatelessWidget {
  const _ServiceHighlights({required this.highlights, required this.dense});

  final List<_ServiceHighlight> highlights;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    if (dense) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final highlight in highlights) ...[
            _ServiceHighlightItem(highlight: highlight, dense: true),
            if (highlight != highlights.last) const SizedBox(height: 8),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 14,
      runSpacing: 12,
      children: [
        for (final highlight in highlights)
          _ServiceHighlightItem(highlight: highlight, dense: false),
      ],
    );
  }
}

class _ServiceHighlightItem extends StatelessWidget {
  const _ServiceHighlightItem({required this.highlight, required this.dense});

  final _ServiceHighlight highlight;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dense ? 18 : 30,
          height: dense ? 18 : 30,
          decoration: BoxDecoration(
            color: dense ? Colors.transparent : const Color(0xFFF4F7FF),
            borderRadius: BorderRadius.circular(dense ? 99 : 8),
            border: dense ? null : Border.all(color: const Color(0xFFDDE8FF)),
          ),
          child: Icon(
            highlight.icon,
            color: const Color(0xFF2864E8),
            size: dense ? 15 : 16,
          ),
        ),
        SizedBox(width: dense ? 6 : 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              highlight.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: dense ? 11.5 : 12,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: const Color(0xFF66758D),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VisualShowcase extends StatelessWidget {
  const _VisualShowcase({required this.type, required this.hovered});

  final _ServiceType type;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: hovered ? Colors.white : const Color(0xFFF8FAFE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAF0FB)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: const CustomPaint(painter: _DotGridPainter()),
            ),
          ),
          switch (type) {
            _ServiceType.software => _SoftwareShowcase(hovered: hovered),
            _ServiceType.webMobile => _WebMobileShowcase(hovered: hovered),
            _ServiceType.cloud => _CloudShowcase(hovered: hovered),
            _ServiceType.data => _DataShowcase(hovered: hovered),
          },
        ],
      ),
    );
  }
}

class _SoftwareShowcase extends StatelessWidget {
  const _SoftwareShowcase({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: hovered ? 1 : 0),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(0.18 * t)
            ..translate(0.0, -8.0 * t),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 84 + (34 * t),
                height: 62 + (14 * t),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.24),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        _WindowDot(color: Color(0xFFEF4444)),
                        SizedBox(width: 4),
                        _WindowDot(color: Color(0xFFFACC15)),
                        SizedBox(width: 4),
                        _WindowDot(color: Color(0xFF22C55E)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _AnimatedLine(
                      width: 62 * t,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 7),
                    _AnimatedLine(
                      width: 48 * t,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -12,
                bottom: -10,
                child: Transform.scale(
                  scale: 0.5 + (0.5 * t),
                  child: Opacity(
                    opacity: t,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2864E8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2864E8,
                            ).withValues(alpha: 0.28),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.memory_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WebMobileShowcase extends StatelessWidget {
  const _WebMobileShowcase({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: hovered ? 1 : 0),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Transform.scale(
          scale: 1 + (0.08 * t),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.translate(
                offset: Offset(-7 * t, 0),
                child: Container(
                  width: 104,
                  height: 74,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Color.lerp(
                        const Color(0xFFE2E8F0),
                        const Color(0xFF60A5FA),
                        t,
                      )!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 60,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 28,
                        child: Transform.scale(
                          scale: 1 + (0.22 * t),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDBEAFE),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 13,
                        child: _AnimatedLine(
                          width: 44 + (20 * t),
                          color: const Color(0xFFE2E8F0),
                          height: 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -12,
                bottom: -16,
                child: Transform.rotate(
                  angle: -0.08 * t,
                  child: Transform.translate(
                    offset: Offset(0, -7 * t),
                    child: Container(
                      width: 38,
                      height: 66,
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.24),
                            blurRadius: 20,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 16,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Transform.scale(
                            scale: t,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2864E8),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CloudShowcase extends StatelessWidget {
  const _CloudShowcase({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: hovered ? 1 : 0),
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(
                        width: 1,
                        height: 128 * t * (0.72 + (i * 0.14)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF2864E8).withValues(alpha: 0.32),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -14 * t),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.78),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2864E8).withValues(alpha: 0.1),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.cloud_rounded,
                      size: 39,
                      color: Color.lerp(
                        const Color(0xFF94A3B8),
                        const Color(0xFF2864E8),
                        t,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -12,
                    right: -12,
                    child: Opacity(
                      opacity: t,
                      child: Transform.rotate(
                        angle: 3.14 * t,
                        child: const Icon(
                          Icons.settings_rounded,
                          color: Color(0xFF60A5FA),
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DataShowcase extends StatelessWidget {
  const _DataShowcase({required this.hovered});

  final bool hovered;

  static const _bars = [0.42, 0.74, 0.54, 0.96, 0.68, 0.88];
  static const _line = [0.72, 0.46, 0.58, 0.28, 0.42, 0.2];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: hovered ? 1 : 0),
      duration: const Duration(milliseconds: 820),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 54, 30, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < _bars.length; i++) ...[
                      Expanded(
                        child: _DataBar(
                          hovered: hovered,
                          value: _bars[i],
                          index: i,
                        ),
                      ),
                      if (i != _bars.length - 1) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
                child: CustomPaint(
                  painter: _DataLinePainter(points: _line, progress: t),
                ),
              ),
            ),
            Positioned(
              top: 18 - (6 * t),
              right: 18 - (4 * t),
              child: Opacity(
                opacity: t.clamp(0, 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '+37.8%',
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DataBar extends StatelessWidget {
  const _DataBar({
    required this.hovered,
    required this.value,
    required this.index,
  });

  final bool hovered;
  final double value;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: hovered ? value : 0.16),
      duration: Duration(milliseconds: 560 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, height, _) {
        return Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(7),
          ),
          child: FractionallySizedBox(
            heightFactor: height.clamp(0.12, 1),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF60A5FA), Color(0xFF2864E8)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2864E8).withValues(alpha: 0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DataLinePainter extends CustomPainter {
  const _DataLinePainter({required this.points, required this.progress});

  final List<double> points;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2 || progress <= 0) return;

    final offsets = [
      for (var i = 0; i < points.length; i++)
        Offset(
          points.length == 1
              ? size.width / 2
              : (size.width / (points.length - 1)) * i,
          size.height * points[i],
        ),
    ];
    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (var i = 0; i < offsets.length - 1; i++) {
      final current = offsets[i];
      final next = offsets[i + 1];
      final controlDistance = (next.dx - current.dx) * 0.48;
      path.cubicTo(
        current.dx + controlDistance,
        current.dy,
        next.dx - controlDistance,
        next.dy,
        next.dx,
        next.dy,
      );
    }

    final metric = path.computeMetrics().first;
    final visiblePath = metric.extractPath(
      0,
      metric.length * progress.clamp(0, 1),
    );
    final glowPaint = Paint()
      ..color = const Color(0xFF60A5FA).withValues(alpha: 0.18 * progress)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 8;
    final linePaint = Paint()
      ..color = const Color(0xFF1D4ED8).withValues(alpha: 0.78 * progress)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.2;

    canvas.drawPath(visiblePath, glowPaint);
    canvas.drawPath(visiblePath, linePaint);

    for (var i = 0; i < points.length; i++) {
      final localProgress = ((progress * points.length) - i).clamp(0.0, 1.0);
      if (localProgress <= 0) continue;
      final center = offsets[i];
      canvas.drawCircle(
        center,
        4.8 * localProgress,
        Paint()..color = Colors.white.withValues(alpha: localProgress),
      );
      canvas.drawCircle(
        center,
        2.5 * localProgress,
        Paint()
          ..color = const Color(0xFF2864E8).withValues(alpha: localProgress),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DataLinePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.points != points;
}

class _AnimatedLine extends StatelessWidget {
  const _AnimatedLine({
    required this.width,
    required this.color,
    this.height = 6,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.38);
    for (double x = 4; x < size.width; x += 10) {
      for (double y = 4; y < size.height; y += 10) {
        canvas.drawCircle(Offset(x, y), 0.7, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ServiceData {
  const _ServiceData({
    required this.type,
    required this.title,
    required this.description,
    required this.highlights,
    required this.desktopFlex,
  });

  final _ServiceType type;
  final String title;
  final String description;
  final List<_ServiceHighlight> highlights;
  final int desktopFlex;
}

class _ServiceHighlight {
  const _ServiceHighlight(this.icon, this.label);

  final IconData icon;
  final String label;
}

enum _ServiceType { software, webMobile, cloud, data }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/pages/home/models/case_model.dart';
import 'package:metrifica_landing/app/pages/home/providers/cases_provider.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCasesSection extends ConsumerWidget {
  const HomeCasesSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _fallbackCases = [
    CaseModel(
      id: 'fallback-automation',
      name: 'Automacao de processos comerciais',
      description:
          'Sistema sob medida para reduzir etapas manuais e dar visibilidade operacional em tempo real.',
      category: 'Software',
      categoryColor: Color(0xFF2864E8),
      imageUrl: null,
      order: 1,
      stack: ['React', 'Node.js', 'PostgreSQL'],
    ),
    CaseModel(
      id: 'fallback-data',
      name: 'Dashboard executivo com dados integrados',
      description:
          'Pipeline de dados e indicadores para acompanhamento de performance, metas e gargalos.',
      category: 'Data',
      categoryColor: Color(0xFF1A9E6A),
      imageUrl: null,
      order: 2,
      stack: ['Python', 'Supabase', 'REST API'],
    ),
    CaseModel(
      id: 'fallback-mobile',
      name: 'Experiencia mobile para operacao em campo',
      description:
          'Aplicacao responsiva para equipes externas registrarem atividades com mais agilidade.',
      category: 'Mobile',
      categoryColor: Color(0xFFE07B00),
      imageUrl: null,
      order: 3,
      stack: ['Flutter', 'TypeScript', 'Docker'],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(casesProvider);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 96),
      child: MaxWidthContainer(
        maxWidth: 1280,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 32),
        child: casesAsync.when(
          loading: () =>
              isMobile ? _buildMobileLoading() : _buildDesktopLoading(),
          error: (_, __) => isMobile
              ? _buildMobile(_fallbackCases)
              : _buildDesktop(_fallbackCases),
          data: (cases) {
            final visibleCases = cases.isEmpty ? _fallbackCases : cases;
            return isMobile
                ? _buildMobile(visibleCases)
                : _buildDesktop(visibleCases);
          },
        ),
      ),
    );
  }

  Widget _buildDesktop(List<CaseModel> cases) {
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
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(child: _CasesCarousel(cases: cases, cardWidth: 300)),
      ],
    );
  }

  Widget _buildMobile(List<CaseModel> cases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(),
        const SizedBox(height: 16),
        _title(28),
        const SizedBox(height: 32),
        _CasesCarousel(cases: cases, cardWidth: 272, isMobile: true),
      ],
    );
  }

  Widget _buildDesktopLoading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_sectionLabel(), const SizedBox(height: 16), _title(32)],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: Row(
            children: List.generate(
              3,
              (_) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: _CaseCardSkeleton(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(),
        const SizedBox(height: 16),
        _title(28),
        const SizedBox(height: 32),
        ...List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _CaseCardSkeleton(),
          ),
        ),
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

// ---------------------------------------------------------------------------
// Carousel
// ---------------------------------------------------------------------------

class _CasesCarousel extends StatefulWidget {
  const _CasesCarousel({
    required this.cases,
    required this.cardWidth,
    this.isMobile = false,
  });

  final List<CaseModel> cases;
  final double cardWidth;
  final bool isMobile;

  @override
  State<_CasesCarousel> createState() => _CasesCarouselState();
}

class _CasesCarouselState extends State<_CasesCarousel> {
  late final ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  static const _cardGap = 16.0;

  double get _scrollStep => widget.isMobile
      ? widget.cardWidth + _cardGap
      : (widget.cardWidth + _cardGap) * 3;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final max = _scrollController.position.maxScrollExtent;
    final canLeft = offset > 0;
    final canRight = offset < max;
    if (canLeft != _canScrollLeft || canRight != _canScrollRight) {
      setState(() {
        _canScrollLeft = canLeft;
        _canScrollRight = canRight;
      });
    }
  }

  void _scrollBy(double delta) {
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showArrows =
            !widget.isMobile || constraints.maxWidth < widget.cardWidth * 1.4;

        final scrollView = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.cases.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i < widget.cases.length - 1 ? _cardGap : 0,
                  ),
                  child: SizedBox(
                    width: widget.cardWidth,
                    child: _CaseCard(data: widget.cases[i]),
                  ),
                ),
            ],
          ),
        );

        // Mobile: arrows rendered below the cards
        if (widget.isMobile && showArrows) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              scrollView,
              if (_canScrollLeft || _canScrollRight) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_canScrollLeft)
                      _NavButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => _scrollBy(-_scrollStep),
                      ),
                    if (_canScrollLeft && _canScrollRight)
                      const SizedBox(width: 8),
                    if (_canScrollRight)
                      _NavButton(
                        icon: Icons.arrow_forward_rounded,
                        onTap: () => _scrollBy(_scrollStep),
                      ),
                  ],
                ),
              ],
            ],
          );
        }

        // Desktop: arrows overlaid on the cards
        return Stack(
          clipBehavior: Clip.none,
          children: [
            scrollView,
            if (showArrows && _canScrollLeft)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: _NavButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => _scrollBy(-_scrollStep),
                ),
              ),
            if (showArrows && _canScrollRight)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: _NavButton(
                  icon: Icons.arrow_forward_rounded,
                  onTap: () => _scrollBy(_scrollStep),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF2864E8) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF2864E8)
                  : const Color(0xFFE4EAFF),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A2B5E).withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: _hovered ? Colors.white : const Color(0xFF2864E8),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _CaseCard extends StatefulWidget {
  const _CaseCard({required this.data});

  final CaseModel data;

  @override
  State<_CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<_CaseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _CaseDetailDialog.show(context, widget.data),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _hovered ? -8 : 0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          builder: (context, offset, child) =>
              Transform.translate(offset: Offset(0, offset), child: child),
          child: Container(
            constraints: const BoxConstraints(minHeight: 340),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE4EAFF), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A2B5E).withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CaseImage(
                  imageUrl: widget.data.imageUrl,
                  categoryColor: widget.data.categoryColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.data.categoryColor.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.data.category,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: widget.data.categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: Text(
                          widget.data.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: -0.3,
                            color: const Color(0xFF0B1C45),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: Text(
                          widget.data.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.5,
                            color: const Color(0xFF7A879F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver mais',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaseImage extends StatelessWidget {
  const _CaseImage({required this.imageUrl, required this.categoryColor});

  final String? imageUrl;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
      child: _NetImage(
        url: imageUrl,
        width: double.infinity,
        height: 160,
        fallback: _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: categoryColor.withValues(alpha: 0.06),
      child: Center(
        child: Icon(
          Icons.web_rounded,
          size: 44,
          color: categoryColor.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _CaseCardSkeleton extends StatelessWidget {
  const _CaseCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 340),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4EAFF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFE4EAFF).withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(19),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 64, height: 22, radius: 6),
                const SizedBox(height: 12),
                _SkeletonBox(width: double.infinity, height: 16, radius: 4),
                const SizedBox(height: 6),
                _SkeletonBox(width: 120, height: 16, radius: 4),
                const SizedBox(height: 12),
                _SkeletonBox(width: double.infinity, height: 12, radius: 4),
                const SizedBox(height: 4),
                _SkeletonBox(width: double.infinity, height: 12, radius: 4),
                const SizedBox(height: 4),
                _SkeletonBox(width: 160, height: 12, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE4EAFF).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Case detail dialog
// ---------------------------------------------------------------------------

class _CaseDetailDialog extends StatelessWidget {
  const _CaseDetailDialog({required this.data});

  final CaseModel data;

  static void show(BuildContext context, CaseModel data) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 160),
      transitionBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => _CaseDetailDialog(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final dialogWidth = isMobile ? screenWidth * 0.95 : 680.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 32,
        vertical: 48,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: isMobile ? _buildMobileBody() : _buildDesktopBody(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFEBF0FF))),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4FF),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFDDE8FF),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                size: 16,
                                color: Color(0xFF2864E8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Voltar',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2864E8),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width image with close button overlaid
          Stack(
            children: [
              _buildFullWidthImage(height: 220),
              Positioned(top: 12, right: 12, child: _CloseButton()),
            ],
          ),

          // Category + stacks + title + description
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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
                    ...data.stack.map((s) {
                      final color = _techColor(s);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: color,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  data.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.5,
                    color: const Color(0xFF0B1C45),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),

          // Proof images
          if (data.images.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Color(0xFFE4EAFF)),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Imagens do projeto',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: const Color(0xFF7A879F),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RepaintBoundary(
                child: _BentoGrid(
                  images: data.images,
                  categoryColor: data.categoryColor,
                ),
              ),
            ),
          ],

          // Project link
          if (data.link != null && data.link!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Color(0xFFE4EAFF)),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ProjectLink(url: data.link!),
            ),
          ],

          // URL
          if (data.url != null && data.url!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Color(0xFFE4EAFF)),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Acesse o case',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: const Color(0xFF7A879F),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _UrlRow(url: data.url!),
            ),
          ],

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildDesktopBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildImage(width: 220, height: 220),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: data.categoryColor.withValues(
                                    alpha: 0.1,
                                  ),
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
                              ...data.stack.map((s) {
                                final color = _techColor(s);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    s,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.4,
                                      color: color,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _CloseButton(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -0.5,
                        color: const Color(0xFF0B1C45),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 1.6,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (data.images.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE4EAFF)),
            const SizedBox(height: 16),
            Text(
              'Imagens do projeto',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: const Color(0xFF7A879F),
              ),
            ),
            const SizedBox(height: 12),
            RepaintBoundary(
              child: _BentoGrid(
                images: data.images,
                categoryColor: data.categoryColor,
              ),
            ),
          ],

          if (data.link != null && data.link!.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE4EAFF)),
            const SizedBox(height: 16),
            _ProjectLink(url: data.link!),
          ],

          if (data.url != null && data.url!.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE4EAFF)),
            const SizedBox(height: 16),
            Text(
              'Acesse o case',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: const Color(0xFF7A879F),
              ),
            ),
            const SizedBox(height: 8),
            _UrlRow(url: data.url!),
          ],
        ],
      ),
    );
  }

  Widget _buildFullWidthImage({required double height}) {
    return _NetImage(
      url: data.imageUrl,
      width: double.infinity,
      height: height,
      fallback: _fullWidthPlaceholder(height),
    );
  }

  Widget _fullWidthPlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: data.categoryColor.withValues(alpha: 0.06),
      child: Center(
        child: Icon(
          Icons.web_rounded,
          size: 44,
          color: data.categoryColor.withValues(alpha: 0.25),
        ),
      ),
    );
  }

  Widget _buildImage({required double width, required double height}) {
    return _NetImage(
      url: data.imageUrl,
      width: width,
      height: height,
      fallback: _imagePlaceholder(width, height),
    );
  }

  Widget _imagePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: data.categoryColor.withValues(alpha: 0.06),
      child: Center(
        child: Icon(
          Icons.web_rounded,
          size: 36,
          color: data.categoryColor.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// Project link
// ---------------------------------------------------------------------------

class _ProjectLink extends StatefulWidget {
  const _ProjectLink({required this.url});

  final String url;

  @override
  State<_ProjectLink> createState() => _ProjectLinkState();
}

class _ProjectLinkState extends State<_ProjectLink> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _hovered
                    ? const Color(0xFF1A4FBF)
                    : const Color(0xFF2864E8),
                decoration: _hovered
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              child: const Text('Link para o projeto'),
            ),
            const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.translationValues(_hovered ? 3 : 0, 0, 0),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: _hovered
                    ? const Color(0xFF1A4FBF)
                    : const Color(0xFF2864E8),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.url,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: const Color(0xFF7A879F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento grid (dialog proof images)
// ---------------------------------------------------------------------------

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.images, required this.categoryColor});

  final List<String> images;
  final Color categoryColor;

  static const _gap = 8.0;
  static const _heroHeight = 200.0;
  static const _smallHeight = 130.0;
  static const _rowHeight = 140.0;

  Widget _tile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () =>
          _ImageViewerDialog.show(context, images: images, initialIndex: index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _NetImage(
            url: images[index],
            width: double.infinity,
            height: double.infinity,
            fallback: Container(
              color: categoryColor.withValues(alpha: 0.06),
              child: Icon(
                Icons.broken_image_rounded,
                size: 28,
                color: categoryColor.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final n = images.length;

    if (n == 1) {
      // Single image: full width
      return SizedBox(height: _heroHeight, child: _tile(context, 0));
    }

    if (n == 2) {
      // Two images side by side, first slightly wider
      return SizedBox(
        height: _heroHeight,
        child: Row(
          children: [
            Expanded(flex: 3, child: _tile(context, 0)),
            const SizedBox(width: _gap),
            Expanded(flex: 2, child: _tile(context, 1)),
          ],
        ),
      );
    }

    if (n == 3) {
      // Hero left, two stacked right
      return SizedBox(
        height: _heroHeight,
        child: Row(
          children: [
            Expanded(flex: 3, child: _tile(context, 0)),
            const SizedBox(width: _gap),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(child: _tile(context, 1)),
                  const SizedBox(height: _gap),
                  Expanded(child: _tile(context, 2)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (n == 4) {
      // Hero top-left, small top-right, two equal bottom
      return Column(
        children: [
          SizedBox(
            height: _heroHeight,
            child: Row(
              children: [
                Expanded(flex: 3, child: _tile(context, 0)),
                const SizedBox(width: _gap),
                Expanded(flex: 2, child: _tile(context, 1)),
              ],
            ),
          ),
          const SizedBox(height: _gap),
          SizedBox(
            height: _smallHeight,
            child: Row(
              children: [
                Expanded(child: _tile(context, 2)),
                const SizedBox(width: _gap),
                Expanded(child: _tile(context, 3)),
              ],
            ),
          ),
        ],
      );
    }

    // 5+ images: hero top-left, small top-right + stacked, rest in 2-col rows
    final remaining = images.sublist(3);
    final rows = <Widget>[];
    for (int i = 0; i < remaining.length; i += 2) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: _gap));
      rows.add(
        SizedBox(
          height: _rowHeight,
          child: Row(
            children: [
              Expanded(child: _tile(context, 3 + i)),
              const SizedBox(width: _gap),
              Expanded(
                child: i + 1 < remaining.length
                    ? _tile(context, 3 + i + 1)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: _heroHeight,
          child: Row(
            children: [
              Expanded(flex: 3, child: _tile(context, 0)),
              const SizedBox(width: _gap),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(child: _tile(context, 1)),
                    const SizedBox(height: _gap),
                    Expanded(child: _tile(context, 2)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: _gap),
        ...rows,
      ],
    );
  }
}

// Images carousel (dialog proof images)
// ---------------------------------------------------------------------------

class _ImagesCarousel extends StatefulWidget {
  const _ImagesCarousel({required this.images, required this.categoryColor});

  final List<String> images;
  final Color categoryColor;

  @override
  State<_ImagesCarousel> createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<_ImagesCarousel> {
  late final ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  static const _imageWidth = 260.0;
  static const _imageGap = 12.0;

  double get _scrollStep => (_imageWidth + _imageGap) * 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final max = _scrollController.position.maxScrollExtent;
    final canLeft = offset > 0;
    final canRight = offset < max;
    if (canLeft != _canScrollLeft || canRight != _canScrollRight) {
      setState(() {
        _canScrollLeft = canLeft;
        _canScrollRight = canRight;
      });
    }
  }

  void _scrollBy(double delta) {
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              for (int i = 0; i < widget.images.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i < widget.images.length - 1 ? _imageGap : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => _ImageViewerDialog.show(
                      context,
                      images: widget.images,
                      initialIndex: i,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _NetImage(
                          url: widget.images[i],
                          height: 180,
                          width: _imageWidth,
                          fallback: Container(
                            height: 180,
                            width: _imageWidth,
                            color: widget.categoryColor.withValues(alpha: 0.06),
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 32,
                              color: widget.categoryColor.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (_canScrollLeft)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: _NavButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => _scrollBy(-_scrollStep),
            ),
          ),

        if (_canScrollRight)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: _NavButton(
              icon: Icons.arrow_forward_rounded,
              onTap: () => _scrollBy(_scrollStep),
            ),
          ),
      ],
    );
  }
}

class _UrlRow extends StatefulWidget {
  const _UrlRow({required this.url});

  final String url;

  @override
  State<_UrlRow> createState() => _UrlRowState();
}

class _UrlRowState extends State<_UrlRow> {
  bool _hovered = false;
  bool _copied = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.url));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4EAFF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.link_rounded, size: 16, color: Color(0xFF2864E8)),
          const SizedBox(width: 8),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                onTap: _launch,
                child: Text(
                  widget.url,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: _hovered
                        ? const Color(0xFF2864E8)
                        : const Color(0xFF4A5568),
                    decoration: _hovered
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _copy,
            child: Tooltip(
              message: _copied ? 'Copiado!' : 'Copiar URL',
              child: Icon(
                _copied ? Icons.check_rounded : Icons.copy_rounded,
                size: 16,
                color: _copied
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF7A879F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Full-screen image viewer
// ---------------------------------------------------------------------------

class _ImageViewerDialog extends StatefulWidget {
  const _ImageViewerDialog({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  static void show(
    BuildContext context, {
    required List<String> images,
    required int initialIndex,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (_) =>
          _ImageViewerDialog(images: images, initialIndex: initialIndex),
    );
  }

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  late int _current;
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _loadImageSize(_current);
  }

  void _loadImageSize(int index) {
    final stream = NetworkImage(
      widget.images[index],
    ).resolve(ImageConfiguration.empty);
    stream.addListener(
      ImageStreamListener((info, _) {
        if (mounted) {
          setState(
            () => _imageSize = Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            ),
          );
        }
      }, onError: (_, __) {}),
    );
  }

  void _go(int index) {
    setState(() {
      _current = index;
      _imageSize = null;
    });
    _loadImageSize(index);
  }

  /// Returns (top, right) offsets so the X sits at the top-right corner
  /// of the image as rendered by BoxFit.contain inside [screen].
  (double top, double right) _xOffset(Size screen) {
    if (_imageSize == null) return (8, 8);
    final imgAspect = _imageSize!.width / _imageSize!.height;
    final screenAspect = screen.width / screen.height;
    if (imgAspect >= screenAspect) {
      // Width-constrained → letterboxed top/bottom
      final renderH = screen.width / imgAspect;
      return ((screen.height - renderH) / 2 + 8, 8);
    } else {
      // Height-constrained → pillarboxed left/right
      final renderW = screen.height * imgAspect;
      return (8, (screen.width - renderW) / 2 + 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrev = _current > 0;
    final hasNext = _current < widget.images.length - 1;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final closeButton = GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
      ),
    );

    final counter = widget.images.length > 1
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_current + 1} / ${widget.images.length}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
        : null;

    if (isMobile) {
      final screen = MediaQuery.of(context).size;
      final (xTop, xRight) = _xOffset(screen);

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.network(
                  widget.images[_current],
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                            strokeWidth: 2,
                          ),
                        ),
                ),
              ),
              // X positioned over the image, not the screen
              Positioned(top: xTop, right: xRight, child: closeButton),
              if (counter != null)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(child: counter),
                ),
              if (hasPrev)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => _go(_current - 1),
                    ),
                  ),
                ),
              if (hasNext)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavButton(
                      icon: Icons.arrow_forward_rounded,
                      onTap: () => _go(_current + 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Desktop: centered image with contain, X at top-right corner
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.network(
                widget.images[_current],
                fit: BoxFit.contain,
              ),
            ),
            if (counter != null) Positioned(bottom: 16, child: counter),
            if (hasPrev)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => _go(_current - 1),
                  ),
                ),
              ),
            if (hasNext)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavButton(
                    icon: Icons.arrow_forward_rounded,
                    onTap: () => _go(_current + 1),
                  ),
                ),
              ),
            Positioned(top: 0, right: 0, child: closeButton),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tech stack color map
// ---------------------------------------------------------------------------

Color _techColor(String tech) {
  const map = <String, int>{
    'Python': 0xFF3776AB,
    'FastAPI': 0xFF009688,
    'Flask': 0xFF5A5A5A,
    'Django': 0xFF0C4B33,
    'Django REST framework': 0xFFA30000,
    'SQLAlchemy': 0xFFD71F00,
    'Celery': 0xFF37814A,
    'Node.js': 0xFF339933,
    'TypeScript': 0xFF3178C6,
    'JavaScript': 0xFFB8860B,
    'Next.js': 0xFF444444,
    'React': 0xFF0EA5C8,
    'Prisma': 0xFF2D3748,
    'Go': 0xFF00ADD8,
    'Gin': 0xFF00ADD8,
    'GORM': 0xFF00ACD7,
    'Java': 0xFFED8B00,
    'Spring Boot': 0xFF6DB33F,
    'JPA': 0xFF6DB33F,
    'C#': 0xFF239120,
    'ASP.NET Core': 0xFF512BD4,
    'Entity Framework': 0xFF512BD4,
    'Ruby on Rails': 0xFFCC0000,
    'Ruby': 0xFFCC0000,
    'Sidekiq': 0xFFCC0000,
    'Heroku': 0xFF430098,
    'Laravel': 0xFFFF2D20,
    'PHP': 0xFF777BB4,
    'Forge': 0xFF19B394,
    'Queue': 0xFFFF2D20,
    'PostgreSQL': 0xFF336791,
    'MySQL': 0xFF4479A1,
    'Redis': 0xFFDC382D,
    'Docker': 0xFF2496ED,
    'AWS': 0xFFE07B00,
    'Supabase': 0xFF1A9E6A,
    'Stripe': 0xFF635BFF,
    'REST API': 0xFF6BA3BE,
  };

  final hex = map[tech];
  if (hex != null) return Color(hex);

  final hue = (tech.codeUnits.fold(0, (a, b) => a + b) % 360).toDouble();
  return HSLColor.fromAHSL(1.0, hue, 0.55, 0.40).toColor();
}


// ---------------------------------------------------------------------------
// Network image with shimmer loading + fade-in
// ---------------------------------------------------------------------------

class _NetImage extends StatefulWidget {
  const _NetImage({
    required this.url,
    required this.fallback,
    this.width,
    this.height,
  });

  final String? url;
  final Widget fallback;
  final double? width;
  final double? height;

  @override
  State<_NetImage> createState() => _NetImageState();
}

class _NetImageState extends State<_NetImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.url;
    if (url == null || url.isEmpty) return widget.fallback;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _shimmer,
            builder: (_, __) => ColoredBox(
              color: Color.lerp(
                const Color(0xFFF1F5F9),
                const Color(0xFFE2E8F0),
                _shimmer.value,
              )!,
            ),
          ),
          Image.network(
            url,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress != null) return const SizedBox();
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (_, v, __) => Opacity(opacity: v, child: child),
              );
            },
            errorBuilder: (_, __, ___) => widget.fallback,
          ),
        ],
      ),
    );
  }
}

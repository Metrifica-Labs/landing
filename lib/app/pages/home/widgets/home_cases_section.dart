import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/pages/home/models/case_model.dart';
import 'package:metrifica_landing/app/pages/home/providers/cases_provider.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

class HomeCasesSection extends ConsumerWidget {
  const HomeCasesSection({super.key, required this.isMobile});

  final bool isMobile;

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
          loading: () => isMobile ? _buildMobileLoading() : _buildDesktopLoading(),
          error: (_, __) => isMobile ? _buildMobile([]) : _buildDesktop([]),
          data: (cases) => isMobile ? _buildMobile(cases) : _buildDesktop(cases),
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
              const SizedBox(height: 24),
              _AllCasesLink(),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: _CasesCarousel(cases: cases, cardWidth: 300),
        ),
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
        _CasesCarousel(cases: cases, cardWidth: 272),
        const SizedBox(height: 24),
        _AllCasesLink(),
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
            children: [
              _sectionLabel(),
              const SizedBox(height: 16),
              _title(32),
            ],
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
  const _CasesCarousel({required this.cases, required this.cardWidth});

  final List<CaseModel> cases;
  final double cardWidth;

  @override
  State<_CasesCarousel> createState() => _CasesCarouselState();
}

class _CasesCarouselState extends State<_CasesCarousel> {
  late final ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  static const _cardGap = 16.0;

  double get _scrollStep => (widget.cardWidth + _cardGap) * 3;

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
    final target = (_scrollController.offset + delta)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
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
        // Cards list
        SingleChildScrollView(
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
        ),

        // Left button
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

        // Right button
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
            color: _hovered
                ? const Color(0xFF2864E8)
                : Colors.white,
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
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.data.categoryColor.withValues(alpha: 0.1),
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
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
        child: Image.network(
          imageUrl!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
      ),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(19)),
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
  const _SkeletonBox(
      {required this.width, required this.height, required this.radius});

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

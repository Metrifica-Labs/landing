import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// ÓRDINARE — Editorial Vivo
/// Cream + gold luxury editorial palette, serif display, one dark manifesto break.
/// Tokens & shared atoms for the lp1 landing page (isolated from the global theme).
class LpColors {
  const LpColors._();

  static const Color cream = ui.Color.fromARGB(255, 252, 245, 237); // base background
  static const Color cream2 = ui.Color.fromARGB(255, 247, 238, 224); // alternating / stats bar
  static const Color paper = Color(0xFFFBF7F0); // cards
  static const Color ink = Color(0xFF1D1A15); // primary text
  static const Color ink2 = Color(0xFF5A5247); // secondary text
  static const Color ink3 = Color(0xFF8C8475); // muted / labels
  static const Color gold = Color(0xFFB08A52); // accent
  static const Color gold2 = Color(0xFFC9A66B); // lighter gold
  static const Color goldDeep = Color(0xFF8E6E3C);
  static const Color noir = Color(0xFF14110C); // dark manifesto bg
  static const Color noir2 = Color(0xFF1E1A13);

  static const Color line = Color(0x241D1A15); // rgba(29,26,21,.14)
  static const Color lineSoft = Color(0x141D1A15); // rgba(29,26,21,.08)
}

/// Custom easing matching CSS `cubic-bezier(.22,.61,.36,1)`.
const Cubic kLpEase = Cubic(0.22, 0.61, 0.36, 1.0);

const double kLpMaxW = 1240;
const double kLpTabletBreak = 1000;
const double kLpMobileBreak = 680;

/// Reproduces a CSS `clamp(minPx, vw, maxPx)` against the viewport width.
double lpClampVw(double minPx, double vw, double maxPx, double width) =>
    (vw / 100 * width).clamp(minPx, maxPx);

/// Horizontal page padding: clamp(20px, 5vw, 80px).
double lpPad(double width) => lpClampVw(20, 5, 80, width);

/// Vertical section padding: clamp(70px, 9vw, 140px).
double lpSectionPad(double width) => lpClampVw(70, 9, 140, width);

/// Typography helpers (Cormorant Garamond for display, Jost for UI).
class LpType {
  const LpType._();

  static TextStyle serif({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color color = LpColors.ink,
    double? height,
    bool italic = false,
    double? letterSpacing,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle sans({
    required double size,
    FontWeight weight = FontWeight.w300,
    Color color = LpColors.ink,
    double? height,
    double? letterSpacing,
    bool italic = false,
  }) {
    return GoogleFonts.jost(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
  }

  /// Numerals (stats, prices, step indices). Same Cormorant display face as
  /// [serif] but forces *lining* + *tabular* figures so the digits sit on a
  /// single cap-height baseline instead of Cormorant's default old-style
  /// figures (which drop descenders and look misaligned next to body text).
  static TextStyle numeral({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color color = LpColors.ink,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontFeatures: const [
        FontFeature.liningFigures(),
        FontFeature.tabularFigures(),
      ],
    );
  }

  /// `.eyebrow` — 12px, w500, letter-spacing .34em, uppercase, gold-deep.
  static TextStyle eyebrow({Color color = LpColors.goldDeep}) => GoogleFonts.jost(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 4,
        color: color,
      );

  /// `h2.section-title` — Cormorant w500, clamp(30,4.4vw,58), line 1.06.
  static TextStyle sectionTitle(double width, {Color color = LpColors.ink}) =>
      serif(
        size: lpClampVw(30, 4.4, 58, width),
        weight: FontWeight.w500,
        color: color,
        height: 1.06,
        letterSpacing: 0.4,
      );
}

// ---------------------------------------------------------------------------
// Scroll offset scope — lets descendant [Reveal] / parallax widgets react to
// the page scroll without each attaching its own controller.
// ---------------------------------------------------------------------------
class LpScrollScope extends InheritedNotifier<ValueNotifier<double>> {
  const LpScrollScope({
    super.key,
    required ValueNotifier<double> offset,
    required super.child,
  }) : super(notifier: offset);

  static ValueNotifier<double>? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<LpScrollScope>()
          ?.notifier;
}

// ---------------------------------------------------------------------------
// Reveal — fade-in + slide-up (36px) when scrolled into view. Mirrors the
// IntersectionObserver in ordinare.js (threshold 0.08, -6% bottom margin)
// with a 2.6s safety net so nothing stays hidden.
// ---------------------------------------------------------------------------
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delayMs = 0});

  final Widget child;
  final int delayMs;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  final _key = GlobalKey();
  late final AnimationController _ctrl;
  ValueNotifier<double>? _offset;
  Timer? _safety;
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _check();
      _safety = Timer(const Duration(milliseconds: 600), _show);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final offset = LpScrollScope.maybeOf(context);
    if (offset != _offset) {
      _offset?.removeListener(_check);
      _offset = offset;
      _offset?.addListener(_check);
    }
  }

  void _check() {
    if (_shown || !mounted) return;
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.sizeOf(context).height;
    if (top < screenH * 0.94) _show();
  }

  void _show() {
    if (_shown || !mounted) return;
    _shown = true;
    _safety?.cancel();
    _offset?.removeListener(_check);
    if (widget.delayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _safety?.cancel();
    _offset?.removeListener(_check);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final t = kLpEase.transform(_ctrl.value);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, 36 * (1 - t)),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hoverable — exposes a hover flag to a builder (web/desktop pointer states).
// ---------------------------------------------------------------------------
class Hoverable extends StatefulWidget {
  const Hoverable({
    super.key,
    required this.builder,
    this.cursor = SystemMouseCursors.click,
    this.onTap,
  });

  final Widget Function(BuildContext context, bool hovering) builder;
  final MouseCursor cursor;
  final VoidCallback? onTap;

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: widget.builder(context, _hovering),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Eyebrow label.
// ---------------------------------------------------------------------------
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = LpColors.goldDeep});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: LpType.eyebrow(color: color));
  }
}

// ---------------------------------------------------------------------------
// Buttons — gold (filled ink) and outline, both with the ↗ arrow that drifts
// on hover.
// ---------------------------------------------------------------------------
class LpButton extends StatelessWidget {
  const LpButton({
    super.key,
    required this.label,
    this.gold = true,
    this.onTap,
  });

  final String label;
  final bool gold;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovering) {
        final Color bg;
        final Color fg;
        if (gold) {
          bg = hovering ? LpColors.goldDeep : LpColors.ink;
          fg = LpColors.cream;
        } else {
          bg = hovering ? LpColors.ink : Colors.transparent;
          fg = hovering ? LpColors.cream : LpColors.ink;
        }
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: kLpEase,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          decoration: BoxDecoration(
            color: bg,
            border: gold
                ? null
                : Border.all(
                    color: hovering ? LpColors.ink : LpColors.line,
                  ),
          ),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: LpType.sans(
              size: 13,
              weight: FontWeight.w500,
              color: fg,
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Section shell — background colour + vertical section padding + a max-width,
// horizontally padded content column.
// ---------------------------------------------------------------------------
class LpSection extends StatelessWidget {
  const LpSection({
    super.key,
    required this.child,
    this.background = LpColors.cream,
    this.padScale = 1.0,
    this.verticalPad,
    this.clipChildren = false,
    this.stackBehind,
  });

  final Widget child;
  final Color background;

  /// Multiplier on the standard vertical section padding.
  final double padScale;

  /// Explicit vertical padding override (e.g. the stats bar's clamp(50,6vw,80)).
  final double? verticalPad;
  final bool clipChildren;

  /// Optional widget painted behind the content (e.g. a monogram watermark).
  final Widget? stackBehind;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final vPad = verticalPad ?? lpSectionPad(width) * padScale;
    Widget content = Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.symmetric(vertical: vPad),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kLpMaxW),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: lpPad(width)),
            child: child,
          ),
        ),
      ),
    );
    if (stackBehind != null) {
      content = Container(
        color: background,
        child: Stack(
          children: [
            Positioned.fill(child: stackBehind!),
            Padding(
              padding: EdgeInsets.symmetric(vertical: vPad),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: kLpMaxW),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: lpPad(width)),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return clipChildren ? ClipRect(child: content) : content;
  }
}

// ---------------------------------------------------------------------------
// Monogram watermark — giant low-opacity serif letter behind a section.
// ---------------------------------------------------------------------------
class MonogramBg extends StatelessWidget {
  const MonogramBg({
    super.key,
    required this.letter,
    this.vw = 64,
    this.alignment = Alignment.center,
    this.color = LpColors.ink,
    this.opacity = 0.035,
    this.dxFraction = 0,
    this.dyFraction = 0,
  });

  final String letter;
  final double vw;
  final Alignment alignment;
  final Color color;
  final double opacity;

  /// Extra translation as a fraction of the glyph's font size (matches the
  /// CSS `transform:translate(...)` nudges on the watermarks).
  final double dxFraction;
  final double dyFraction;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final size = vw / 100 * width;
    return ClipRect(
      child: IgnorePointer(
        child: Align(
          alignment: alignment,
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Transform.translate(
              offset: Offset(size * dxFraction, size * dyFraction),
              child: Text(
                letter,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: size,
                  fontWeight: FontWeight.w500,
                  height: 0.8,
                  letterSpacing: -2,
                  color: color.withValues(alpha: opacity),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FloatyChip — engagement chip with the signature 6s vertical float.
// ---------------------------------------------------------------------------
class FloatyChip extends StatelessWidget {
  const FloatyChip({
    super.key,
    required this.label,
    required this.icon,
    this.heart = false,
    this.delayMs = 0,
    this.float = true,
  });

  final String label;
  final IconData icon;
  final bool heart;
  final int delayMs;

  /// When false the chip renders statically (no vertical drift) — used for the
  /// inline mobile chip row where floating over the portrait looks unpolished.
  final bool float;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.fromLTRB(11, 9, 15, 9),
      decoration: BoxDecoration(
        color: LpColors.paper,
        border: Border.all(color: LpColors.gold),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1A15).withValues(alpha: 0.22),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: heart
                    ? const [Color(0xFFE0848A), Color(0xFFC04A52)]
                    : const [LpColors.gold2, LpColors.goldDeep],
              ),
            ),
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: LpType.sans(
              size: 13,
              weight: FontWeight.w500,
              color: LpColors.ink,
            ),
          ),
        ],
      ),
    );

    if (!float) return chip;

    return chip
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -12,
          duration: 3000.ms,
          delay: Duration(milliseconds: delayMs),
          curve: Curves.easeInOut,
        );
  }
}

// ---------------------------------------------------------------------------
// Marquee — infinitely scrolling serif-italic keyword strip.
// ---------------------------------------------------------------------------
class Marquee extends StatefulWidget {
  const Marquee({super.key, required this.items});

  final List<String> items;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  /// Number of repeated keyword sets laid side by side. Translating by exactly
  /// one set per cycle gives a seamless loop, but the visible strip is only
  /// gap-free while the remaining `(copies - 1)` sets still span the viewport —
  /// so enough copies are rendered to cover even ultra-wide screens.
  static const int _copies = 6;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _set() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in widget.items) ...[
          Text(
            item,
            style: LpType.serif(
              size: 20,
              italic: true,
              color: LpColors.ink3,
              weight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 60),
          Text('✦', style: LpType.sans(size: 14, color: LpColors.gold)),
          const SizedBox(width: 60),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fixed height required: OverflowBox inside a SingleChildScrollView column
    // receives unbounded height unless the Marquee wrapper bounds it.
    return SizedBox(
      height: 68,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: LpColors.line),
            bottom: BorderSide(color: LpColors.line),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: 28,
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, child) => FractionalTranslation(
                    translation: Offset(-_ctrl.value / _copies, 0),
                    child: child,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [for (var i = 0; i < _copies; i++) _set()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Backdrop blur helper for the scrolled nav state.
// ---------------------------------------------------------------------------
class LpBlur extends StatelessWidget {
  const LpBlur({super.key, required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: child,
      ),
    );
  }
}

/// Centered section header (eyebrow + serif title), used by several sections.
class LpCenteredHead extends StatelessWidget {
  const LpCenteredHead({
    super.key,
    required this.eyebrow,
    required this.title,
    this.bottomGap = 54,
  });

  final String eyebrow;
  final String title;
  final double bottomGap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Reveal(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomGap),
        child: Column(
          children: [
            Eyebrow(eyebrow),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: LpType.sectionTitle(width),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two-column split that collapses to a single stacked column at <=1000px.
class LpSplit extends StatelessWidget {
  const LpSplit({
    super.key,
    required this.left,
    required this.right,
    this.flexLeft = 1,
    this.flexRight = 1,
    this.gap,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.stackedGap,
  });

  final Widget left;
  final Widget right;
  final int flexLeft;
  final int flexRight;
  final double? gap;
  final double? stackedGap;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final g = gap ?? lpClampVw(40, 6, 80, width);
    if (width <= kLpTabletBreak) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [left, SizedBox(height: stackedGap ?? 48), right],
      );
    }
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(flex: flexLeft, child: left),
        SizedBox(width: g),
        Expanded(flex: flexRight, child: right),
      ],
    );
  }
}

/// Number of grid columns for the responsive tiers used across sections.
int lpColumns(double width, {required int wide, required int tablet, required int mobile}) {
  if (width <= kLpMobileBreak) return mobile;
  if (width <= kLpTabletBreak) return tablet;
  return wide;
}

/// Lays widgets into a wrapping grid of [columns] with a fixed [gap].
class LpGrid extends StatelessWidget {
  const LpGrid({
    super.key,
    required this.columns,
    required this.gap,
    required this.children,
    this.runGap,
  });

  final int columns;
  final double gap;
  final double? runGap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalGap = gap * (columns - 1);
        final itemW = (constraints.maxWidth - totalGap) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: runGap ?? gap,
          children: [
            for (final child in children)
              SizedBox(width: columns == 1 ? constraints.maxWidth : itemW, child: child),
          ],
        );
      },
    );
  }
}

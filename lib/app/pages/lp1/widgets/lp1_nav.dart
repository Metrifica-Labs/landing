import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

/// The ÓRDINARE wordmark, reused in the nav and footer.
class LpBrand extends StatelessWidget {
  const LpBrand({super.key, this.color = LpColors.ink, this.regColor = LpColors.gold});

  final Color color;
  final Color regColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'ÓRDINARE',
        style: LpType.serif(
          size: 23,
          weight: FontWeight.w600,
          color: color,
          letterSpacing: 5,
        ),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Transform.translate(
              offset: const Offset(2, -2),
              child: Text(
                '®',
                style: LpType.serif(size: 9, color: regColor, weight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Lp1Nav extends StatefulWidget {
  const Lp1Nav({
    super.key,
    required this.offset,
    required this.isMobile,
    this.onTop,
    this.onSobre,
    this.onMetodo,
    this.onInvest,
    this.onMentoria,
    this.onContato,
  });

  final ValueNotifier<double> offset;
  final bool isMobile;
  final VoidCallback? onTop;
  final VoidCallback? onSobre;
  final VoidCallback? onMetodo;
  final VoidCallback? onInvest;
  final VoidCallback? onMentoria;
  final VoidCallback? onContato;

  @override
  State<Lp1Nav> createState() => _Lp1NavState();
}

class _Lp1NavState extends State<Lp1Nav> {
  bool _open = false;

  List<(String, VoidCallback?)> get _links => [
        ('Sobre', widget.onSobre),
        ('Método', widget.onMetodo),
        ('Investimento', widget.onInvest),
        ('Mentoria', widget.onMentoria),
        ('Contato', widget.onContato),
      ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final pad = lpPad(width);

    return ValueListenableBuilder<double>(
      valueListenable: widget.offset,
      builder: (context, value, _) {
        final scrolled = value > 40;
        return LpBlur(
          enabled: scrolled,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: kLpEase,
            decoration: BoxDecoration(
              color: scrolled
                  ? LpColors.cream.withValues(alpha: 0.86)
                  : Colors.transparent,
              border: scrolled
                  ? const Border(bottom: BorderSide(color: LpColors.lineSoft))
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedPadding(
                  duration: const Duration(milliseconds: 500),
                  curve: kLpEase,
                  padding: EdgeInsets.symmetric(
                    horizontal: pad,
                    vertical: scrolled ? 14 : 22,
                  ),
                  child: widget.isMobile
                      ? _mobileBar()
                      : _desktopBar(),
                ),
                if (widget.isMobile && _open) _mobileDropdown(pad),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _desktopBar() {
    return Row(
      children: [
        Hoverable(
          cursor: SystemMouseCursors.click,
          onTap: widget.onTop,
          builder: (_, __) => const LpBrand(),
        ),
        const Spacer(),
        for (final link in _links) ...[
          _NavLink(label: link.$1, onTap: link.$2),
          const SizedBox(width: 34),
        ],
        const SizedBox(width: 6),
        _NavCta(onTap: widget.onContato),
      ],
    );
  }

  Widget _mobileBar() {
    return Row(
      children: [
        GestureDetector(onTap: widget.onTop, child: const LpBrand()),
        const Spacer(),
        _Burger(
          open: _open,
          onTap: () => setState(() => _open = !_open),
        ),
      ],
    );
  }

  Widget _mobileDropdown(double pad) {
    return Container(
      width: double.infinity,
      color: LpColors.cream,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final link in _links)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: GestureDetector(
                onTap: () {
                  setState(() => _open = false);
                  link.$2?.call();
                },
                child: Text(
                  link.$1.toUpperCase(),
                  style: LpType.sans(
                    size: 13,
                    weight: FontWeight.w400,
                    color: LpColors.ink2,
                    letterSpacing: 2.2,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          _NavCta(onTap: () {
            setState(() => _open = false);
            widget.onContato?.call();
          }),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovering) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                label.toUpperCase(),
                style: LpType.sans(
                  size: 12,
                  weight: FontWeight.w400,
                  color: hovering ? LpColors.ink : LpColors.ink2,
                  letterSpacing: 2.2,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: kLpEase,
              height: 1,
              width: hovering ? _textWidth(label) : 0,
              color: LpColors.gold,
            ),
          ],
        );
      },
    );
  }

  double _textWidth(String label) {
    final tp = TextPainter(
      text: TextSpan(
        text: label.toUpperCase(),
        style: LpType.sans(size: 12, weight: FontWeight.w400, letterSpacing: 2.2),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }
}

class _NavCta extends StatelessWidget {
  const _NavCta({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: kLpEase,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
          decoration: BoxDecoration(
            color: hovering ? LpColors.gold : Colors.transparent,
            border: Border.all(color: LpColors.gold),
          ),
          child: Text(
            'FALE COMIGO',
            style: LpType.sans(
              size: 12,
              weight: FontWeight.w500,
              color: hovering ? LpColors.cream : LpColors.goldDeep,
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }
}

class _Burger extends StatelessWidget {
  const _Burger({required this.open, this.onTap});

  final bool open;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 26,
        height: 18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 3; i++) ...[
              Container(width: 24, height: 1.5, color: LpColors.ink),
              if (i < 2) const SizedBox(height: 5),
            ],
          ],
        ),
      ),
    );
  }
}

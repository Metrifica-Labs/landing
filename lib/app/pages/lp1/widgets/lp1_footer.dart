import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';
import 'package:metrifica_landing/app/pages/lp1/widgets/lp1_nav.dart';

const _kInstagramPath =
    'M12 2.2c3.2 0 3.6 0 4.9.1 1.2.1 1.8.3 2.2.4.6.2 1 .5 1.4.9.4.4.7.8.9 1.4.2.4.4 1 .4 2.2.1 1.3.1 1.7.1 4.9s0 3.6-.1 4.9c-.1 1.2-.3 1.8-.4 2.2-.2.6-.5 1-.9 1.4-.4.4-.8.7-1.4.9-.4.2-1 .4-2.2.4-1.3.1-1.7.1-4.9.1s-3.6 0-4.9-.1c-1.2-.1-1.8-.3-2.2-.4-.6-.2-1-.5-1.4-.9-.4-.4-.7-.8-.9-1.4-.2-.4-.4-1-.4-2.2C2.2 15.6 2.2 15.2 2.2 12s0-3.6.1-4.9c.1-1.2.3-1.8.4-2.2.2-.6.5-1 .9-1.4.4-.4.8-.7 1.4-.9.4-.2 1-.4 2.2-.4C8.4 2.2 8.8 2.2 12 2.2zm0 1.8c-3.1 0-3.5 0-4.7.1-1.1.1-1.7.2-2.1.4-.5.2-.9.4-1.3.8-.4.4-.6.8-.8 1.3-.2.4-.3 1-.4 2.1C2.6 9.9 2.6 10.3 2.6 12s0 2.1.1 3.3c.1 1.1.2 1.7.4 2.1.2.5.4.9.8 1.3.4.4.8.6 1.3.8.4.2 1 .3 2.1.4 1.2.1 1.6.1 4.7.1s3.5 0 4.7-.1c1.1-.1 1.7-.2 2.1-.4.5-.2.9-.4 1.3-.8.4-.4.6-.8.8-1.3.2-.4.3-1 .4-2.1.1-1.2.1-1.6.1-3.3s0-2.1-.1-3.3c-.1-1.1-.2-1.7-.4-2.1-.2-.5-.4-.9-.8-1.3-.4-.4-.8-.6-1.3-.8-.4-.2-1-.3-2.1-.4-1.2-.1-1.6-.1-4.7-.1zm0 3.1a4.9 4.9 0 1 1 0 9.8 4.9 4.9 0 0 1 0-9.8zm0 8a3.1 3.1 0 1 0 0-6.2 3.1 3.1 0 0 0 0 6.2zm6.3-8.2a1.1 1.1 0 1 1-2.3 0 1.1 1.1 0 0 1 2.3 0z';

const _kYoutubePath =
    'M23 7.5s-.2-1.6-.9-2.3c-.9-.9-1.8-.9-2.3-1C16.7 4 12 4 12 4s-4.7 0-7.8.2c-.4 0-1.4.1-2.3 1-.7.7-.9 2.3-.9 2.3S.8 9.4.8 11.3v1.4c0 1.9.2 3.8.2 3.8s.2 1.6.9 2.3c.9.9 2 .9 2.5 1 1.8.2 7.6.2 7.6.2s4.7 0 7.8-.2c.5-.1 1.4-.1 2.3-1 .7-.7.9-2.3.9-2.3s.2-1.9.2-3.8v-1.4c0-1.9-.2-3.8-.2-3.8zM9.7 15.1V8.9l5.4 3.1-5.4 3.1z';

const _kLinkedinPath =
    'M20.4 3H3.6C3.3 3 3 3.3 3 3.6v16.8c0 .3.3.6.6.6h16.8c.3 0 .6-.3.6-.6V3.6c0-.3-.3-.6-.6-.6zM8.3 18.3H5.6V9.7h2.7v8.6zM7 8.5a1.6 1.6 0 1 1 0-3.1 1.6 1.6 0 0 1 0 3.1zm11.3 9.8h-2.7v-4.2c0-1 0-2.3-1.4-2.3s-1.6 1.1-1.6 2.2v4.3H9.9V9.7h2.6v1.2h.1c.4-.7 1.3-1.4 2.6-1.4 2.7 0 3.2 1.8 3.2 4.1v4.7z';

String _svg(String path) =>
    '<svg viewBox="0 0 24 24"><path fill="#F6F0E6" d="$path"/></svg>';

class Lp1FooterSection extends StatelessWidget {
  const Lp1FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      width: double.infinity,
      color: LpColors.noir,
      padding: EdgeInsets.fromLTRB(lpPad(width), 70, lpPad(width), 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kLpMaxW),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 30,
                  runSpacing: 24,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LpBrand(
                          color: LpColors.cream,
                          regColor: LpColors.gold2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'MENTORIA & ESTRATÉGIA DIGITAL',
                          style: LpType.sans(
                            size: 12,
                            weight: FontWeight.w400,
                            color: LpColors.gold2,
                            letterSpacing: 2.4,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SocialButton(svg: _svg(_kInstagramPath)),
                        const SizedBox(width: 14),
                        _SocialButton(svg: _svg(_kYoutubePath)),
                        const SizedBox(width: 14),
                        _SocialButton(svg: _svg(_kLinkedinPath)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
                ),
                padding: const EdgeInsets.only(top: 26),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 12,
                  children: [
                    Text(
                      '© 2026 ÓRDINARE. Todos os direitos reservados.',
                      style: LpType.sans(
                        size: 12.5,
                        weight: FontWeight.w300,
                        color: LpColors.ink3,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _FooterLink('Política de Privacidade'),
                        Text(
                          '  ·  ',
                          style: LpType.sans(size: 12.5, color: LpColors.ink3),
                        ),
                        const _FooterLink('Termos de Uso'),
                      ],
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.svg});

  final String svg;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: kLpEase,
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hovering ? LpColors.gold : Colors.transparent,
            border: Border.all(
              color: hovering ? LpColors.gold : const Color(0x33FFFFFF),
            ),
          ),
          alignment: Alignment.center,
          child: SvgPicture.string(svg, width: 17, height: 17),
        );
      },
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      builder: (context, hovering) {
        return Text(
          label,
          style: LpType.sans(
            size: 12.5,
            weight: FontWeight.w300,
            color: hovering ? LpColors.gold2 : LpColors.ink3,
          ),
        );
      },
    );
  }
}

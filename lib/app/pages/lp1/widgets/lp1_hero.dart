import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

class Lp1HeroSection extends StatelessWidget {
  const Lp1HeroSection({super.key, this.onContato});

  final VoidCallback? onContato;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stacked = width <= kLpTabletBreak;
    final isMobile = width <= kLpMobileBreak;

    final copy = _HeroCopy(onContato: onContato, isMobile: isMobile);
    final portrait = const Reveal(delayMs: 160, child: _HeroPortrait());

    final Widget grid;
    if (stacked) {
      grid = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: portrait,
            ),
          ),
          SizedBox(height: lpClampVw(30, 5, 70, width)),
          copy,
        ],
      );
    } else {
      grid = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 105, child: copy),
          SizedBox(width: lpClampVw(30, 5, 70, width)),
          Expanded(flex: 95, child: portrait),
        ],
      );
    }

    return Container(
      color: LpColors.cream,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: isMobile ? 118 : 140),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kLpMaxW),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: lpPad(width)),
                  child: grid,
                ),
              ),
            ),
          ),
          SizedBox(height: lpClampVw(60, 8, 110, width)),
          const Marquee(
            items: [
              'Posicionamento',
              'Autoridade',
              'High Ticket',
              'Conteúdo que vende',
              'Funil estratégico',
            ],
          ),
          SizedBox(height: lpSectionPad(width)),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({this.onContato, required this.isMobile});

  final VoidCallback? onContato;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final h1Size = isMobile
        ? lpClampVw(34, 11, 52, width)
        : lpClampVw(36, 4.6, 64, width);
    final h1 = LpType.serif(
      size: h1Size,
      weight: FontWeight.w500,
      color: LpColors.ink,
      height: 1.03,
      letterSpacing: -0.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 46, height: 1, color: LpColors.gold),
              const SizedBox(width: 14),
              const Eyebrow('Mentoria & Estratégia Digital'),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          delayMs: 80,
          child: Text.rich(
            TextSpan(
              style: h1,
              children: [
                const TextSpan(
                  text:
                      'Quer atrair clientes prontos para comprar seu High Ticket? ',
                ),
                TextSpan(
                  text:
                      'Mesmo que o seu Instagram ainda não venda todos os dias?',
                  style: h1.copyWith(
                    fontStyle: FontStyle.italic,
                    color: LpColors.goldDeep,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Reveal(
          delayMs: 160,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'Eu te ajudo a transformar o seu perfil no Instagram em uma '
              'máquina previsível de atração, autoridade e vendas de '
              'serviços e produtos premium.',
              style: LpType.sans(
                size: 17,
                weight: FontWeight.w300,
                color: LpColors.ink2,
                height: 1.7,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Reveal(
          delayMs: 240,
          child: LpButton(
            label: 'Quero vender todos os dias',
            onTap: onContato,
          ),
        ),
        const SizedBox(height: 36),
        Reveal(delayMs: 320, child: const _HeroProof()),
      ],
    );
  }
}

class _HeroProof extends StatelessWidget {
  const _HeroProof();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42 + 30 * 2,
          height: 42,
          child: Stack(
            children: [
              for (var i = 0; i < 3; i++)
                Positioned(
                  left: i * 30,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: LpColors.cream2,
                      border: Border.all(color: LpColors.cream, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: LpColors.ink3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text.rich(
            TextSpan(
              style: LpType.sans(
                size: 13.5,
                weight: FontWeight.w300,
                color: LpColors.ink2,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '+ de 500 alunas',
                  style: LpType.sans(
                    size: 13.5,
                    weight: FontWeight.w500,
                    color: LpColors.ink,
                    height: 1.4,
                  ),
                ),
                const TextSpan(
                  text: ' transformando seus negócios todos os dias.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = w * 3.7 / 3;
        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // decorative gold ring (sits 18px outside the portrait)
              Positioned(
                left: -18,
                right: -18,
                top: -18,
                bottom: -18,
                child: _ring(w + 36, h + 36),
              ),
              Positioned.fill(child: _arch(w, h)),
              Positioned(
                top: h * 0.08,
                left: -w * 0.06,
                child: const FloatyChip(
                  label: '358 curtidas',
                  icon: Icons.favorite,
                  heart: true,
                  delayMs: 0,
                ),
              ),
              Positioned(
                bottom: h * 0.14,
                right: -w * 0.08,
                child: const FloatyChip(
                  label: '92 comentários',
                  icon: Icons.chat_bubble,
                  delayMs: 1400,
                ),
              ),
              Positioned(
                top: h * 0.46,
                right: -w * 0.12,
                child: const FloatyChip(
                  label: 'Novo lead',
                  icon: Icons.send,
                  delayMs: 700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _arch(double w, double h) {
    final radius = BorderRadius.only(
      topLeft: Radius.elliptical(w / 2, h / 2),
      topRight: Radius.elliptical(w / 2, h / 2),
      bottomLeft: Radius.elliptical(w / 2, h * 0.38),
      bottomRight: Radius.elliptical(w / 2, h * 0.38),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [LpColors.cream2, Color(0xFFE3D6BF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1A15).withValues(alpha: 0.45),
            blurRadius: 90,
            spreadRadius: -50,
            offset: const Offset(0, 50),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          'assets/images/lp1/miriam-hero.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _ring(double w, double h) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: LpColors.gold),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(w / 2, h / 2),
            topRight: Radius.elliptical(w / 2, h / 2),
            bottomLeft: Radius.elliptical(w / 2, h * 0.40),
            bottomRight: Radius.elliptical(w / 2, h * 0.40),
          ),
        ),
      ),
    );
  }
}

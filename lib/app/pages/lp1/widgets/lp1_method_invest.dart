import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// Method / phones
// ---------------------------------------------------------------------------
class Lp1MethodSection extends StatelessWidget {
  const Lp1MethodSection({super.key, this.onInvest});

  final VoidCallback? onInvest;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return LpSection(
      background: LpColors.cream,
      stackBehind: const MonogramBg(letter: 'R', vw: 64),
      child: LpSplit(
        gap: lpClampVw(30, 5, 70, width),
        crossAxisAlignment: CrossAxisAlignment.center,
        left: Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('O método'),
              const SizedBox(height: 18),
              Text(
                'Chega de perfil bonito e vazio.',
                style: LpType.sectionTitle(width),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  'Meu método é para você que quer parar de só postar e começar '
                  'a vender. Estratégia personalizada, conteúdo que conecta e '
                  'posicionamento que gera confiança, autoridade e clientes.',
                  style: LpType.sans(
                    size: 16.5,
                    weight: FontWeight.w300,
                    color: LpColors.ink2,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              LpButton(
                label: 'Ver como funciona',
                gold: false,
                onTap: onInvest,
              ),
            ],
          ),
        ),
        right: const Reveal(delayMs: 160, child: _Phones()),
      ),
    );
  }
}

class _Phones extends StatelessWidget {
  const _Phones();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gap = width <= kLpMobileBreak ? 10.0 : 18.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final phoneW = math.min(constraints.maxWidth * 0.46, 230.0);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _phone(phoneW, dy: 20, deg: -4),
            SizedBox(width: gap),
            _phone(phoneW, dy: -12, deg: 3),
          ],
        );
      },
    );
  }

  Widget _phone(double w, {required double dy, required double deg}) {
    final h = w * 19 / 9;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(0.0, dy)
        ..rotateZ(deg * math.pi / 180),
      child: Container(
        width: w,
        height: h,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: LpColors.ink,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D1A15).withValues(alpha: 0.7),
              blurRadius: 90,
              spreadRadius: -50,
              offset: const Offset(0, 50),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Container(
            color: LpColors.cream2,
            alignment: Alignment.center,
            child: Icon(
              Icons.phone_iphone,
              color: LpColors.ink3.withValues(alpha: 0.5),
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Investment ledger
// ---------------------------------------------------------------------------
class Lp1InvestSection extends StatelessWidget {
  const Lp1InvestSection({super.key, this.onContato});

  final VoidCallback? onContato;

  static const _rows = <_LedgerData>[
    _LedgerData(
      icon: Icons.add_circle_outline,
      title: 'Vamos conversar?',
      desc: 'Primeiro passo para transformar seu Instagram',
      price: 'Gratuito',
      small: 'Diagnóstico',
    ),
    _LedgerData(
      icon: Icons.show_chart,
      title: 'Consultoria estratégica',
      desc: 'Direção clara em uma sessão intensiva',
      price: 'R\$ 4.497',
    ),
    _LedgerData(
      icon: Icons.person_outline,
      title: 'Mentoria individual',
      desc: 'Acompanhamento personalizado',
      price: 'R\$ 12.900',
    ),
    _LedgerData(
      icon: Icons.group_outlined,
      title: 'Mentoria em grupo',
      desc: 'Transforme e escale seu negócio',
      price: 'R\$ 5.700',
    ),
    _LedgerData(
      icon: Icons.desktop_windows_outlined,
      title: 'Cursos',
      desc: 'Aprenda no seu ritmo',
      price: 'R\$ 2.990',
    ),
    _LedgerData(
      icon: Icons.auto_awesome_outlined,
      title: 'Workshops',
      desc: 'Imersões práticas de alto valor',
      price: 'R\$ 1.290',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return LpSection(
      background: LpColors.cream2,
      child: LpSplit(
        flexLeft: 85,
        flexRight: 115,
        left: Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Investimento'),
              const SizedBox(height: 20),
              Text(
                'Onde a sua próxima fase começa.',
                style: LpType.sectionTitle(width),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Text(
                  'Aqui, conversamos sobre a criação de posicionamento '
                  'estratégico, funis de conteúdo e campanhas que envolvem as '
                  'métricas que realmente importam para aumentar o seu '
                  'faturamento.',
                  style: LpType.sans(
                    size: 16.5,
                    weight: FontWeight.w300,
                    color: LpColors.ink2,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              LpButton(
                label: 'Quero investir no meu negócio',
                onTap: onContato,
              ),
            ],
          ),
        ),
        right: Reveal(
          delayMs: 80,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: LpColors.line)),
            ),
            child: Column(
              children: [for (final r in _rows) _LedgerRow(data: r)],
            ),
          ),
        ),
      ),
    );
  }
}

class _LedgerData {
  const _LedgerData({
    required this.icon,
    required this.title,
    required this.desc,
    required this.price,
    this.small,
  });

  final IconData icon;
  final String title;
  final String desc;
  final String price;
  final String? small;
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.data});

  final _LedgerData data;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final priceSize = width <= kLpMobileBreak ? 19.0 : 23.0;

    return Hoverable(
      cursor: SystemMouseCursors.click,
      builder: (context, hovering) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: kLpEase,
          padding: EdgeInsets.only(
            left: hovering ? 20 : 6,
            right: 6,
            top: 26,
            bottom: 26,
          ),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: LpColors.line)),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: kLpEase,
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hovering ? LpColors.ink : Colors.transparent,
                  border: Border.all(
                    color: hovering ? LpColors.ink : LpColors.line,
                  ),
                ),
                child: Icon(
                  data.icon,
                  size: 20,
                  color: hovering ? LpColors.gold2 : LpColors.goldDeep,
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: LpType.serif(
                        size: 24,
                        weight: FontWeight.w500,
                        color: LpColors.ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.desc,
                      style: LpType.sans(
                        size: 13.5,
                        weight: FontWeight.w300,
                        color: LpColors.ink3,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.price,
                    style: LpType.serif(
                      size: priceSize,
                      weight: FontWeight.w500,
                      color: LpColors.goldDeep,
                    ),
                  ),
                  if (data.small != null)
                    Text(
                      data.small!,
                      style: LpType.sans(
                        size: 13,
                        weight: FontWeight.w300,
                        color: LpColors.ink3,
                        letterSpacing: 0.5,
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

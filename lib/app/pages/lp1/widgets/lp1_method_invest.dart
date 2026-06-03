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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Eyebrow('O método'),
              const SizedBox(height: 18),
              Text(
                'Não somos uma agência. Não somos uma consultoria genérica.',
                style: LpType.sectionTitle(width),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  'Somos os parceiros que entram no seu negócio, entendem o '
                  'gargalo real e implementam a tecnologia exata que você '
                  'precisa para escalar.',
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
      icon: Icons.schedule_outlined,
      title: 'Horas salvas por semana',
      desc: 'Com automação de processos repetitivos',
      price: '+20h',
    ),
    _LedgerData(
      icon: Icons.trending_down,
      title: 'Redução de retrabalho',
      desc: 'Operacional eliminado com integrações',
      price: '-80%',
    ),
    _LedgerData(
      icon: Icons.money_off_outlined,
      title: 'Custo por processo automatizado',
      desc: 'Na sua operação após implementação',
      price: 'R\$ 0,00',
    ),
    _LedgerData(
      icon: Icons.groups_outlined,
      title: 'Atendimentos simultâneos',
      desc: 'Sem ampliar o time atual',
      price: '×3',
    ),
    _LedgerData(
      icon: Icons.hub_outlined,
      title: 'Sistemas integrados',
      desc: 'Em uma única operação centralizada',
      price: '100%',
    ),
    _LedgerData(
      icon: Icons.trending_up,
      title: 'Potencial de escala',
      desc: 'Da sua empresa com a tecnologia certa',
      price: 'EXPONENCIAL',
      small: 'resultado',
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Eyebrow('Métricas reais'),
              const SizedBox(height: 20),
              Text(
                'Porque aqui olhamos para o que realmente importa.',
                style: LpType.sectionTitle(width),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Text(
                  'Falamos sobre o que está travando a escala da sua operação. '
                  'Sobre processos que deveriam ser automáticos mas ainda são '
                  'manuais. Sobre integrações que deveriam existir mas não existem.',
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
                label: 'Quero uma vaga',
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
              mainAxisSize: MainAxisSize.min,
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
                    style: LpType.numeral(
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

import 'package:flutter/material.dart';

import 'package:metrifica_landing/app/pages/lp1/lp1_theme.dart';

// ---------------------------------------------------------------------------
// Final CTA
// ---------------------------------------------------------------------------
class Lp1FinalCtaSection extends StatelessWidget {
  const Lp1FinalCtaSection({super.key, this.onContato});

  final VoidCallback? onContato;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final h2Size = lpClampVw(32, 4.4, 58, width);

    return LpSection(
      background: LpColors.cream2,
      child: LpSplit(
        flexLeft: 11,
        flexRight: 9,
        gap: lpClampVw(40, 6, 90, width),
        crossAxisAlignment: CrossAxisAlignment.center,
        left: Reveal(
          child: Text.rich(
            TextSpan(
              style: LpType.serif(
                size: h2Size,
                weight: FontWeight.w500,
                color: LpColors.ink,
                height: 1.05,
              ),
              children: [
                const TextSpan(
                  text:
                      'Pronta para atrair clientes e vender todos os dias? ',
                ),
                TextSpan(
                  text: 'Eu posso te ajudar.',
                  style: LpType.serif(
                    size: h2Size,
                    weight: FontWeight.w500,
                    color: LpColors.goldDeep,
                    height: 1.05,
                    italic: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        right: Reveal(
          delayMs: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Text(
                  'Vamos criar um plano estratégico personalizado para o seu '
                  'negócio e transformar seu Instagram em uma máquina de vendas.',
                  style: LpType.sans(
                    size: 16.5,
                    weight: FontWeight.w300,
                    color: LpColors.ink2,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              LpButton(
                label: 'Quero vender todos os dias',
                onTap: onContato,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// About
// ---------------------------------------------------------------------------
class Lp1AboutSection extends StatelessWidget {
  const Lp1AboutSection({super.key});

  static const _stats = <(String, String)>[
    ('8 anos', 'De mercado'),
    ('+500', 'Alunas'),
    ('+3M', 'Em faturamento'),
  ];

  static const _accordion = <(String, String)>[
    (
      'Minha missão',
      'Mostrar que o Instagram pode ser muito mais que um perfil bonito: uma '
          'ferramenta real de atração, autoridade e vendas consistentes para o '
          'seu negócio.'
    ),
    (
      'Meu método',
      'Posicionamento estratégico, conteúdo que conecta e funis que transformam '
          'seguidores em clientes prontos para comprar a sua oferta premium.'
    ),
    (
      'Por que eu faço o que faço?',
      'Porque acredito que toda empresária merece previsibilidade, liberdade e '
          'um negócio que cresce com estrutura — não na base da sorte ou do '
          'achismo.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return LpSection(
      background: LpColors.cream,
      child: LpSplit(
        flexLeft: 8,
        flexRight: 12,
        left: Reveal(
          child: AspectRatio(
            aspectRatio: 3 / 3.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/lp1/miriam-hero.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        right: Reveal(
          delayMs: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Sobre mim'),
              const SizedBox(height: 18),
              Text('Miriam Santos', style: LpType.sectionTitle(width)),
              const SizedBox(height: 26),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sou estrategista digital e mentora de empresárias que '
                      'querem vender serviços e produtos de alto valor todos os '
                      'dias, com previsibilidade e liberdade.',
                      style: _bodyStyle,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Há mais de 8 anos, ajudo profissionais a construir '
                      'negócios digitais lucrativos — com posicionamento forte, '
                      'conteúdos que vendem e estratégias que realmente '
                      'funcionam.',
                      style: _bodyStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 36,
                runSpacing: 20,
                children: [
                  for (final s in _stats)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.$1,
                          style: LpType.serif(
                            size: 34,
                            weight: FontWeight.w500,
                            color: LpColors.goldDeep,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.$2.toUpperCase(),
                          style: LpType.sans(
                            size: 11,
                            weight: FontWeight.w400,
                            color: LpColors.ink3,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 32),
              const _Accordion(items: _accordion),
            ],
          ),
        ),
      ),
    );
  }

  static final TextStyle _bodyStyle = LpType.sans(
    size: 16,
    weight: FontWeight.w300,
    color: LpColors.ink2,
    height: 1.6,
  );
}

class _Accordion extends StatefulWidget {
  const _Accordion({required this.items});

  final List<(String, String)> items;

  @override
  State<_Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<_Accordion> {
  int _open = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: LpColors.line)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < widget.items.length; i++)
            _AccordionItem(
              title: widget.items[i].$1,
              body: widget.items[i].$2,
              open: _open == i,
              onTap: () => setState(() => _open = _open == i ? -1 : i),
            ),
        ],
      ),
    );
  }
}

class _AccordionItem extends StatelessWidget {
  const _AccordionItem({
    required this.title,
    required this.body,
    required this.open,
    required this.onTap,
  });

  final String title;
  final String body;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LpColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: LpType.serif(
                          size: 21,
                          weight: FontWeight.w500,
                          color: LpColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 400),
                      curve: kLpEase,
                      turns: open ? 0.125 : 0,
                      child: Text(
                        '+',
                        style: LpType.sans(
                          size: 24,
                          weight: FontWeight.w300,
                          color: LpColors.goldDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: kLpEase,
              alignment: Alignment.topCenter,
              child: open
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 22),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Text(
                          body,
                          style: LpType.sans(
                            size: 15,
                            weight: FontWeight.w300,
                            color: LpColors.ink2,
                            height: 1.6,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}

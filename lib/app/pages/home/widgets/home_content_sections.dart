import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrifica_landing/app/shared/widgets/max_width_container.dart';

const _blue = Color(0xFF2864E8);
const _dark = Color(0xFF0B1C45);
const _muted = Color(0xFF66758D);
const _border = Color(0xFFE4EAFF);

class HomeProblemSection extends StatelessWidget {
  const HomeProblemSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _cards = [
    (
      'Operação presa em pessoas',
      'Se um processo depende de alguém lembrar de fazer, ele não é um processo. É uma aposta diária no fator humano.',
    ),
    (
      'Dados que não falam entre si',
      'Planilha aqui, sistema ali, BI manual acolá. Você toma decisões de escala com informação fragmentada e insegura.',
    ),
    (
      'Tecnologia que chegou no limite',
      'O que foi solução rápida virou dívida lenta. No-code, sistemas prontos e adaptações sobre adaptações já bateram no teto.',
    ),
    (
      'Crescimento que cria mais caos',
      'Cada cliente novo, contratação e processo a mais amplifica o problema. Escalar vira custo, não alavanca.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      isMobile: isMobile,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            label: 'O PROBLEMA',
            title:
                'Você não está travado por falta de tecnologia. Está travado pela falta de tecnologia própria.',
            body:
                'Empresas que não têm tecnologia própria não têm apenas um problema de concorrência no mercado. Têm problema de estrutura. E estrutura não se resolve com sistema genérico, no-code improvisado ou IA aplicada por cima de processo quebrado. Resolve com tecnologia própria construída sob medida para o seu modelo de negócio.',
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 30 : 44),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.75 : 0.88,
            children: [
              for (var i = 0; i < _cards.length; i++)
                _ProblemCard(
                  index: i + 1,
                  title: _cards[i].$1,
                  body: _cards[i].$2,
                ),
            ],
          ),
          SizedBox(height: isMobile ? 28 : 44),
          _BlueCallout(
            title: 'O seu negócio já passou desse ponto?',
            body:
                'Vamos entender juntos onde a falta de tecnologia própria está travando o seu crescimento.',
            button: 'Agendar consultoria gratuita',
          ),
          SizedBox(height: isMobile ? 34 : 56),
          Text(
            'Mais esforço não vai resolver. Mais gente não vai resolver. Mais sistema genérico definitivamente não vai.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 31 : 56,
              fontWeight: FontWeight.w900,
              height: 1.02,
              letterSpacing: isMobile ? -1.4 : -2.8,
              color: _dark,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Escala não vem de esforço. Vem de tecnologia própria, construída sob medida do zero para o seu negócio.',
            style: _bodyStyle(isMobile).copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class HomeProjectDevelopmentSection extends StatelessWidget {
  const HomeProjectDevelopmentSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _phases = [
    _PhaseData(
      '01',
      'Descoberta',
      'Diagnóstico e mapeamento',
      'A primeira conversa não é sobre tecnologia. É sobre o seu negócio, onde quer chegar e o que está travando essa trajetória.',
      [
        'Entrevistas com stakeholders',
        'Mapeamento de processos',
        'Análise de sistemas existentes',
      ],
    ),
    _PhaseData(
      '02',
      'Arquitetura',
      'Projeto técnico, segurança e escopo',
      'Com o problema claro, projetamos a arquitetura da solução com requisitos de segurança desde o início.',
      [
        'Arquitetura de sistema',
        'Requisitos de segurança',
        'Escopo e cronograma',
      ],
    ),
    _PhaseData(
      '03',
      'Desenvolvimento',
      'Iteração por iteração',
      'Ciclos curtos com entregas reais. Você acompanha o progresso, testa e dá feedback em tempo real.',
      [
        'Sprints com entregas reais',
        'Ambiente de testes',
        'Alinhamentos semanais',
      ],
    ),
    _PhaseData(
      '04',
      'Lançamento',
      'Testes, segurança e go-live',
      'Antes de ir ao ar, o sistema passa por testes de carga, segurança e usabilidade com lançamento acompanhado.',
      [
        'Testes de carga e segurança',
        'Deploy assistido',
        'Monitoramento em tempo real',
      ],
    ),
    _PhaseData(
      '05',
      'Evolução',
      'Sistema crescendo com o negócio',
      'O lançamento é o começo. Monitoramos, corrigimos e evoluímos conforme a operação cresce.',
      ['Suporte e manutenção', 'Novas funcionalidades', 'Otimização contínua'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      isMobile: isMobile,
      color: const Color(0xFFFBFCFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            label: 'COMO O PROJETO É DESENVOLVIDO',
            title: 'Da primeira conversa ao sistema em produção.',
            body:
                'Você sabe exatamente o que acontece em cada fase, sem caixa preta e sem surpresa no meio do caminho.',
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 30 : 46),
          Column(
            children: [
              for (final phase in _phases) ...[
                _PhaseCard(phase: phase, isMobile: isMobile),
                if (phase != _phases.last) const SizedBox(height: 14),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class HomeDifferenceSection extends StatelessWidget {
  const HomeDifferenceSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _market = [
    'No-code apresentado como solução definitiva',
    'IA milagrosa aplicada por cima de processo quebrado',
    'Sistema genérico com outra logo',
    'Segurança tratada como opcional',
    'Entrega e some',
    'Proposta antes de entender o problema',
  ];

  static const _metrifica = [
    'Sistema desenvolvido do zero, sem atalhos',
    'Tecnologia real para o seu modelo de negócio',
    'Segurança projetada desde a arquitetura',
    'Código que escala com o seu crescimento',
    'Parceria contínua, não só entrega',
    'Diagnóstico antes de qualquer proposta',
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      isMobile: isMobile,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            label: 'A DIFERENÇA',
            title:
                'O mercado vende sistema genérico. A Metrifica constrói tecnologia própria.',
            body: null,
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 28 : 42),
          if (isMobile)
            Column(
              children: const [
                _ComparisonCard(
                  title: 'Como o mercado opera',
                  items: _market,
                  accent: Color(0xFFEF4444),
                ),
                SizedBox(height: 18),
                _ComparisonCard(
                  title: 'Como a Metrifica trabalha',
                  items: _metrifica,
                  accent: _blue,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: _ComparisonCard(
                    title: 'Como o mercado opera',
                    items: _market,
                    accent: Color(0xFFEF4444),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: _ComparisonCard(
                    title: 'Como a Metrifica trabalha',
                    items: _metrifica,
                    accent: _blue,
                  ),
                ),
              ],
            ),
          SizedBox(height: isMobile ? 28 : 42),
          _BlueCallout(
            title: 'Pronto para sair do genérico?',
            body:
                'Entenda o que seria necessário para construir tecnologia própria no seu negócio.',
            button: 'Agendar consultoria gratuita',
          ),
          SizedBox(height: isMobile ? 32 : 52),
          Text(
            'Empresas que constroem tecnologia própria não param de crescer. As que dependem de sistema genérico começam a envelhecer.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 28 : 44,
              fontWeight: FontWeight.w900,
              height: 1.06,
              letterSpacing: -1.6,
              color: _dark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tecnologia não é custo operacional. É a infraestrutura que determina o quanto do seu potencial você consegue transformar em resultado real.',
            style: _bodyStyle(isMobile),
          ),
        ],
      ),
    );
  }
}

class HomeFaqSection extends StatelessWidget {
  const HomeFaqSection({super.key, required this.isMobile});

  final bool isMobile;

  static const _faqs = [
    (
      'Quanto tempo leva para desenvolver o meu projeto?',
      'Depende da complexidade. Ferramentas internas e automações pontuais costumam levar de 4 a 8 semanas. Sistemas robustos, com múltiplos módulos e integrações, podem levar de 3 a 6 meses.',
    ),
    (
      'Por que não usar no-code ou plataformas prontas?',
      'Para validar uma ideia, no-code pode fazer sentido. Para empresas que já faturam acima de R\$ 300 mil por mês e querem crescer, essas soluções têm teto e cobram caro quando chega a hora de reescrever tudo.',
    ),
    (
      'Como a segurança dos dados é garantida?',
      'Segurança é requisito de arquitetura desde o início: controle de acesso, criptografia, auditoria de ações e conformidade com LGPD.',
    ),
    (
      'Qual é o perfil de empresa com quem vocês trabalham?',
      'Empresas com operação consolidada, normalmente acima de R\$ 300 mil por mês, que sentem que a tecnologia está limitando o crescimento.',
    ),
    (
      'Qual é o investimento para o meu projeto?',
      'O investimento depende do escopo real. A consultoria inicial é gratuita para entendermos o que faz sentido antes de qualquer proposta.',
    ),
    (
      'O que acontece depois que o projeto é entregue?',
      'O lançamento é o começo. Oferecemos suporte contínuo, manutenção e evolução conforme o negócio cresce.',
    ),
    (
      'Como funciona a consultoria gratuita?',
      'É uma conversa de 45 a 60 minutos com um membro sênior da equipe para entender o negócio, identificar travas e dar clareza sobre o caminho técnico.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      isMobile: isMobile,
      color: const Color(0xFFFBFCFF),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FaqIntro(isMobile: isMobile),
                const SizedBox(height: 34),
                for (final faq in _faqs)
                  _FaqTile(question: faq.$1, answer: faq.$2),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 360, child: _FaqIntro(isMobile: isMobile)),
                const SizedBox(width: 56),
                Expanded(
                  child: Column(
                    children: [
                      for (final faq in _faqs)
                        _FaqTile(question: faq.$1, answer: faq.$2),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class HomeFinalCtaSection extends StatelessWidget {
  const HomeFinalCtaSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      isMobile: isMobile,
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 26 : 48),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1C45),
          borderRadius: BorderRadius.circular(isMobile ? 24 : 34),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PRÓXIMO PASSO',
              style: _labelStyle().copyWith(color: Colors.white54),
            ),
            const SizedBox(height: 16),
            Text(
              'Pronto para construir tecnologia própria que sustenta o crescimento do seu negócio?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: isMobile ? 31 : 52,
                fontWeight: FontWeight.w900,
                height: 1.04,
                letterSpacing: -2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: isMobile ? null : 720,
              child: Text(
                'Uma conversa com a nossa equipe para entender onde o seu negócio está travando e o que seria necessário para destravar. Sem pitch de produto. Sem proposta prematura. Só clareza.',
                style: _bodyStyle(isMobile).copyWith(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 16,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _LightButton(text: 'Agendar consultoria gratuita'),
                Text(
                  'Sem compromisso. Retorno em até 24h.',
                  style: _bodyStyle(
                    isMobile,
                  ).copyWith(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.isMobile,
    required this.color,
    required this.child,
  });

  final bool isMobile;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 96),
      child: MaxWidthContainer(
        maxWidth: 1280,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 32),
        child: child,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.title,
    required this.body,
    required this.isMobile,
  });

  final String label;
  final String title;
  final String? body;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 14),
        SizedBox(
          width: isMobile ? null : 860,
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w900,
              height: 1.04,
              letterSpacing: isMobile ? -1.4 : -2.1,
              color: _dark,
            ),
          ),
        ),
        if (body != null) ...[
          const SizedBox(height: 18),
          SizedBox(
            width: isMobile ? null : 780,
            child: Text(body!, style: _bodyStyle(isMobile)),
          ),
        ],
      ],
    );
  }
}

class _ProblemCard extends StatelessWidget {
  const _ProblemCard({
    required this.index,
    required this.title,
    required this.body,
  });

  final int index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('0$index', style: _labelStyle()),
          const SizedBox(height: 14),
          Text(title, style: _cardTitleStyle()),
          const SizedBox(height: 10),
          Expanded(child: Text(body, style: _smallBodyStyle())),
        ],
      ),
    );
  }
}

class _BlueCallout extends StatelessWidget {
  const _BlueCallout({
    required this.title,
    required this.body,
    required this.button,
  });

  final String title;
  final String body;
  final String button;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _blue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 18,
        children: [
          SizedBox(
            width: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _cardTitleStyle().copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: _smallBodyStyle().copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          _LightButton(text: button),
        ],
      ),
    );
  }
}

class _LightButton extends StatelessWidget {
  const _LightButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.go('/contato'),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _blue,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.go('/contato'),
      style: OutlinedButton.styleFrom(
        foregroundColor: _blue,
        side: const BorderSide(color: _border, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.phase, required this.isMobile});

  final _PhaseData phase;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PhaseTitle(phase: phase),
                const SizedBox(height: 12),
                _PhaseBody(phase: phase),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 190, child: _PhaseTitle(phase: phase)),
                const SizedBox(width: 24),
                Expanded(child: _PhaseBody(phase: phase)),
              ],
            ),
    );
  }
}

class _FaqIntro extends StatelessWidget {
  const _FaqIntro({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          label: 'FAQ',
          title: 'Perguntas frequentes.',
          body:
              'Ainda tem dúvidas? Fale diretamente com a nossa equipe. A primeira conversa é gratuita e sem compromisso.',
          isMobile: isMobile,
        ),
        const SizedBox(height: 22),
        _OutlineButton(text: 'Agendar consultoria gratuita'),
      ],
    );
  }
}

class _PhaseTitle extends StatelessWidget {
  const _PhaseTitle({required this.phase});

  final _PhaseData phase;

  @override
  Widget build(BuildContext context) {
    return Text('${phase.number} — ${phase.title}', style: _cardTitleStyle());
  }
}

class _PhaseBody extends StatelessWidget {
  const _PhaseBody({required this.phase});

  final _PhaseData phase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phase.subtitle,
          style: _smallBodyStyle().copyWith(
            fontWeight: FontWeight.w900,
            color: _dark,
          ),
        ),
        const SizedBox(height: 8),
        Text(phase.body, style: _smallBodyStyle()),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final tag in phase.tags) _Tag(text: tag)],
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.items,
    required this.accent,
  });

  final String title;
  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _cardTitleStyle()),
          const SizedBox(height: 18),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded, color: accent, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: _smallBodyStyle())),
              ],
            ),
            if (item != items.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        iconColor: _blue,
        collapsedIconColor: _blue,
        title: Text(question, style: _cardTitleStyle().copyWith(fontSize: 16)),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(answer, style: _smallBodyStyle()),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          color: _blue,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PhaseData {
  const _PhaseData(
    this.number,
    this.title,
    this.subtitle,
    this.body,
    this.tags,
  );

  final String number;
  final String title;
  final String subtitle;
  final String body;
  final List<String> tags;
}

TextStyle _labelStyle() => GoogleFonts.plusJakartaSans(
  fontSize: 12,
  fontWeight: FontWeight.w900,
  letterSpacing: 1.5,
  color: _blue,
);

TextStyle _bodyStyle(bool isMobile) => GoogleFonts.plusJakartaSans(
  fontSize: isMobile ? 15 : 16,
  height: 1.65,
  fontWeight: FontWeight.w600,
  color: _muted,
);

TextStyle _smallBodyStyle() => GoogleFonts.plusJakartaSans(
  fontSize: 14,
  height: 1.55,
  fontWeight: FontWeight.w600,
  color: _muted,
);

TextStyle _cardTitleStyle() => GoogleFonts.plusJakartaSans(
  fontSize: 19,
  fontWeight: FontWeight.w900,
  height: 1.14,
  letterSpacing: -0.5,
  color: _dark,
);

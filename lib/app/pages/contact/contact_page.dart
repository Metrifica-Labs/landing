import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/pixel_service.dart';
import 'models/lead_model.dart';
import 'providers/lead_provider.dart';

const _kBlue = Color(0xFF2864E8);
const _kDark = Color(0xFF0F172A);
const _kMuted = Color(0xFF64748B);
const _kBorder = Color(0xFFE2E8F0);
const _totalSteps = 16;

const _revenueOptions = [
  'Até R\$100K',
  'R\$100K - R\$300K',
  'R\$300K - R\$1M',
  'R\$1M - R\$3M',
  'Acima de R\$3M',
];

const _momentOptions = [
  'Sou dono de várias lojas, estou crescendo, mas sem estrutura',
  'Tenho muitos clientes, minha operação não acompanha o crescimento',
  'Tenho demanda infinita e ainda dependo demais de pessoas/processos manuais',
  'Já tenho sistema, mas ele limita meu crescimento',
  'Quero um sistema ou app próprio',
];

const _problemOptions = [
  'Processos manuais e sem controle gerencial',
  'Retrabalho constante com muitos erros',
  'Sistemas que não conversam, não integram',
  'Falta de automação, agilidade e escala',
  'Falta de controle dos dados, falta de segurança',
  'Decisões sem dados, falta de controle da operação',
  'Equipe sobrecarregada',
  'Dependência de você para tudo',
  'Possibilidade de escalar mas falta estrutura',
];

const _attemptOptions = [
  'Sim, com ferramentas/sistemas prontos',
  'Sim, contratando desenvolvedor',
  'Sim, com agência',
  'Não tentei ainda',
  'Sim, mas nada resolveu de verdade',
];

const _investmentOptions = ['Sim', 'Depende do projeto', 'Não no momento'];

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _pageCtrl = PageController();
  int _step = 0;
  bool _pixelStarted = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _businessDescriptionCtrl = TextEditingController();
  final _consequenceCtrl = TextEditingController();
  final _failedAttemptCtrl = TextEditingController();
  final _currentSystemsCtrl = TextEditingController();
  final _idealSystemCtrl = TextEditingController();
  final _whyMetrificaCtrl = TextEditingController();
  String? _revenue;
  final Set<String> _moments = {};
  final Set<String> _problems = {};
  String? _previousAttempt;
  String? _willingToInvest;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _companyFocus = FocusNode();
  final _instagramFocus = FocusNode();
  final _businessDescriptionFocus = FocusNode();
  final _consequenceFocus = FocusNode();
  final _failedAttemptFocus = FocusNode();
  final _currentSystemsFocus = FocusNode();
  final _idealSystemFocus = FocusNode();
  final _whyMetrificaFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      final rng = Random();
      const names = [
        'João Silva',
        'Maria Oliveira',
        'Carlos Mendes',
        'Ana Beatriz Costa',
        'Rafael Souza',
        'Fernanda Lima',
        'Bruno Alves',
        'Juliana Ferreira',
        'Lucas Carvalho',
        'Camila Rocha',
      ];
      const domains = [
        'empresa.com.br',
        'negocio.com',
        'startup.io',
        'corp.com.br',
        'business.com',
        'grupo.com.br',
      ];
      const ddds = ['11', '21', '31', '41', '51', '61', '71', '85'];
      final name = names[rng.nextInt(names.length)];
      final slug = name
          .split(' ')
          .take(2)
          .join('.')
          .toLowerCase()
          .replaceAll(RegExp(r'[áàã]'), 'a')
          .replaceAll(RegExp(r'[éê]'), 'e')
          .replaceAll(RegExp(r'[í]'), 'i')
          .replaceAll(RegExp(r'[óõô]'), 'o')
          .replaceAll(RegExp(r'[ú]'), 'u');
      final ddd = ddds[rng.nextInt(ddds.length)];
      final phone = '9${rng.nextInt(9000) + 1000}-${rng.nextInt(9000) + 1000}';
      _nameCtrl.text = name;
      _phoneCtrl.text = '($ddd) $phone';
      _emailCtrl.text = '$slug@${domains[rng.nextInt(domains.length)]}';
      _companyCtrl.text = 'Empresa ${name.split(' ').last}';
      _instagramCtrl.text = '@${slug.replaceAll('.', '')}';
      _revenue = _revenueOptions[rng.nextInt(_revenueOptions.length)];
      _moments.add(_momentOptions.first);
      _businessDescriptionCtrl.text =
          'Operação em crescimento com vendas recorrentes e necessidade de escalar processos internos.';
      _problems.addAll([_problemOptions[0], _problemOptions[3]]);
      _consequenceCtrl.text =
          'A operação fica mais cara, lenta e dependente de pessoas-chave.';
      _previousAttempt = _attemptOptions.first;
      _failedAttemptCtrl.text =
          'As ferramentas prontas não se adaptaram ao fluxo real da empresa.';
      _currentSystemsCtrl.text =
          'Planilhas, WhatsApp, CRM e ERP. Atendem parcialmente.';
      _idealSystemCtrl.text =
          'Centralizaria dados, automatizaria tarefas e daria visão gerencial em tempo real.';
      _willingToInvest = _investmentOptions.first;
      _whyMetrificaCtrl.text =
          'Porque preciso transformar a operação em um sistema escalável e sob medida.';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _instagramCtrl.dispose();
    _businessDescriptionCtrl.dispose();
    _consequenceCtrl.dispose();
    _failedAttemptCtrl.dispose();
    _currentSystemsCtrl.dispose();
    _idealSystemCtrl.dispose();
    _whyMetrificaCtrl.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _companyFocus.dispose();
    _instagramFocus.dispose();
    _businessDescriptionFocus.dispose();
    _consequenceFocus.dispose();
    _failedAttemptFocus.dispose();
    _currentSystemsFocus.dispose();
    _idealSystemFocus.dispose();
    _whyMetrificaFocus.dispose();
    super.dispose();
  }

  void _onInteract() {
    if (_pixelStarted) return;
    _pixelStarted = true;
    PixelService.formStart();
  }

  bool _isValidEmail(String s) =>
      RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$').hasMatch(s);

  bool _canAdvance(int step) => switch (step) {
    0 => _nameCtrl.text.trim().isNotEmpty,
    1 => _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '').length >= 10,
    2 => _isValidEmail(_emailCtrl.text.trim()),
    3 => _companyCtrl.text.trim().isNotEmpty,
    4 => _instagramCtrl.text.trim().isNotEmpty,
    5 => _revenue != null,
    6 => _moments.isNotEmpty,
    7 => _businessDescriptionCtrl.text.trim().isNotEmpty,
    8 => _problems.isNotEmpty,
    9 => _consequenceCtrl.text.trim().isNotEmpty,
    10 => _previousAttempt != null,
    11 => _failedAttemptCtrl.text.trim().isNotEmpty,
    12 => _currentSystemsCtrl.text.trim().isNotEmpty,
    13 => _idealSystemCtrl.text.trim().isNotEmpty,
    14 => _willingToInvest != null,
    15 => _whyMetrificaCtrl.text.trim().isNotEmpty,
    _ => false,
  };

  void _next() {
    if (!_canAdvance(_step)) return;
    if (_step < _totalSteps - 1) {
      _animateTo(_step + 1);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) {
      _animateTo(_step - 1);
    } else {
      context.go('/');
    }
  }

  void _animateTo(int step) {
    _pageCtrl.animateToPage(
      step,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _step = step);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (step) {
        case 0:
          _nameFocus.requestFocus();
        case 1:
          _phoneFocus.requestFocus();
        case 2:
          _emailFocus.requestFocus();
        case 3:
          _companyFocus.requestFocus();
        case 4:
          _instagramFocus.requestFocus();
        case 7:
          _businessDescriptionFocus.requestFocus();
        case 9:
          _consequenceFocus.requestFocus();
        case 11:
          _failedAttemptFocus.requestFocus();
        case 12:
          _currentSystemsFocus.requestFocus();
        case 13:
          _idealSystemFocus.requestFocus();
        case 15:
          _whyMetrificaFocus.requestFocus();
        default:
          break;
      }
    });
  }

  Future<void> _submit() async {
    await ref
        .read(leadNotifierProvider.notifier)
        .submit(
          LeadModel(
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            companyName: _companyCtrl.text.trim(),
            instagram: _instagramCtrl.text.trim(),
            monthlyRevenue: _revenue!,
            businessMoment: _moments.toList(),
            businessDescription: _businessDescriptionCtrl.text.trim(),
            currentProblems: _problems.toList(),
            consequence12Months: _consequenceCtrl.text.trim(),
            previousAttempt: _previousAttempt!,
            failedAttemptDetails: _failedAttemptCtrl.text.trim(),
            currentSystems: _currentSystemsCtrl.text.trim(),
            idealSystemSolution: _idealSystemCtrl.text.trim(),
            willingToInvest: _willingToInvest!,
            whyMetrifica: _whyMetrificaCtrl.text.trim(),
          ),
        );
    if (!mounted) return;
    if (!ref.read(leadNotifierProvider).hasError) {
      PixelService.formSubmit();
      _pageCtrl.animateToPage(
        _totalSteps,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _step = _totalSteps);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadState = ref.watch(leadNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              step: _step,
              onBack: _step < _totalSteps ? _back : null,
              onClose: () => context.go('/'),
            ),
            if (_step < _totalSteps) _ProgressBar(step: _step),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _TextStep(
                    index: 0,
                    question: 'Qual é o seu\nnome completo?',
                    hint: 'Seu nome completo',
                    controller: _nameCtrl,
                    focusNode: _nameFocus,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    canAdvance: _canAdvance(0),
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 1,
                    question: 'E o seu número\ndo WhatsApp?',
                    hint: '(21) 99999-9999',
                    controller: _phoneCtrl,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.none,
                    canAdvance: _canAdvance(1),
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 2,
                    question: 'Qual é o seu\nmelhor e-mail?',
                    hint: 'seu@email.com',
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    canAdvance: _canAdvance(2),
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 3,
                    question: 'E o nome\nda empresa?',
                    hint: 'Nome da empresa',
                    controller: _companyCtrl,
                    focusNode: _companyFocus,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    canAdvance: _canAdvance(3),
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 4,
                    question: 'E o @ do\nInstagram?',
                    hint: '@suaempresa',
                    controller: _instagramCtrl,
                    focusNode: _instagramFocus,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    canAdvance: _canAdvance(4),
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _RevenueStep(
                    index: 5,
                    selected: _revenue,
                    onSelect: (v) {
                      _onInteract();
                      setState(() => _revenue = v);
                      Timer(const Duration(milliseconds: 200), _next);
                    },
                    onNext: _next,
                  ),
                  _ChoiceStep(
                    index: 6,
                    question: 'Qual alternativa descreve\nseu momento hoje?',
                    helper: 'Pode marcar mais de uma opção.',
                    options: _momentOptions,
                    selected: _moments,
                    canAdvance: _canAdvance(6),
                    onToggle: (v) {
                      _onInteract();
                      setState(
                        () => _moments.contains(v)
                            ? _moments.remove(v)
                            : _moments.add(v),
                      );
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 7,
                    question: 'Descreva seu modelo\nde negócio e objetivo',
                    hint: 'Nicho, operação atual e objetivo principal...',
                    controller: _businessDescriptionCtrl,
                    focusNode: _businessDescriptionFocus,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    canAdvance: _canAdvance(7),
                    maxLines: 5,
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _ChoiceStep(
                    index: 8,
                    question: 'Quais problemas você\nmais vive hoje?',
                    helper: 'Pode marcar mais de uma opção.',
                    options: _problemOptions,
                    selected: _problems,
                    canAdvance: _canAdvance(8),
                    onToggle: (v) {
                      _onInteract();
                      setState(
                        () => _problems.contains(v)
                            ? _problems.remove(v)
                            : _problems.add(v),
                      );
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 9,
                    question:
                        'O que acontece se continuar\nassim por 12 meses?',
                    hint: 'Descreva o impacto real no negócio...',
                    controller: _consequenceCtrl,
                    focusNode: _consequenceFocus,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    canAdvance: _canAdvance(9),
                    maxLines: 4,
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _SingleChoiceStep(
                    index: 10,
                    question: 'Você já tentou\nresolver isso antes?',
                    options: _attemptOptions,
                    selected: _previousAttempt,
                    canAdvance: _canAdvance(10),
                    onSelect: (v) {
                      _onInteract();
                      setState(() => _previousAttempt = v);
                      Timer(const Duration(milliseconds: 200), _next);
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 11,
                    question: 'O que não funcionou\nnessas tentativas?',
                    hint:
                        'Conte onde travou, o que faltou ou por que não resolveu...',
                    controller: _failedAttemptCtrl,
                    focusNode: _failedAttemptFocus,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    canAdvance: _canAdvance(11),
                    maxLines: 4,
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 12,
                    question: 'Quais sistemas você\nusa hoje?',
                    hint:
                        'CRM, ERP, planilhas, WhatsApp... Eles atendem totalmente?',
                    controller: _currentSystemsCtrl,
                    focusNode: _currentSystemsFocus,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    canAdvance: _canAdvance(12),
                    maxLines: 4,
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 13,
                    question:
                        'Se tivesse um sistema ideal,\no que ele resolveria?',
                    hint: 'Explique o resultado esperado para sua operação...',
                    controller: _idealSystemCtrl,
                    focusNode: _idealSystemFocus,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    canAdvance: _canAdvance(13),
                    maxLines: 4,
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _SingleChoiceStep(
                    index: 14,
                    question: 'Você está disposto\na investir para escalar?',
                    options: _investmentOptions,
                    selected: _willingToInvest,
                    canAdvance: _canAdvance(14),
                    onSelect: (v) {
                      _onInteract();
                      setState(() => _willingToInvest = v);
                      Timer(const Duration(milliseconds: 200), _next);
                    },
                    onNext: _next,
                  ),
                  _TextStep(
                    index: 15,
                    question: 'Por que a Metrifica pode\nte ajudar agora?',
                    hint: 'Conte por que faz sentido falar com nosso time...',
                    controller: _whyMetrificaCtrl,
                    focusNode: _whyMetrificaFocus,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    canAdvance: _canAdvance(15),
                    maxLines: 4,
                    isLoading: leadState.isLoading,
                    hasError: leadState.hasError,
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _SuccessStep(onHome: () => context.go('/')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.step,
    required this.onBack,
    required this.onClose,
  });

  final int step;
  final VoidCallback? onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          AnimatedOpacity(
            opacity: (step > 0 && step < _totalSteps) ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              color: _kMuted,
              onPressed: onBack,
              tooltip: 'Voltar',
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/metrifica.svg',
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'metrifica labs',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _kDark,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            color: _kMuted,
            onPressed: onClose,
            tooltip: 'Fechar',
          ),
        ],
      ),
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: (step + 1) / _totalSteps),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (_, value, __) => LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor: const Color(0xFFF1F5F9),
        valueColor: const AlwaysStoppedAnimation(_kBlue),
        minHeight: 3,
      ),
    );
  }
}

// ─── Step Layout ─────────────────────────────────────────────────────────────

class _StepLayout extends StatelessWidget {
  const _StepLayout({
    required this.index,
    required this.question,
    required this.input,
    required this.canAdvance,
    required this.onNext,
    this.isLastStep = false,
    this.isLoading = false,
    this.hasError = false,
  });

  final int index;
  final String question;
  final Widget input;
  final bool canAdvance;
  final VoidCallback onNext;
  final bool isLastStep;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 640;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pergunta ${index + 1} de $_totalSteps',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                      color: _kBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isMobile ? 30 : 40,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                      letterSpacing: -1.4,
                      color: _kDark,
                    ),
                  ),
                  const SizedBox(height: 40),
                  input,
                  const SizedBox(height: 36),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(
                        'Algo deu errado. Tente novamente.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  AnimatedOpacity(
                    opacity: canAdvance || isLoading || hasError ? 1.0 : 0.35,
                    duration: const Duration(milliseconds: 250),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (canAdvance && !isLoading) ? onNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kBlue,
                          disabledBackgroundColor: _kBlue,
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                hasError
                                    ? 'Tentar novamente'
                                    : isLastStep
                                    ? 'Enviar'
                                    : 'Continuar',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Pressione Enter ↵',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFFB0BDD0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Text Step ───────────────────────────────────────────────────────────────

class _TextStep extends StatelessWidget {
  const _TextStep({
    required this.index,
    required this.question,
    required this.hint,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.textCapitalization,
    required this.canAdvance,
    required this.onChanged,
    required this.onNext,
    this.maxLines = 1,
    this.isLoading = false,
    this.hasError = false,
  });

  final int index;
  final String question;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool canAdvance;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;
  final int maxLines;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return _StepLayout(
      index: index,
      question: question,
      canAdvance: canAdvance,
      onNext: onNext,
      isLastStep: isLoading || hasError,
      isLoading: isLoading,
      hasError: hasError,
      input: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: maxLines > 1
            ? TextInputAction.newline
            : TextInputAction.done,
        minLines: 1,
        maxLines: maxLines,
        onChanged: onChanged,
        onSubmitted: maxLines > 1 ? null : (_) => onNext(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _kDark,
          height: 1.3,
        ),
        cursorColor: _kBlue,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFCBD5E1),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: _kBorder, width: 2),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: _kBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// ─── Revenue Step ────────────────────────────────────────────────────────────

class _RevenueStep extends StatelessWidget {
  const _RevenueStep({
    required this.index,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  final int index;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepLayout(
      index: index,
      question: 'Qual é o faturamento\nmédio mensal atual?',
      canAdvance: selected != null,
      onNext: onNext,
      input: Column(
        children: _revenueOptions
            .map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RevenueCard(
                  label: option,
                  selected: selected == option,
                  onTap: () => onSelect(option),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SingleChoiceStep extends StatelessWidget {
  const _SingleChoiceStep({
    required this.index,
    required this.question,
    required this.options,
    required this.selected,
    required this.canAdvance,
    required this.onSelect,
    required this.onNext,
  });

  final int index;
  final String question;
  final List<String> options;
  final String? selected;
  final bool canAdvance;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepLayout(
      index: index,
      question: question,
      canAdvance: canAdvance,
      onNext: onNext,
      input: Column(
        children: options
            .map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RevenueCard(
                  label: option,
                  selected: selected == option,
                  onTap: () => onSelect(option),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({
    required this.index,
    required this.question,
    required this.helper,
    required this.options,
    required this.selected,
    required this.canAdvance,
    required this.onToggle,
    required this.onNext,
  });

  final int index;
  final String question;
  final String helper;
  final List<String> options;
  final Set<String> selected;
  final bool canAdvance;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepLayout(
      index: index,
      question: question,
      canAdvance: canAdvance,
      onNext: onNext,
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            helper,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kMuted,
            ),
          ),
          const SizedBox(height: 14),
          ...options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RevenueCard(
                label: option,
                selected: selected.contains(option),
                onTap: () => onToggle(option),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _kBlue : _kBorder,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _kBlue : Colors.transparent,
                border: Border.all(
                  color: selected ? _kBlue : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 11,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.38,
                  color: selected ? _kBlue : _kDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Success Step ─────────────────────────────────────────────────────────────

class _SuccessStep extends StatelessWidget {
  const _SuccessStep({required this.onHome});

  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 640;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEF3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: _kBlue, size: 38),
              ),
              const SizedBox(height: 36),
              Text(
                'Aplicação\nrecebida!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 34 : 44,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                  letterSpacing: -1.4,
                  color: _kDark,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Todo formulário recebido é analisado minuciosamente pelo nosso time. Se sua aplicação for aprovada, entraremos em contato em até 1 dia útil para agendar uma consultoria estratégica de viabilidade do seu projeto. Fique atento ao seu WhatsApp!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                  color: _kMuted,
                ),
              ),
              const SizedBox(height: 52),
              OutlinedButton(
                onPressed: onHome,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kDark,
                  side: const BorderSide(color: _kBorder, width: 1.5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '← Voltar para o início',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

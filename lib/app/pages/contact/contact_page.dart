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

const _revenueOptions = [
  'até R\$ 50 mil/mês',
  'R\$ 50k – R\$ 200k/mês',
  'R\$ 200k – R\$ 1 mi/mês',
  'acima de R\$ 1 mi/mês',
];

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
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _revenue;

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      final rng = Random();
      const names = [
        'João Silva', 'Maria Oliveira', 'Carlos Mendes', 'Ana Beatriz Costa',
        'Rafael Souza', 'Fernanda Lima', 'Bruno Alves', 'Juliana Ferreira',
        'Lucas Carvalho', 'Camila Rocha',
      ];
      const domains = [
        'empresa.com.br', 'negocio.com', 'startup.io', 'corp.com.br',
        'business.com', 'grupo.com.br',
      ];
      const ddds = ['11', '21', '31', '41', '51', '61', '71', '85'];
      final name = names[rng.nextInt(names.length)];
      final slug = name.split(' ').take(2).join('.').toLowerCase()
          .replaceAll(RegExp(r'[áàã]'), 'a')
          .replaceAll(RegExp(r'[éê]'), 'e')
          .replaceAll(RegExp(r'[í]'), 'i')
          .replaceAll(RegExp(r'[óõô]'), 'o')
          .replaceAll(RegExp(r'[ú]'), 'u');
      final ddd = ddds[rng.nextInt(ddds.length)];
      final phone = '9${rng.nextInt(9000) + 1000}-${rng.nextInt(9000) + 1000}';
      _nameCtrl.text = name;
      _emailCtrl.text = '$slug@${domains[rng.nextInt(domains.length)]}';
      _phoneCtrl.text = '($ddd) $phone';
      _revenue = _revenueOptions[rng.nextInt(_revenueOptions.length)];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
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
    1 => _isValidEmail(_emailCtrl.text.trim()),
    2 => _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '').length >= 10,
    3 => _revenue != null,
    _ => false,
  };

  void _next() {
    if (!_canAdvance(_step)) return;
    if (_step < 3) {
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
          _emailFocus.requestFocus();
        case 2:
          _phoneFocus.requestFocus();
        default:
          break;
      }
    });
  }

  Future<void> _submit() async {
    await ref.read(leadNotifierProvider.notifier).submit(
      LeadModel(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        monthlyRevenue: _revenue!,
      ),
    );
    if (!mounted) return;
    if (!ref.read(leadNotifierProvider).hasError) {
      PixelService.formSubmit();
      _pageCtrl.animateToPage(
        4,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _step = 4);
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
              onBack: _step < 4 ? _back : null,
              onClose: () => context.go('/'),
            ),
            if (_step < 4) _ProgressBar(step: _step),
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
                    question: 'Qual é o seu\ne-mail?',
                    hint: 'seu@email.com',
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
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
                    question: 'Qual é o seu\nWhatsApp?',
                    hint: '(11) 99999-9999',
                    controller: _phoneCtrl,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.none,
                    canAdvance: _canAdvance(2),
                    onChanged: (_) {
                      _onInteract();
                      setState(() {});
                    },
                    onNext: _next,
                  ),
                  _RevenueStep(
                    selected: _revenue,
                    isLoading: leadState.isLoading,
                    hasError: leadState.hasError,
                    onSelect: (v) {
                      _onInteract();
                      setState(() => _revenue = v);
                      Timer(const Duration(milliseconds: 200), _next);
                    },
                    onRetry: _next,
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
            opacity: (step > 0 && step < 4) ? 1.0 : 0.0,
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
      tween: Tween(end: (step + 1) / 4),
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
                'Pergunta ${index + 1} de 4',
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
                    onPressed:
                        (canAdvance && !isLoading) ? onNext : null,
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

  @override
  Widget build(BuildContext context) {
    return _StepLayout(
      index: index,
      question: question,
      canAdvance: canAdvance,
      onNext: onNext,
      input: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: TextInputAction.done,
        onChanged: onChanged,
        onSubmitted: (_) => onNext(),
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
    required this.selected,
    required this.isLoading,
    required this.hasError,
    required this.onSelect,
    required this.onRetry,
  });

  final String? selected;
  final bool isLoading;
  final bool hasError;
  final ValueChanged<String> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _StepLayout(
      index: 3,
      question: 'Qual o faturamento\nmédio mensal?',
      canAdvance: selected != null,
      onNext: onRetry,
      isLastStep: true,
      isLoading: isLoading,
      hasError: hasError,
      input: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _RevenueCard(
                  label: _revenueOptions[0],
                  selected: selected == _revenueOptions[0],
                  onTap: () => onSelect(_revenueOptions[0]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RevenueCard(
                  label: _revenueOptions[1],
                  selected: selected == _revenueOptions[1],
                  onTap: () => onSelect(_revenueOptions[1]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _RevenueCard(
                  label: _revenueOptions[2],
                  selected: selected == _revenueOptions[2],
                  onTap: () => onSelect(_revenueOptions[2]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RevenueCard(
                  label: _revenueOptions[3],
                  selected: selected == _revenueOptions[3],
                  onTap: () => onSelect(_revenueOptions[3]),
                ),
              ),
            ],
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
                child: const Icon(
                  Icons.check_rounded,
                  color: _kBlue,
                  size: 38,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Recebemos seu\ncontato!',
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
                'Em breve nossa equipe vai\nentrar em contato com você.',
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

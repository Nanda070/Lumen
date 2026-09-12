import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../core/region_options.dart';
import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Premium 5-step onboarding → creates local profile + seed data.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.database,
    required this.locale,
    required this.onLocaleChanged,
    required this.onCompleted,
  });

  final AppDatabase database;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onCompleted;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  static const _pageCount = 5;

  final _pageController = PageController();
  final _nameController = TextEditingController();

  int _page = 0;
  String _localeCode = 'en';
  String _countryCode = 'US';
  String _currencyCode = 'USD';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _localeCode = widget.locale.languageCode;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    if (_page == 0) return _nameController.text.trim().isNotEmpty;
    return true;
  }

  Future<void> _next() async {
    if (_page < _pageCount - 1) {
      await _pageController.nextPage(
        duration: LumenMotion.normal,
        curve: LumenMotion.spring,
      );
      return;
    }
    await _finish();
  }

  Future<void> _back() async {
    if (_page == 0) return;
    await _pageController.previousPage(
      duration: LumenMotion.normal,
      curve: LumenMotion.spring,
    );
  }

  Future<void> _finish() async {
    if (_saving) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    try {
      await widget.database.completeOnboarding(
        displayName: name,
        localeCode: _localeCode,
        countryCode: _countryCode,
        currencyCode: _currencyCode,
      );
      if (!mounted) return;
      widget.onCompleted();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).onboardingSaveError),
          backgroundColor: LumenColors.surfaceRaised,
        ),
      );
    }
  }

  void _setLocale(String code) {
    setState(() => _localeCode = code);
    widget.onLocaleChanged(Locale(code));
  }

  void _setCountry(String code) {
    setState(() {
      _countryCode = code;
      _currencyCode = RegionOptions.defaultCurrencyFor(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return AtmosphereBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LumenSpacing.pagePadding,
                  LumenSpacing.md,
                  LumenSpacing.pagePadding,
                  LumenSpacing.sm,
                ),
                child: Row(
                  children: [
                    if (_page > 0)
                      IconButton(
                        onPressed: _saving ? null : _back,
                        icon: const Icon(PhosphorIconsRegular.caretLeft),
                        color: LumenColors.textMuted,
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: _ProgressDots(
                        count: _pageCount,
                        index: _page,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    _NameStep(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                    ),
                    _LocaleStep(
                      localeCode: _localeCode,
                      countryCode: _countryCode,
                      onLocale: _setLocale,
                      onCountry: _setCountry,
                    ),
                    _CurrencyStep(
                      currencyCode: _currencyCode,
                      localeCode: _localeCode,
                      onCurrency: (c) => setState(() => _currencyCode = c),
                    ),
                    const _GoogleStep(),
                    _ReadyStep(name: _nameController.text.trim()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  LumenSpacing.pagePadding,
                  LumenSpacing.sm,
                  LumenSpacing.pagePadding,
                  LumenSpacing.md + bottom,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: !_canContinue || _saving ? null : _next,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: LumenColors.bg,
                            ),
                          )
                        : Text(
                            _page == _pageCount - 1
                                ? l10n.onboardingFinish
                                : l10n.onboardingContinue,
                            style: theme.labelLarge?.copyWith(
                              color: LumenColors.bg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: LumenMotion.fast,
            curve: LumenMotion.spring,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            width: i == index ? 22 : 6,
            decoration: BoxDecoration(
              color: i == index
                  ? LumenColors.accentViolet
                  : LumenColors.textMuted.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
      ],
    );
  }
}

class _StepChrome extends StatelessWidget {
  const _StepChrome({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: LumenSpacing.lg),
          Text(
            eyebrow,
            style: theme.labelMedium?.copyWith(
              color: LumenColors.accentViolet,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: LumenSpacing.sm),
          Text(title, style: theme.headlineLarge),
          const SizedBox(height: LumenSpacing.xs),
          Text(
            subtitle,
            style: theme.bodyMedium?.copyWith(
              color: LumenColors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: LumenSpacing.xl),
          child,
          const SizedBox(height: LumenSpacing.xxl),
        ],
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _StepChrome(
      eyebrow: l10n.appTitle,
      title: l10n.onboardingNameTitle,
      subtitle: l10n.onboardingNameSubtitle,
      child: GlassSurface(
        glowColor: LumenColors.accentViolet,
        padding: const EdgeInsets.all(LumenSpacing.md),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: l10n.onboardingNameHint,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

class _LocaleStep extends StatelessWidget {
  const _LocaleStep({
    required this.localeCode,
    required this.countryCode,
    required this.onLocale,
    required this.onCountry,
  });

  final String localeCode;
  final String countryCode;
  final ValueChanged<String> onLocale;
  final ValueChanged<String> onCountry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return _StepChrome(
      eyebrow: l10n.appTitle,
      title: l10n.onboardingLocaleTitle,
      subtitle: l10n.onboardingLocaleSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.language, style: theme.labelMedium),
          const SizedBox(height: LumenSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _ChoiceChip(
                  label: l10n.languageEnglish,
                  selected: localeCode == 'en',
                  onTap: () => onLocale('en'),
                ),
              ),
              const SizedBox(width: LumenSpacing.sm),
              Expanded(
                child: _ChoiceChip(
                  label: l10n.languageRussian,
                  selected: localeCode == 'ru',
                  onTap: () => onLocale('ru'),
                ),
              ),
            ],
          ),
          const SizedBox(height: LumenSpacing.xl),
          Text(l10n.onboardingCountryLabel, style: theme.labelMedium),
          const SizedBox(height: LumenSpacing.sm),
          ...RegionOptions.countries.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: LumenSpacing.xs),
              child: _ChoiceChip(
                label: c.label(localeCode),
                selected: countryCode == c.countryCode,
                onTap: () => onCountry(c.countryCode),
                fullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyStep extends StatelessWidget {
  const _CurrencyStep({
    required this.currencyCode,
    required this.localeCode,
    required this.onCurrency,
  });

  final String currencyCode;
  final String localeCode;
  final ValueChanged<String> onCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _StepChrome(
      eyebrow: l10n.appTitle,
      title: l10n.onboardingCurrencyTitle,
      subtitle: l10n.onboardingCurrencySubtitle,
      child: Column(
        children: [
          for (final c in RegionOptions.currencies)
            Padding(
              padding: const EdgeInsets.only(bottom: LumenSpacing.xs),
              child: _ChoiceChip(
                label: '${c.code} · ${c.label(localeCode)}',
                selected: currencyCode == c.code,
                onTap: () => onCurrency(c.code),
                fullWidth: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _GoogleStep extends StatelessWidget {
  const _GoogleStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return _StepChrome(
      eyebrow: l10n.appTitle,
      title: l10n.onboardingGoogleTitle,
      subtitle: l10n.onboardingGoogleSubtitle,
      child: GlowCard(
        violetEdge: true,
        padding: const EdgeInsets.all(LumenSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              PhosphorIconsRegular.calendarBlank,
              color: LumenColors.accentBlue,
              size: 28,
            ),
            const SizedBox(height: LumenSpacing.md),
            Text(
              l10n.onboardingGoogleCardTitle,
              style: theme.titleMedium,
            ),
            const SizedBox(height: LumenSpacing.xs),
            Text(
              l10n.onboardingGoogleCardBody,
              style: theme.bodyMedium?.copyWith(
                color: LumenColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadyStep extends StatelessWidget {
  const _ReadyStep({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final greeting = name.isEmpty
        ? l10n.onboardingReadyTitle
        : l10n.onboardingReadyTitleNamed(name);

    return _StepChrome(
      eyebrow: l10n.appTitle,
      title: greeting,
      subtitle: l10n.onboardingReadySubtitle,
      child: GlowCard(
        violetEdge: true,
        padding: const EdgeInsets.all(LumenSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.onboardingReadySeedTitle, style: theme.titleMedium),
            const SizedBox(height: LumenSpacing.sm),
            Text(
              l10n.onboardingReadySeedBody,
              style: theme.bodyMedium?.copyWith(
                color: LumenColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.fullWidth = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: selected ? LumenColors.accentCream : LumenColors.surfaceRaised,
      borderRadius: LumenRadii.card,
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.card,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.md,
            vertical: LumenSpacing.md,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? LumenColors.bg : LumenColors.text,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: child);
    }
    return child;
  }
}

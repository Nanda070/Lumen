import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../core/world_currencies.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Premium searchable ISO currency picker (bottom sheet).
Future<String?> showCurrencyPickerSheet({
  required BuildContext context,
  required String localeCode,
  required String selectedCode,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _CurrencyPickerSheet(
        localeCode: localeCode,
        selectedCode: selectedCode,
      );
    },
  );
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({
    required this.localeCode,
    required this.selectedCode,
  });

  final String localeCode;
  final String selectedCode;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _query = TextEditingController();
  late List<CurrencyOption> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = WorldCurrencies.all;
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _onQuery(String value) {
    setState(() {
      _filtered = WorldCurrencies.search(value, widget.localeCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final height = MediaQuery.sizeOf(context).height * 0.78;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: height,
        child: GlassSurface(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(LumenRadii.lg),
          ),
          fillColor: LumenColors.bgElevated.withValues(alpha: 0.96),
          strokeColor: LumenColors.glassStrokeViolet,
          glowColor: LumenColors.accentViolet,
          padding: const EdgeInsets.fromLTRB(
            LumenSpacing.pagePadding,
            LumenSpacing.md,
            LumenSpacing.pagePadding,
            LumenSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LumenColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: LumenSpacing.md),
              Text(l10n.onboardingCurrencyTitle, style: theme.titleLarge),
              const SizedBox(height: LumenSpacing.xs),
              Text(
                l10n.currencySearchHint,
                style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
              ),
              const SizedBox(height: LumenSpacing.md),
              TextField(
                controller: _query,
                autofocus: true,
                onChanged: _onQuery,
                style: theme.titleMedium,
                decoration: InputDecoration(
                  hintText: l10n.currencySearchHint,
                  prefixIcon: const Icon(
                    PhosphorIconsRegular.magnifyingGlass,
                    color: LumenColors.textMuted,
                  ),
                  filled: true,
                  fillColor: LumenColors.surfaceRaised,
                  border: OutlineInputBorder(
                    borderRadius: LumenRadii.card,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: LumenSpacing.sm),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.currencySearchEmpty,
                          style: theme.bodyMedium?.copyWith(
                            color: LumenColors.textMuted,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final c = _filtered[index];
                          final selected = c.code == widget.selectedCode;
                          return Material(
                            color: selected
                                ? LumenColors.accentBlue.withValues(alpha: 0.18)
                                : LumenColors.surfaceRaised.withValues(
                                    alpha: 0.72,
                                  ),
                            borderRadius: LumenRadii.card,
                            child: InkWell(
                              onTap: () => Navigator.pop(context, c.code),
                              borderRadius: LumenRadii.card,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: LumenSpacing.md,
                                  vertical: LumenSpacing.md,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 44,
                                      child: Text(
                                        c.code,
                                        style: theme.titleMedium?.copyWith(
                                          color: selected
                                              ? LumenColors.accentBlue
                                              : LumenColors.text,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        c.label(widget.localeCode),
                                        style: theme.bodyMedium?.copyWith(
                                          color: LumenColors.textMuted,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      const Icon(
                                        PhosphorIconsFill.checkCircle,
                                        color: LumenColors.accentMint,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

Future<void> showTodayWidgetsSheet({
  required BuildContext context,
  required AppDatabase database,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => TodayWidgetsSheet(database: database),
  );
}

class TodayWidgetsSheet extends StatelessWidget {
  const TodayWidgetsSheet({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return GlassSurface(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(LumenRadii.lg),
      ),
      fillColor: LumenColors.bgElevated.withValues(alpha: 0.94),
      strokeColor: LumenColors.glassStrokeViolet,
      glowColor: LumenColors.accentViolet,
      padding: const EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        LumenSpacing.md,
        LumenSpacing.pagePadding,
        LumenSpacing.xl,
      ),
      child: StreamBuilder<TodayPreference?>(
        stream: database.watchTodayPreferences(),
        builder: (context, snapshot) {
          final prefs = snapshot.data;
          final showFinance = prefs?.showFinanceSummary ?? true;
          final showBudget = prefs?.showBudgetStatus ?? true;
          final showSpend = prefs?.showTodaySpend ?? true;
          final showEvents = prefs?.showTodayEvents ?? true;

          return Column(
            mainAxisSize: MainAxisSize.min,
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
              Text(l10n.todayWidgetsTitle, style: theme.titleLarge),
              const SizedBox(height: LumenSpacing.xxs),
              Text(
                l10n.todayWidgetsSubtitle,
                style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
              ),
              const SizedBox(height: LumenSpacing.lg),
              _ToggleRow(
                label: l10n.todayWidgetFinance,
                value: showFinance,
                onChanged: (v) => database.updateTodayPreferences(
                  showFinanceSummary: v,
                ),
              ),
              _ToggleRow(
                label: l10n.todayWidgetBudget,
                value: showBudget,
                onChanged: (v) => database.updateTodayPreferences(
                  showBudgetStatus: v,
                ),
              ),
              _ToggleRow(
                label: l10n.todayWidgetSpend,
                value: showSpend,
                onChanged: (v) =>
                    database.updateTodayPreferences(showTodaySpend: v),
              ),
              _ToggleRow(
                label: l10n.todayWidgetEvents,
                value: showEvents,
                onChanged: (v) =>
                    database.updateTodayPreferences(showTodayEvents: v),
              ),
              const SizedBox(height: LumenSpacing.md),
            ],
          );
        },
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LumenSpacing.sm),
      child: GlowCard(
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.md,
          vertical: LumenSpacing.xs,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            Switch.adaptive(
              value: value,
              activeThumbColor: LumenColors.accentMint,
              activeTrackColor: LumenColors.accentMint.withValues(alpha: 0.35),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

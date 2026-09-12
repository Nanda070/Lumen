import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'dashboard_storage.dart';

Future<void> showTodayWidgetsSheet({
  required BuildContext context,
  required AppDatabase database,
  Set<String>? presentIds,
  ValueChanged<String>? onAdd,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => TodayWidgetsSheet(
      database: database,
      presentIds: presentIds,
      onAdd: onAdd,
    ),
  );
}

class TodayWidgetsSheet extends StatefulWidget {
  const TodayWidgetsSheet({
    super.key,
    required this.database,
    this.presentIds,
    this.onAdd,
  });

  final AppDatabase database;
  final Set<String>? presentIds;
  final ValueChanged<String>? onAdd;

  @override
  State<TodayWidgetsSheet> createState() => _TodayWidgetsSheetState();
}

class _TodayWidgetsSheetState extends State<TodayWidgetsSheet> {
  Set<String> _present = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPresent();
  }

  Future<void> _loadPresent() async {
    if (widget.presentIds != null) {
      setState(() {
        _present = widget.presentIds!;
        _loading = false;
      });
      return;
    }
    final raw = await widget.database.getDashboardLayoutJson();
    final ids = <String>{};
    if (raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          for (final slot in decoded.values) {
            if (slot is Map) ids.addAll(slot.keys.cast<String>());
          }
        }
      } catch (_) {}
    }
    if (ids.isEmpty) {
      ids.addAll(
        DashboardStorage.defaultLayout(2).map((e) => e.identifier),
      );
    }
    if (mounted) {
      setState(() {
        _present = ids;
        _loading = false;
      });
    }
  }

  Future<void> _handleAdd(String id) async {
    if (widget.onAdd != null) {
      widget.onAdd!(id);
      if (mounted) Navigator.of(context).pop();
      return;
    }
    // Persist into layoutJson for both slot counts (More → Settings).
    final raw = await widget.database.getDashboardLayoutJson();
    Map<String, dynamic> root = {};
    if (raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) root = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    for (final sc in DashboardStorage.slotCounts) {
      final key = '$sc';
      final slot = <String, dynamic>{};
      final existing = root[key];
      if (existing is Map) {
        for (final e in existing.entries) {
          slot[e.key.toString()] = e.value;
        }
      } else {
        for (final item in DashboardStorage.defaultLayout(sc)) {
          slot[item.identifier] = item.toMap();
        }
      }
      final item = DashboardStorage.newItem(id, sc);
      slot[id] = item.toMap();
      root[key] = slot;
    }
    await widget.database.saveDashboardLayoutJson(jsonEncode(root));
    if (mounted) Navigator.of(context).pop();
  }

  String _label(AppLocalizations l10n, String id) {
    return switch (id) {
      TodayWidgetIds.budgetRing => l10n.todayWidgetBudgetRing,
      TodayWidgetIds.spent => l10n.todayWidgetSpent,
      TodayWidgetIds.remaining => l10n.todayWidgetRemaining,
      TodayWidgetIds.spendToday => l10n.todayWidgetSpend,
      TodayWidgetIds.eventsCount => l10n.todayWidgetEventsCount,
      TodayWidgetIds.eventsList => l10n.todayWidgetEvents,
      TodayWidgetIds.categoryDonut => l10n.todayWidgetCategoryDonut,
      TodayWidgetIds.cashflow => l10n.todayWidgetCashflow,
      TodayWidgetIds.accounts => l10n.todayWidgetAccounts,
      _ => id,
    };
  }

  IconData _icon(String id) {
    return switch (id) {
      TodayWidgetIds.budgetRing => PhosphorIconsRegular.circle,
      TodayWidgetIds.spent => PhosphorIconsRegular.trendDown,
      TodayWidgetIds.remaining => PhosphorIconsRegular.wallet,
      TodayWidgetIds.spendToday => PhosphorIconsRegular.coins,
      TodayWidgetIds.eventsCount => PhosphorIconsRegular.hash,
      TodayWidgetIds.eventsList => PhosphorIconsRegular.calendarBlank,
      TodayWidgetIds.categoryDonut => PhosphorIconsRegular.chartPie,
      TodayWidgetIds.cashflow => PhosphorIconsRegular.chartLineUp,
      TodayWidgetIds.accounts => PhosphorIconsRegular.bank,
      _ => PhosphorIconsRegular.squaresFour,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final available =
        TodayWidgetIds.all.where((id) => !_present.contains(id)).toList();

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
      child: Column(
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
          const SizedBox(height: LumenSpacing.xs),
          Text(
            l10n.todayResizeHint,
            style: theme.labelMedium?.copyWith(color: LumenColors.accentViolet),
          ),
          const SizedBox(height: LumenSpacing.lg),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(LumenSpacing.lg),
              child: Center(
                child: CircularProgressIndicator(color: LumenColors.accentViolet),
              ),
            )
          else if (available.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: LumenSpacing.md),
              child: Text(
                l10n.todayAllWidgetsAdded,
                style: theme.bodyMedium?.copyWith(color: LumenColors.textMuted),
              ),
            )
          else
            for (final id in available)
              Padding(
                padding: const EdgeInsets.only(bottom: LumenSpacing.sm),
                child: GlowCard(
                  onTap: () => _handleAdd(id),
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumenSpacing.md,
                    vertical: LumenSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Icon(_icon(id), color: LumenColors.accentViolet, size: 22),
                      const SizedBox(width: LumenSpacing.sm),
                      Expanded(
                        child: Text(
                          _label(l10n, id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleMedium,
                        ),
                      ),
                      const Icon(
                        PhosphorIconsRegular.plus,
                        color: LumenColors.accentMint,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: LumenSpacing.md),
        ],
      ),
    );
  }
}

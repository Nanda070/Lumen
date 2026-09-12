import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';
import '../calendar/calendar_date_utils.dart';
import '../calendar/event_editor_sheet.dart';
import '../finance/finance_charts.dart';
import '../finance/money_format.dart';
import '../finance/transaction_editor_sheet.dart';
import 'today_widgets_sheet.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({
    super.key,
    required this.database,
    this.currencyCode = 'USD',
  });

  final AppDatabase database;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final today = CalendarDateUtils.dateOnly(DateTime.now());
    final now = DateTime.now();

    return StreamBuilder<TodayPreference?>(
      stream: database.watchTodayPreferences(),
      builder: (context, prefsSnap) {
        final prefs = prefsSnap.data;
        final showFinance = prefs?.showFinanceSummary ?? true;
        final showBudget = prefs?.showBudgetStatus ?? true;
        final showSpend = prefs?.showTodaySpend ?? true;
        final showEvents = prefs?.showTodayEvents ?? true;
        final order = (prefs?.widgetOrder ??
                'finance,budget,spend,events')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        return StreamBuilder<MonthFinanceSummary>(
          stream: database.watchMonthSummary(now.year, now.month),
          builder: (context, monthSnap) {
            final month = monthSnap.data;
            return StreamBuilder<int>(
              stream: database.watchDaySpend(today),
              builder: (context, spendSnap) {
                final daySpend = spendSnap.data ?? 0;
                return StreamBuilder<List<EventWithCalendar>>(
                  stream: database.watchEventsForDay(today),
                  builder: (context, eventSnap) {
                    final events = eventSnap.data ?? const [];
                    final upcoming = events
                        .where((e) => e.event.endsAt.isAfter(DateTime.now()))
                        .toList();
                    final display =
                        upcoming.isNotEmpty ? upcoming : events;

                    final widgets = <Widget>[];
                    for (final id in order) {
                      switch (id) {
                        case 'finance':
                          if (!showFinance || month == null) break;
                          widgets.add(
                            _FinanceSummaryWidget(
                              summary: month,
                              currencyCode: currencyCode,
                              onAddTx: () => showTransactionEditorSheet(
                                context: context,
                                database: database,
                                currencyCode: currencyCode,
                              ),
                            ),
                          );
                        case 'budget':
                          if (!showBudget || month == null) break;
                          widgets.add(
                            _BudgetWidget(
                              summary: month,
                              currencyCode: currencyCode,
                            ),
                          );
                        case 'spend':
                          if (!showSpend) break;
                          widgets.add(
                            _SpendTodayWidget(
                              amountMinor: daySpend,
                              currencyCode: currencyCode,
                              eventsCount: display.length,
                            ),
                          );
                        case 'events':
                          if (!showEvents) break;
                          widgets.add(
                            _EventsWidget(
                              events: display,
                              database: database,
                              emptyLabel: l10n.todayEmptyEvents,
                            ),
                          );
                      }
                    }

                    // Fallback if prefs hide everything
                    if (widgets.isEmpty) {
                      widgets.add(
                        Text(
                          l10n.todayWidgetsSubtitle,
                          style: theme.bodySmall,
                        ),
                      );
                    }

                    return ModuleScaffold(
                      title: l10n.todayGreeting,
                      subtitle: l10n.todaySubtitle,
                      trailing: IconButton(
                        tooltip: l10n.todayEditWidgets,
                        onPressed: () => showTodayWidgetsSheet(
                          context: context,
                          database: database,
                        ),
                        icon: const Icon(
                          PhosphorIconsRegular.slidersHorizontal,
                          color: LumenColors.accentViolet,
                        ),
                      ),
                      slivers: [
                        for (var i = 0; i < widgets.length; i++) ...[
                          ContainedSliver(child: widgets[i]),
                          if (i < widgets.length - 1)
                            const ContainedSliver(
                              child: SizedBox(height: LumenSpacing.lg),
                            ),
                        ],
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class ContainedSliver extends StatelessWidget {
  const ContainedSliver({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.pagePadding,
        ),
        child: child,
      ),
    );
  }
}

class _FinanceSummaryWidget extends StatelessWidget {
  const _FinanceSummaryWidget({
    required this.summary,
    required this.currencyCode,
    required this.onAddTx,
  });

  final MonthFinanceSummary summary;
  final String currencyCode;
  final VoidCallback onAddTx;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.todayWidgetFinance, style: theme.titleLarge),
            ),
            IconButton(
              onPressed: onAddTx,
              icon: const Icon(
                PhosphorIconsRegular.plusCircle,
                color: LumenColors.accentMint,
              ),
            ),
          ],
        ),
        const SizedBox(height: LumenSpacing.sm),
        Row(
          children: [
            Expanded(
              child: GradientMetricCard(
                label: l10n.todayMonthSpent,
                value: MoneyFormat.formatCompact(summary.spentMinor),
                suffix: currencyCode,
                gradient: LumenColors.gradEmber,
              ),
            ),
            const SizedBox(width: LumenSpacing.sm),
            Expanded(
              child: GradientMetricCard(
                label: l10n.todayBudgetLeft,
                value: summary.remainingMinor == null
                    ? '—'
                    : MoneyFormat.formatCompact(summary.remainingMinor!),
                suffix:
                    summary.remainingMinor == null ? null : currencyCode,
                gradient: LumenColors.gradDusk,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BudgetWidget extends StatelessWidget {
  const _BudgetWidget({
    required this.summary,
    required this.currencyCode,
  });

  final MonthFinanceSummary summary;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final ratio = summary.spentRatio.clamp(0.0, 1.0);

    return GlowCard(
      violetEdge: true,
      padding: const EdgeInsets.all(LumenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.todayWidgetBudget, style: theme.titleMedium),
              ),
              BudgetStatusChip(status: summary.budgetStatus),
            ],
          ),
          const SizedBox(height: LumenSpacing.md),
          if (summary.budgetLimitMinor <= 0)
            Text(
              l10n.financeNoBudget,
              style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
            )
          else ...[
            Row(
              children: [
                Text(
                  MoneyFormat.formatCompact(
                    summary.spentMinor,
                    currencyCode: currencyCode,
                  ),
                  style: theme.titleLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  ' / ${MoneyFormat.formatCompact(summary.budgetLimitMinor, currencyCode: currencyCode)}',
                  style: theme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: LumenSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: LumenColors.surface,
                color: switch (summary.budgetStatus) {
                  'overspend' => LumenColors.accentRed,
                  'warning' => LumenColors.accentCream,
                  _ => LumenColors.accentMint,
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SpendTodayWidget extends StatelessWidget {
  const _SpendTodayWidget({
    required this.amountMinor,
    required this.currencyCode,
    required this.eventsCount,
  });

  final int amountMinor;
  final String currencyCode;
  final int eventsCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: GradientMetricCard(
            label: l10n.todaySpend,
            value: MoneyFormat.formatCompact(amountMinor),
            suffix: currencyCode,
            gradient: LumenColors.gradEmber,
          ),
        ),
        const SizedBox(width: LumenSpacing.sm),
        Expanded(
          child: GradientMetricCard(
            label: l10n.todayUpcoming,
            value: '$eventsCount',
            gradient: LumenColors.gradDusk,
          ),
        ),
      ],
    );
  }
}

class _EventsWidget extends StatelessWidget {
  const _EventsWidget({
    required this.events,
    required this.database,
    required this.emptyLabel,
  });

  final List<EventWithCalendar> events;
  final AppDatabase database;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.todayUpcoming, style: theme.titleLarge),
        const SizedBox(height: LumenSpacing.sm),
        if (events.isEmpty)
          Text(emptyLabel, style: theme.bodySmall)
        else
          for (final item in events) ...[
            EventCard(
              title: item.event.title,
              timeLabel: CalendarDateUtils.formatTimeRange(
                item.event.startsAt,
                item.event.endsAt,
              ),
              accent: Color(item.calendar.colorArgb),
              onTap: () => showEventEditorSheet(
                context: context,
                database: database,
                existing: item,
              ),
            ),
            const SizedBox(height: LumenSpacing.sm),
          ],
      ],
    );
  }
}

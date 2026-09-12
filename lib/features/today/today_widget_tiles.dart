import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../calendar/calendar_date_utils.dart';
import '../calendar/event_editor_sheet.dart';
import '../finance/finance_charts.dart';
import '../finance/money_format.dart';
import 'dashboard_storage.dart';

/// Builds a live tile for a Today dashboard [identifier].
class TodayWidgetTile extends StatelessWidget {
  const TodayWidgetTile({
    super.key,
    required this.identifier,
    required this.database,
    required this.currencyCode,
    this.isEditing = false,
    this.onDelete,
  });

  final String identifier;
  final AppDatabase database;
  final String currencyCode;
  final bool isEditing;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = CalendarDateUtils.dateOnly(now);

    Widget body;
    switch (identifier) {
      case TodayWidgetIds.budgetRing:
        body = StreamBuilder<MonthFinanceSummary>(
          stream: database.watchMonthSummary(now.year, now.month),
          builder: (context, snap) {
            final s = snap.data;
            if (s == null) return const _TileLoading();
            return BudgetHeroRing(
              summary: s,
              currencyCode: currencyCode,
              compact: true,
            );
          },
        );
      case TodayWidgetIds.spent:
        body = StreamBuilder<MonthFinanceSummary>(
          stream: database.watchMonthSummary(now.year, now.month),
          builder: (context, snap) {
            final l10n = AppLocalizations.of(context);
            final s = snap.data;
            return GradientMetricCard(
              label: l10n.todayMonthSpent,
              value: MoneyFormat.formatCard(s?.spentMinor ?? 0),
              suffix: currencyCode,
              gradient: LumenColors.gradEmber,
              compact: true,
            );
          },
        );
      case TodayWidgetIds.remaining:
        body = StreamBuilder<MonthFinanceSummary>(
          stream: database.watchMonthSummary(now.year, now.month),
          builder: (context, snap) {
            final l10n = AppLocalizations.of(context);
            final s = snap.data;
            final rem = s?.remainingMinor;
            return GradientMetricCard(
              label: l10n.todayBudgetLeft,
              value: rem == null ? '—' : MoneyFormat.formatCard(rem),
              suffix: rem == null ? null : currencyCode,
              gradient: LumenColors.gradDusk,
              compact: true,
            );
          },
        );
      case TodayWidgetIds.spendToday:
        body = StreamBuilder<int>(
          stream: database.watchDaySpend(today),
          builder: (context, snap) {
            final l10n = AppLocalizations.of(context);
            return GradientMetricCard(
              label: l10n.todaySpend,
              value: MoneyFormat.formatCard(snap.data ?? 0),
              suffix: currencyCode,
              gradient: LumenColors.gradEmber,
              compact: true,
            );
          },
        );
      case TodayWidgetIds.eventsCount:
        body = StreamBuilder<List<EventWithCalendar>>(
          stream: database.watchEventsForDay(today),
          builder: (context, snap) {
            final l10n = AppLocalizations.of(context);
            final count = snap.data?.length ?? 0;
            return GradientMetricCard(
              label: l10n.todayUpcoming,
              value: '$count',
              gradient: LumenColors.gradDusk,
              compact: true,
            );
          },
        );
      case TodayWidgetIds.eventsList:
        body = _EventsListTile(database: database, today: today);
      case TodayWidgetIds.categoryDonut:
        body = StreamBuilder<MonthFinanceSummary>(
          stream: database.watchMonthSummary(now.year, now.month),
          builder: (context, monthSnap) {
            return StreamBuilder<List<FinanceCategory>>(
              stream: database.watchCategories(),
              builder: (context, catSnap) {
                final s = monthSnap.data;
                if (s == null) return const _TileLoading();
                return FinanceDonutChart(
                  summary: s,
                  categories: catSnap.data ?? const [],
                  currencyCode: currencyCode,
                  compact: true,
                );
              },
            );
          },
        );
      case TodayWidgetIds.cashflow:
        body = StreamBuilder<MonthFinanceSummary>(
          stream: database.watchMonthSummary(now.year, now.month),
          builder: (context, snap) {
            final s = snap.data;
            if (s == null) return const _TileLoading();
            return FinanceCashflowChart(
              summary: s,
              currencyCode: currencyCode,
              compact: true,
            );
          },
        );
      case TodayWidgetIds.accounts:
        body = StreamBuilder<List<FinanceAccount>>(
          stream: database.watchAccounts(),
          builder: (context, snap) {
            final accounts = snap.data ?? const [];
            final l10n = AppLocalizations.of(context);
            final theme = Theme.of(context).textTheme;
            if (accounts.isEmpty) {
              return GlowCard(
                child: Center(
                  child: Text(
                    l10n.financeAccounts,
                    style: theme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }
            return GlowCard(
              violetEdge: true,
              padding: const EdgeInsets.symmetric(
                horizontal: LumenSpacing.sm,
                vertical: LumenSpacing.xs,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: accounts.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: LumenSpacing.sm),
                itemBuilder: (context, i) {
                  final a = accounts[i];
                  return SizedBox(
                    width: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          a.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.labelMedium,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            MoneyFormat.formatCompact(
                              a.balanceMinor,
                              currencyCode: a.currencyCode,
                            ),
                            style: theme.titleSmall?.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      default:
        body = GlowCard(
          child: Center(
            child: Text(
              identifier,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: body),
        if (isEditing && onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: LumenColors.surfaceRaised.withValues(alpha: 0.92),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    PhosphorIconsRegular.trash,
                    size: 14,
                    color: LumenColors.accentRed,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EventsListTile extends StatelessWidget {
  const _EventsListTile({required this.database, required this.today});

  final AppDatabase database;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return StreamBuilder<List<EventWithCalendar>>(
      stream: database.watchEventsForDay(today),
      builder: (context, snap) {
        final events = snap.data ?? const [];
        final upcoming = events
            .where((e) => e.event.endsAt.isAfter(DateTime.now()))
            .toList();
        final display = upcoming.isNotEmpty ? upcoming : events;

        return GlowCard(
          violetEdge: true,
          padding: const EdgeInsets.all(LumenSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.todayUpcoming,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleSmall,
              ),
              const SizedBox(height: LumenSpacing.xs),
              Expanded(
                child: display.isEmpty
                    ? Text(
                        l10n.todayEmptyEvents,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodySmall?.copyWith(
                          color: LumenColors.textMuted,
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: display.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: LumenSpacing.xs),
                        itemBuilder: (context, i) {
                          final item = display[i];
                          return EventCard(
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
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TileLoading extends StatelessWidget {
  const _TileLoading();

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: LumenColors.accentViolet.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

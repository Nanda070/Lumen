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
    this.onTap,
    this.onDelete,
  });

  final String identifier;
  final AppDatabase database;
  final String currencyCode;
  final bool isEditing;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = CalendarDateUtils.dateOnly(now);
    // Only wire tile-level navigation outside edit mode.
    final tileTap = isEditing ? null : onTap;

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
              onTap: tileTap,
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
              onTap: tileTap,
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
              onTap: tileTap,
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
              onTap: tileTap,
            );
          },
        );
      case TodayWidgetIds.eventsList:
        body = _EventsListTile(
          database: database,
          today: today,
          onOpenCalendar: tileTap,
        );
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

    final needsOuterTap = tileTap != null &&
        identifier != TodayWidgetIds.spent &&
        identifier != TodayWidgetIds.remaining &&
        identifier != TodayWidgetIds.spendToday &&
        identifier != TodayWidgetIds.eventsCount &&
        identifier != TodayWidgetIds.eventsList;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: needsOuterTap
              ? GestureDetector(
                  onTap: tileTap,
                  behavior: HitTestBehavior.opaque,
                  child: body,
                )
              : body,
        ),
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

/// Upcoming: up to **2** next events, fully visible, no nested scroll.
class _EventsListTile extends StatelessWidget {
  const _EventsListTile({
    required this.database,
    required this.today,
    this.onOpenCalendar,
  });

  final AppDatabase database;
  final DateTime today;
  final VoidCallback? onOpenCalendar;

  static const _maxEvents = 2;

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
            .toList()
          ..sort(
            (a, b) => a.event.startsAt.compareTo(b.event.startsAt),
          );
        final visible = upcoming.take(_maxEvents).toList();

        return GlowCard(
          violetEdge: true,
          onTap: onOpenCalendar,
          padding: const EdgeInsets.all(LumenSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.todayUpcoming,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleSmall,
              ),
              const SizedBox(height: LumenSpacing.xs),
              if (visible.isEmpty)
                Expanded(
                  child: Text(
                    l10n.todayEmptyEvents,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.bodySmall?.copyWith(
                      color: LumenColors.textMuted,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < visible.length; i++) ...[
                        if (i > 0)
                          const SizedBox(height: LumenSpacing.xs),
                        Expanded(
                          child: _UpcomingEventCard(
                            item: visible[i],
                            database: database,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  const _UpcomingEventCard({required this.item, required this.database});

  final EventWithCalendar item;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final accent = Color(item.calendar.colorArgb);

    return Material(
      color: LumenColors.surfaceRaised.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(LumenRadii.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(LumenRadii.sm),
        onTap: () => showEventEditorSheet(
          context: context,
          database: database,
          existing: item,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(LumenRadii.sm),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumenSpacing.sm,
                  vertical: LumenSpacing.xs,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CalendarDateUtils.formatTimeRange(
                        item.event.startsAt,
                        item.event.endsAt,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall?.copyWith(
                        color: LumenColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

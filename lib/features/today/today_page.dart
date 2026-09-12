import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';
import '../calendar/calendar_date_utils.dart';
import '../calendar/event_editor_sheet.dart';

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

    return StreamBuilder<List<EventWithCalendar>>(
      stream: database.watchEventsForDay(today),
      builder: (context, snapshot) {
        final events = snapshot.data ?? const [];
        final upcoming = events
            .where((e) => e.event.endsAt.isAfter(DateTime.now()))
            .toList();
        final display = upcoming.isNotEmpty ? upcoming : events;

        return ModuleScaffold(
          title: l10n.todayGreeting,
          subtitle: l10n.todaySubtitle,
          slivers: [
            ContainedSliver(
              child: Row(
                children: [
                  Expanded(
                    child: GradientMetricCard(
                      label: l10n.todaySpend,
                      value: '0',
                      suffix: currencyCode,
                      gradient: LumenColors.gradEmber,
                    ),
                  ),
                  const SizedBox(width: LumenSpacing.sm),
                  Expanded(
                    child: GradientMetricCard(
                      label: l10n.todayUpcoming,
                      value: '${display.length}',
                      gradient: LumenColors.gradDusk,
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: LumenSpacing.xl)),
            ContainedSliver(
              child: Text(l10n.todayUpcoming, style: theme.titleLarge),
            ),
            const ContainedSliver(child: SizedBox(height: LumenSpacing.sm)),
            if (display.isEmpty)
              ContainedSliver(
                child: Text(
                  l10n.todayEmptyEvents,
                  style: theme.bodySmall,
                ),
              )
            else
              for (final item in display) ...[
                ContainedSliver(
                  child: EventCard(
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
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: LumenSpacing.sm),
                ),
              ],
          ],
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

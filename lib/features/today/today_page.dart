import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

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
                  suffix: 'USD',
                  gradient: LumenColors.gradEmber,
                ),
              ),
              const SizedBox(width: LumenSpacing.sm),
              Expanded(
                child: GradientMetricCard(
                  label: l10n.todayUpcoming,
                  value: '1',
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
        ContainedSliver(
          child: EventCard(
            title: l10n.todaySampleEvent,
            timeLabel: l10n.todaySampleTime,
            accent: LumenColors.accentRed,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: LumenSpacing.md)),
        ContainedSliver(
          child: Text(
            l10n.todayEmptyEvents,
            style: theme.bodySmall,
          ),
        ),
      ],
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

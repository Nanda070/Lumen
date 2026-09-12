import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'category_labels.dart';
import 'money_format.dart';

class FinanceDonutChart extends StatelessWidget {
  const FinanceDonutChart({
    super.key,
    required this.summary,
    required this.categories,
    required this.currencyCode,
  });

  final MonthFinanceSummary summary;
  final List<FinanceCategory> categories;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final catMap = {for (final c in categories) c.id: c};
    final entries = summary.spentByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty || summary.spentMinor <= 0) {
      return GlassSurface(
        padding: const EdgeInsets.all(LumenSpacing.lg),
        child: SizedBox(
          height: 160,
          child: Center(
            child: Text(
              l10n.financeEmptyTx,
              style: theme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final sections = <PieChartSectionData>[];
    for (final e in entries.take(8)) {
      final cat = catMap[e.key];
      final color = Color(cat?.colorArgb ?? 0xFF8B919C);
      final pct = e.value / summary.spentMinor;
      sections.add(
        PieChartSectionData(
          value: e.value.toDouble(),
          color: color,
          radius: 28,
          showTitle: pct >= 0.08,
          title: '${(pct * 100).round()}%',
          titleStyle: theme.labelMedium?.copyWith(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return GlassSurface(
      glowColor: LumenColors.accentViolet,
      padding: const EdgeInsets.all(LumenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.financeByCategory, style: theme.titleMedium),
          const SizedBox(height: LumenSpacing.md),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 48,
                      sections: sections,
                      pieTouchData: PieTouchData(enabled: true),
                    ),
                  ),
                ),
                const SizedBox(width: LumenSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final e in entries.take(5)) ...[
                        _LegendRow(
                          color: Color(
                            catMap[e.key]?.colorArgb ?? 0xFF8B919C,
                          ),
                          label: catMap[e.key] == null
                              ? '—'
                              : categoryLabel(l10n, catMap[e.key]!),
                          amount: MoneyFormat.formatCompact(
                            e.value,
                            currencyCode: currencyCode,
                          ),
                        ),
                        const SizedBox(height: LumenSpacing.xs),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.amount,
  });

  final Color color;
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: theme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          amount,
          style: theme.labelMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class FinanceBarChart extends StatelessWidget {
  const FinanceBarChart({
    super.key,
    required this.summary,
    required this.currencyCode,
  });

  final MonthFinanceSummary summary;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final daysInMonth = DateTime(summary.year, summary.month + 1, 0).day;
    final maxY = summary.spentByDay.values.fold<int>(0, (a, b) => a > b ? a : b);
    final chartMax = (maxY <= 0 ? 100 : maxY * 1.2).toDouble();

    return GlassSurface(
      glowColor: LumenColors.accentRed,
      padding: const EdgeInsets.all(LumenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.financeTrend, style: theme.titleMedium),
          const SizedBox(height: LumenSpacing.md),
          SizedBox(
            height: 160,
            child: maxY <= 0
                ? Center(
                    child: Text(l10n.financeEmptyTx, style: theme.bodySmall),
                  )
                : BarChart(
                    BarChartData(
                      maxY: chartMax,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: LumenColors.divider,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: (daysInMonth / 4).ceilToDouble(),
                            getTitlesWidget: (value, meta) {
                              final d = value.toInt();
                              if (d < 1 || d > daysInMonth) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                '$d',
                                style: theme.labelMedium?.copyWith(
                                  color: LumenColors.textMuted,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        for (var d = 1; d <= daysInMonth; d++)
                          BarChartGroupData(
                            x: d,
                            barRods: [
                              BarChartRodData(
                                toY: (summary.spentByDay[d] ?? 0).toDouble(),
                                width: daysInMonth > 28 ? 4 : 6,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                gradient: LumenColors.gradEmber,
                              ),
                            ],
                          ),
                      ],
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => LumenColors.surfaceRaised,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final amount = MoneyFormat.formatCompact(
                              rod.toY.round(),
                              currencyCode: currencyCode,
                            );
                            return BarTooltipItem(
                              amount,
                              theme.labelMedium!.copyWith(
                                color: LumenColors.text,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class BudgetStatusChip extends StatelessWidget {
  const BudgetStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (status) {
      'ok' => (l10n.financeStatusOk, LumenColors.accentMint),
      'warning' => (l10n.financeStatusWarning, LumenColors.accentCream),
      'overspend' => (l10n.financeStatusOver, LumenColors.accentRed),
      _ => (l10n.financeStatusNone, LumenColors.textMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.sm,
        vertical: LumenSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: LumenRadii.pill,
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

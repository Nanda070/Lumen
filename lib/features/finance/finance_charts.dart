import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'category_labels.dart';
import 'money_format.dart';

Color _statusColor(String status) {
  return switch (status) {
    'overspend' => LumenColors.accentRed,
    'warning' => LumenColors.accentCream,
    'ok' => LumenColors.accentMint,
    _ => LumenColors.accentViolet,
  };
}

/// Large (or compact) budget progress ring with center remaining/spent.
class BudgetHeroRing extends StatelessWidget {
  const BudgetHeroRing({
    super.key,
    required this.summary,
    required this.currencyCode,
    this.compact = false,
  });

  final MonthFinanceSummary summary;
  final String currencyCode;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final color = _statusColor(summary.budgetStatus);
    final ratio = summary.budgetLimitMinor <= 0
        ? 0.0
        : (summary.spentMinor / summary.budgetLimitMinor).clamp(0.0, 1.0);
    final remaining = summary.remainingMinor;
    final size = compact ? 120.0 : 168.0;
    final stroke = compact ? 10.0 : 14.0;

    return GlassSurface(
      glowColor: color,
      padding: EdgeInsets.all(compact ? LumenSpacing.sm : LumenSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!compact) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.financeBudget,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleMedium,
                  ),
                ),
                BudgetStatusChip(status: summary.budgetStatus),
              ],
            ),
            const SizedBox(height: LumenSpacing.md),
          ],
          Expanded(
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: ratio,
                    color: color,
                    trackColor: LumenColors.surface,
                    strokeWidth: stroke,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              remaining == null
                                  ? '—'
                                  : MoneyFormat.formatCard(remaining),
                              style: theme.headlineMedium?.copyWith(
                                fontSize: compact ? 20 : 28,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            remaining == null
                                ? l10n.financeNoBudget
                                : l10n.financeLeft,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.labelMedium?.copyWith(
                              color: LumenColors.textMuted,
                              fontSize: compact ? 10 : 12,
                            ),
                          ),
                          if (!compact && summary.budgetLimitMinor > 0) ...[
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${MoneyFormat.formatCard(summary.spentMinor)} / ${MoneyFormat.formatCard(summary.budgetLimitMinor)} $currencyCode',
                                style: theme.labelMedium?.copyWith(
                                  color: LumenColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final arc = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        colors: [color.withValues(alpha: 0.55), color],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Interactive category donut with legend (% + amounts).
class FinanceDonutChart extends StatefulWidget {
  const FinanceDonutChart({
    super.key,
    required this.summary,
    required this.categories,
    required this.currencyCode,
    this.compact = false,
  });

  final MonthFinanceSummary summary;
  final List<FinanceCategory> categories;
  final String currencyCode;
  final bool compact;

  @override
  State<FinanceDonutChart> createState() => _FinanceDonutChartState();
}

class _FinanceDonutChartState extends State<FinanceDonutChart> {
  int? _touched;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final catMap = {for (final c in widget.categories) c.id: c};
    final entries = widget.summary.spentByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty || widget.summary.spentMinor <= 0) {
      return GlassSurface(
        padding: EdgeInsets.all(
          widget.compact ? LumenSpacing.sm : LumenSpacing.lg,
        ),
        child: Center(
          child: Text(
            l10n.financeEmptyTx,
            style: theme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < entries.take(8).length; i++) {
      final e = entries[i];
      final cat = catMap[e.key];
      final color = Color(cat?.colorArgb ?? 0xFF8B919C);
      final pct = e.value / widget.summary.spentMinor;
      final selected = _touched == i;
      sections.add(
        PieChartSectionData(
          value: e.value.toDouble(),
          color: color,
          radius: selected
              ? (widget.compact ? 26.0 : 34.0)
              : (widget.compact ? 20.0 : 28.0),
          showTitle: !widget.compact && pct >= 0.1,
          title: '${(pct * 100).round()}%',
          titleStyle: theme.labelMedium?.copyWith(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final chart = PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: widget.compact ? 36 : 52,
        sections: sections,
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response?.touchedSection == null) {
                _touched = null;
                return;
              }
              _touched = response!.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
    );

    final centerLabel = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            MoneyFormat.formatCard(widget.summary.spentMinor),
            style: theme.titleLarge?.copyWith(
              fontSize: widget.compact ? 16 : 22,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        Text(
          l10n.financeSpent,
          style: theme.labelMedium?.copyWith(
            color: LumenColors.textMuted,
            fontSize: widget.compact ? 10 : 12,
          ),
        ),
      ],
    );

    final legend = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < entries.take(widget.compact ? 4 : 5).length; i++) ...[
          _LegendRow(
            color: Color(catMap[entries[i].key]?.colorArgb ?? 0xFF8B919C),
            label: catMap[entries[i].key] == null
                ? '—'
                : categoryLabel(l10n, catMap[entries[i].key]!),
            amount: MoneyFormat.formatCompact(
              entries[i].value,
              currencyCode: widget.currencyCode,
            ),
            percent:
                '${((entries[i].value / widget.summary.spentMinor) * 100).round()}%',
            highlighted: _touched == i,
          ),
          SizedBox(height: widget.compact ? 4 : LumenSpacing.xs),
        ],
      ],
    );

    return GlassSurface(
      glowColor: LumenColors.accentViolet,
      padding: EdgeInsets.all(
        widget.compact ? LumenSpacing.sm : LumenSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.compact)
            Text(l10n.financeByCategory, style: theme.titleMedium),
          if (!widget.compact) const SizedBox(height: LumenSpacing.md),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: widget.compact ? 5 : 5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [chart, centerLabel],
                  ),
                ),
                SizedBox(width: widget.compact ? 6 : LumenSpacing.md),
                Expanded(flex: 4, child: legend),
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
    required this.percent,
    this.highlighted = false,
  });

  final Color color;
  final String label;
  final String amount;
  final String percent;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: highlighted ? 1 : 0.85,
      child: Row(
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
              style: theme.bodySmall?.copyWith(
                fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            percent,
            style: theme.labelMedium?.copyWith(color: LumenColors.textMuted),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              amount,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: theme.labelMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Smooth area line chart for daily spend (cashflow).
class FinanceCashflowChart extends StatefulWidget {
  const FinanceCashflowChart({
    super.key,
    required this.summary,
    required this.currencyCode,
    this.compact = false,
  });

  final MonthFinanceSummary summary;
  final String currencyCode;
  final bool compact;

  @override
  State<FinanceCashflowChart> createState() => _FinanceCashflowChartState();
}

class _FinanceCashflowChartState extends State<FinanceCashflowChart> {
  int? _touchedDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final daysInMonth =
        DateTime(widget.summary.year, widget.summary.month + 1, 0).day;
    final maxY = widget.summary.spentByDay.values.fold<int>(
      0,
      (a, b) => a > b ? a : b,
    );
    final chartMax = (maxY <= 0 ? 100 : maxY * 1.15).toDouble();

    final spots = <FlSpot>[
      for (var d = 1; d <= daysInMonth; d++)
        FlSpot(d.toDouble(), (widget.summary.spentByDay[d] ?? 0).toDouble()),
    ];

    return GlassSurface(
      glowColor: LumenColors.accentRed,
      padding: EdgeInsets.all(
        widget.compact ? LumenSpacing.sm : LumenSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.compact)
            Text(l10n.financeCashflow, style: theme.titleMedium)
          else
            Text(
              l10n.financeCashflow,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.labelMedium,
            ),
          SizedBox(height: widget.compact ? 6 : LumenSpacing.md),
          Expanded(
            child: maxY <= 0
                ? Center(
                    child: Text(
                      l10n.financeEmptyTx,
                      style: theme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: 1,
                      maxX: daysInMonth.toDouble(),
                      minY: 0,
                      maxY: chartMax,
                      gridData: FlGridData(
                        show: !widget.compact,
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
                            showTitles: !widget.compact,
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
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response?.lineBarSpots == null ||
                                response!.lineBarSpots!.isEmpty) {
                              _touchedDay = null;
                              return;
                            }
                            _touchedDay =
                                response.lineBarSpots!.first.x.toInt();
                          });
                        },
                        getTouchedSpotIndicator: (bar, indexes) {
                          return indexes.map((i) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color: LumenColors.accentCream
                                    .withValues(alpha: 0.45),
                                strokeWidth: 1,
                              ),
                              FlDotData(
                                show: true,
                                getDotPainter: (s, p, b, i) =>
                                    FlDotCirclePainter(
                                  radius: 4,
                                  color: LumenColors.accentCream,
                                  strokeWidth: 2,
                                  strokeColor: LumenColors.bg,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => LumenColors.surfaceRaised,
                          tooltipBorderRadius: BorderRadius.circular(12),
                          tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          getTooltipItems: (spots) {
                            return spots.map((s) {
                              final amount = MoneyFormat.formatCompact(
                                s.y.round(),
                                currencyCode: widget.currencyCode,
                              );
                              return LineTooltipItem(
                                'Day ${s.x.toInt()}\n$amount',
                                theme.labelMedium!.copyWith(
                                  color: LumenColors.text,
                                  height: 1.3,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.28,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          color: LumenColors.accentCream,
                          dotData: FlDotData(
                            show: _touchedDay != null,
                            checkToShowDot: (s, _) =>
                                s.x.toInt() == _touchedDay,
                            getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                              radius: 3.5,
                              color: LumenColors.accentCream,
                              strokeWidth: 0,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                LumenColors.accentCream.withValues(alpha: 0.35),
                                LumenColors.accentCream.withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Optional weekly bars (Insights).
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

    // Aggregate into ~4 weekly buckets.
    final weeks = <int, int>{};
    for (var d = 1; d <= daysInMonth; d++) {
      final w = ((d - 1) ~/ 7) + 1;
      weeks[w] = (weeks[w] ?? 0) + (summary.spentByDay[d] ?? 0);
    }
    final maxY = weeks.values.fold<int>(0, (a, b) => a > b ? a : b);
    final chartMax = (maxY <= 0 ? 100 : maxY * 1.2).toDouble();

    return GlassSurface(
      glowColor: LumenColors.accentViolet,
      padding: const EdgeInsets.all(LumenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.financeTrend, style: theme.titleMedium),
          const SizedBox(height: LumenSpacing.md),
          SizedBox(
            height: 140,
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
                            getTitlesWidget: (value, meta) {
                              final w = value.toInt();
                              if (!weeks.containsKey(w)) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                'W$w',
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
                        for (final e in weeks.entries)
                          BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.toDouble(),
                                width: 18,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                                gradient: LumenColors.gradDusk,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

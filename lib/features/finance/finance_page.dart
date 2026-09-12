import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/module_scaffold.dart';
import 'budget_editor_sheet.dart';
import 'category_labels.dart';
import 'finance_charts.dart';
import 'managers_sheet.dart';
import 'money_format.dart';
import 'transaction_editor_sheet.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({
    super.key,
    required this.database,
    required this.currencyCode,
  });

  final AppDatabase database;
  final String currencyCode;

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  late DateTime _month;
  String? _filterKind;
  int? _filterCategoryId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
    });
  }

  String _monthTitle(AppLocalizations l10n) {
    final names = [
      l10n.monthJan,
      l10n.monthFeb,
      l10n.monthMar,
      l10n.monthApr,
      l10n.monthMay,
      l10n.monthJun,
      l10n.monthJul,
      l10n.monthAug,
      l10n.monthSep,
      l10n.monthOct,
      l10n.monthNov,
      l10n.monthDec,
    ];
    return '${names[_month.month - 1]} ${_month.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final db = widget.database;
    final currency = widget.currencyCode;

    return StreamBuilder<MonthFinanceSummary>(
      stream: db.watchMonthSummary(_month.year, _month.month),
      builder: (context, summarySnap) {
        final summary = summarySnap.data ??
            MonthFinanceSummary(
              year: _month.year,
              month: _month.month,
              spentMinor: 0,
              incomeMinor: 0,
              budgetLimitMinor: 0,
              remainingMinor: null,
              spentByCategory: const {},
              spentByDay: const {},
              allocationByCategory: const {},
              transactionCount: 0,
            );

        return StreamBuilder<List<FinanceCategory>>(
          stream: db.watchCategories(),
          builder: (context, catSnap) {
            final categories = catSnap.data ?? const [];

            return StreamBuilder<List<TxWithMeta>>(
              stream: db.watchMonthTransactions(
                _month.year,
                _month.month,
                kind: _filterKind,
                categoryId: _filterCategoryId,
              ),
              builder: (context, txSnap) {
                final txs = txSnap.data ?? const [];

                return StreamBuilder<List<FinanceAccount>>(
                  stream: db.watchAccounts(),
                  builder: (context, accSnap) {
                    final accounts = accSnap.data ?? const [];

                    return ModuleScaffold(
                      title: l10n.navFinance,
                      subtitle: l10n.financeSubtitle,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l10n.financeManageCategories,
                            onPressed: () => showCategoryManagerSheet(
                              context: context,
                              database: db,
                            ),
                            icon: const Icon(
                              PhosphorIconsRegular.tag,
                              color: LumenColors.accentViolet,
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.financeManageAccounts,
                            onPressed: () => showAccountManagerSheet(
                              context: context,
                              database: db,
                              currencyCode: currency,
                            ),
                            icon: const Icon(
                              PhosphorIconsRegular.wallet,
                              color: LumenColors.accentBlue,
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.financeAddTx,
                            onPressed: () => showTransactionEditorSheet(
                              context: context,
                              database: db,
                              currencyCode: currency,
                              initialDate: _month,
                            ),
                            icon: const Icon(
                              PhosphorIconsRegular.plusCircle,
                              color: LumenColors.accentMint,
                            ),
                          ),
                        ],
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: _MonthSwitcher(
                              title: _monthTitle(l10n),
                              onPrev: () => _shiftMonth(-1),
                              onNext: () => _shiftMonth(1),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: LumenSpacing.md),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GradientMetricCard(
                                    label: l10n.financeSpent,
                                    value: MoneyFormat.formatCompact(
                                      summary.spentMinor,
                                    ),
                                    suffix: currency,
                                    gradient: LumenColors.gradEmber,
                                  ),
                                ),
                                const SizedBox(width: LumenSpacing.sm),
                                Expanded(
                                  child: GradientMetricCard(
                                    label: l10n.financeRemaining,
                                    value: summary.remainingMinor == null
                                        ? '—'
                                        : MoneyFormat.formatCompact(
                                            summary.remainingMinor!,
                                          ),
                                    suffix: summary.remainingMinor == null
                                        ? null
                                        : currency,
                                    gradient: LumenColors.gradDusk,
                                    onTap: () => showBudgetEditorSheet(
                                      context: context,
                                      database: db,
                                      currencyCode: currency,
                                      year: _month.year,
                                      month: _month.month,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.sm),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _MiniMetric(
                                    label: l10n.financeBudget,
                                    value: summary.budgetLimitMinor <= 0
                                        ? l10n.financeNoBudget
                                        : MoneyFormat.formatCompact(
                                            summary.budgetLimitMinor,
                                            currencyCode: currency,
                                          ),
                                    onTap: () => showBudgetEditorSheet(
                                      context: context,
                                      database: db,
                                      currencyCode: currency,
                                      year: _month.year,
                                      month: _month.month,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: LumenSpacing.sm),
                                Expanded(
                                  child: _MiniMetric(
                                    label: l10n.financeIncome,
                                    value: MoneyFormat.formatCompact(
                                      summary.incomeMinor,
                                      currencyCode: currency,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.md),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: Row(
                              children: [
                                BudgetStatusChip(status: summary.budgetStatus),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => showBudgetEditorSheet(
                                    context: context,
                                    database: db,
                                    currencyCode: currency,
                                    year: _month.year,
                                    month: _month.month,
                                  ),
                                  child: Text(
                                    summary.budgetLimitMinor <= 0
                                        ? l10n.financeSetBudget
                                        : l10n.financeEditBudget,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (accounts.isNotEmpty) ...[
                          const ContainedSliver(
                            child: SizedBox(height: LumenSpacing.sm),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 72,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: LumenSpacing.pagePadding,
                                ),
                                itemCount: accounts.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: LumenSpacing.sm),
                                itemBuilder: (context, i) {
                                  final acc = accounts[i];
                                  return GlowCard(
                                    violetEdge: true,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: LumenSpacing.md,
                                      vertical: LumenSpacing.sm,
                                    ),
                                    child: SizedBox(
                                      width: 160,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            acc.name,
                                            style: theme.labelMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            MoneyFormat.formatCompact(
                                              acc.balanceMinor,
                                              currencyCode: acc.currencyCode,
                                            ),
                                            style: theme.titleMedium?.copyWith(
                                              fontFeatures: const [
                                                FontFeature.tabularFigures(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                        if (summary.allocationByCategory.isNotEmpty) ...[
                          const ContainedSliver(
                            child: SizedBox(height: LumenSpacing.lg),
                          ),
                          ContainedSliver(
                            child: Text(
                              l10n.financeAllocations,
                              style: theme.titleLarge,
                            ),
                          ),
                          const ContainedSliver(
                            child: SizedBox(height: LumenSpacing.sm),
                          ),
                          for (final entry
                              in summary.allocationByCategory.entries) ...[
                            SliverToBoxAdapter(
                              child: _AllocationRow(
                                category: categories
                                    .where((c) => c.id == entry.key)
                                    .firstOrNull,
                                allocated: entry.value,
                                spent:
                                    summary.spentByCategory[entry.key] ?? 0,
                                currencyCode: currency,
                              ),
                            ),
                          ],
                        ],
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.xl),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: FinanceDonutChart(
                              summary: summary,
                              categories: categories,
                              currencyCode: currency,
                            ),
                          ),
                        ),
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.md),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: FinanceBarChart(
                              summary: summary,
                              currencyCode: currency,
                            ),
                          ),
                        ),
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.xl),
                        ),
                        ContainedSliver(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.financeTransactions,
                                  style: theme.titleLarge,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => showTransactionEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  initialDate: DateTime.now(),
                                ),
                                icon: const Icon(
                                  PhosphorIconsRegular.plus,
                                  size: 16,
                                ),
                                label: Text(l10n.financeAddTx),
                              ),
                            ],
                          ),
                        ),
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.sm),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: LumenSpacing.pagePadding,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _FilterChip(
                                    label: l10n.financeFilterAll,
                                    selected: _filterKind == null &&
                                        _filterCategoryId == null,
                                    onTap: () => setState(() {
                                      _filterKind = null;
                                      _filterCategoryId = null;
                                    }),
                                  ),
                                  const SizedBox(width: LumenSpacing.xs),
                                  _FilterChip(
                                    label: l10n.financeTypeExpense,
                                    selected: _filterKind == 'expense',
                                    onTap: () => setState(() {
                                      _filterKind = 'expense';
                                      _filterCategoryId = null;
                                    }),
                                  ),
                                  const SizedBox(width: LumenSpacing.xs),
                                  _FilterChip(
                                    label: l10n.financeTypeIncome,
                                    selected: _filterKind == 'income',
                                    onTap: () => setState(() {
                                      _filterKind = 'income';
                                      _filterCategoryId = null;
                                    }),
                                  ),
                                  for (final cat in categories
                                      .where((c) => c.kind == 'expense')
                                      .take(6)) ...[
                                    const SizedBox(width: LumenSpacing.xs),
                                    _FilterChip(
                                      label: categoryLabel(l10n, cat),
                                      selected: _filterCategoryId == cat.id,
                                      color: Color(cat.colorArgb),
                                      onTap: () => setState(() {
                                        _filterCategoryId = cat.id;
                                        _filterKind = null;
                                      }),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const ContainedSliver(
                          child: SizedBox(height: LumenSpacing.sm),
                        ),
                        if (txs.isEmpty)
                          ContainedSliver(
                            child: Text(
                              l10n.financeEmptyTx,
                              style: theme.bodySmall,
                            ),
                          )
                        else
                          for (final item in txs)
                            SliverToBoxAdapter(
                              child: TransactionRow(
                                title: item.tx.note.trim().isNotEmpty
                                    ? item.tx.note.trim()
                                    : categoryLabel(l10n, item.category),
                                subtitle:
                                    '${categoryLabel(l10n, item.category)} · ${item.account.name} · ${item.tx.occurredAt.day}.${item.tx.occurredAt.month}',
                                amountLabel: MoneyFormat.formatSigned(
                                  item.tx.amountMinor,
                                  isExpense: item.tx.kind == 'expense',
                                  currencyCode: currency,
                                ),
                                isExpense: item.tx.kind == 'expense',
                                onTap: () => showTransactionEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  existing: item,
                                ),
                              ),
                            ),
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

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({
    required this.title,
    required this.onPrev,
    required this.onNext,
  });

  final String title;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.xs,
        vertical: LumenSpacing.xxs,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrev,
            icon: const Icon(PhosphorIconsRegular.caretLeft),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(PhosphorIconsRegular.caretRight),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return GlowCard(
      onTap: onTap,
      padding: const EdgeInsets.all(LumenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.labelMedium),
          const SizedBox(height: LumenSpacing.xxs),
          Text(
            value,
            style: theme.titleLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? LumenColors.accentViolet;
    return Material(
      color: selected
          ? accent.withValues(alpha: 0.28)
          : LumenColors.surfaceRaised,
      borderRadius: LumenRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.sm,
            vertical: LumenSpacing.xs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? LumenColors.text : LumenColors.textMuted,
                ),
          ),
        ),
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({
    required this.category,
    required this.allocated,
    required this.spent,
    required this.currencyCode,
  });

  final FinanceCategory? category;
  final int allocated;
  final int spent;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final label = category == null ? '—' : categoryLabel(l10n, category!);
    final color = Color(category?.colorArgb ?? 0xFF8B919C);
    final ratio = allocated <= 0 ? 0.0 : (spent / allocated).clamp(0.0, 1.5);
    final delta = allocated - spent;
    final vsPlan = delta < 0
        ? l10n.financeOverBy(
            MoneyFormat.formatCompact(-delta, currencyCode: currencyCode),
          )
        : l10n.financeUnderBy(
            MoneyFormat.formatCompact(delta, currencyCode: currencyCode),
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        0,
        LumenSpacing.pagePadding,
        LumenSpacing.sm,
      ),
      child: GlowCard(
        padding: const EdgeInsets.all(LumenSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: LumenSpacing.xs),
                Expanded(child: Text(label, style: theme.titleMedium)),
                Text(
                  '${MoneyFormat.formatCompact(spent)} / ${MoneyFormat.formatCompact(allocated, currencyCode: currencyCode)}',
                  style: theme.labelMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: LumenSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio > 1 ? 1 : ratio,
                minHeight: 6,
                backgroundColor: LumenColors.surface,
                color: ratio > 1
                    ? LumenColors.accentRed
                    : ratio > 0.85
                        ? LumenColors.accentCream
                        : color,
              ),
            ),
            const SizedBox(height: LumenSpacing.xxs),
            Text(
              vsPlan,
              style: theme.bodySmall?.copyWith(
                color: delta < 0
                    ? LumenColors.accentRed
                    : LumenColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

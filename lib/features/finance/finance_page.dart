import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
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

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late DateTime _month;
  late TabController _tabs;
  String? _filterKind;
  int? _filterCategoryId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _tabs = TabController(length: 4, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
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

  Future<void> _equalSplit(MonthFinanceSummary summary) async {
    final cats = await widget.database.getCategories(kind: 'expense');
    if (cats.isEmpty || summary.budgetLimitMinor <= 0) return;
    final each = summary.budgetLimitMinor ~/ cats.length;
    var remainder = summary.budgetLimitMinor - each * cats.length;
    for (final cat in cats) {
      final extra = remainder > 0 ? 1 : 0;
      if (remainder > 0) remainder--;
      await widget.database.upsertCategoryAllocation(
        year: _month.year,
        month: _month.month,
        categoryId: cat.id,
        allocatedMinor: each + extra,
      );
    }
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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            LumenSpacing.pagePadding,
                            LumenSpacing.lg,
                            LumenSpacing.pagePadding,
                            LumenSpacing.sm,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.navFinance,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.headlineLarge,
                                    ),
                                    const SizedBox(height: LumenSpacing.xs),
                                    Text(
                                      l10n.financeSubtitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.bodyMedium?.copyWith(
                                        color: LumenColors.textMuted,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                  initialDate: DateTime.now(),
                                ),
                                icon: const Icon(
                                  PhosphorIconsRegular.plusCircle,
                                  color: LumenColors.accentMint,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: LumenSpacing.pagePadding,
                          ),
                          child: _PillTabs(
                            controller: _tabs,
                            labels: [
                              l10n.financeTabOverview,
                              l10n.financeTabPlan,
                              l10n.financeTabInsights,
                              l10n.financeTabLedger,
                            ],
                          ),
                        ),
                        const SizedBox(height: LumenSpacing.sm),
                        Expanded(
                          child: TabBarView(
                            controller: _tabs,
                            children: [
                              _OverviewTab(
                                summary: summary,
                                accounts: accounts,
                                currency: currency,
                                monthTitle: _monthTitle(l10n),
                                onPrev: () => _shiftMonth(-1),
                                onNext: () => _shiftMonth(1),
                                onEditBudget: () => showBudgetEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  year: _month.year,
                                  month: _month.month,
                                ),
                                onAddTx: () => showTransactionEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  initialDate: DateTime.now(),
                                ),
                              ),
                              _PlanTab(
                                summary: summary,
                                categories: categories,
                                currency: currency,
                                onEditBudget: () => showBudgetEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  year: _month.year,
                                  month: _month.month,
                                ),
                                onEqualSplit: () => _equalSplit(summary),
                                onManageCategories: () =>
                                    showCategoryManagerSheet(
                                  context: context,
                                  database: db,
                                ),
                              ),
                              _InsightsTab(
                                summary: summary,
                                categories: categories,
                                currency: currency,
                              ),
                              _LedgerTab(
                                txs: txs,
                                categories: categories,
                                currency: currency,
                                filterKind: _filterKind,
                                filterCategoryId: _filterCategoryId,
                                onFilter: (kind, catId) => setState(() {
                                  _filterKind = kind;
                                  _filterCategoryId = catId;
                                }),
                                onAddTx: () => showTransactionEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  initialDate: DateTime.now(),
                                ),
                                onOpenTx: (item) => showTransactionEditorSheet(
                                  context: context,
                                  database: db,
                                  currencyCode: currency,
                                  existing: item,
                                ),
                              ),
                            ],
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

class _PillTabs extends StatelessWidget {
  const _PillTabs({required this.controller, required this.labels});

  final TabController controller;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => controller.animateTo(i),
                child: AnimatedContainer(
                  duration: LumenMotion.fast,
                  curve: LumenMotion.spring,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: LumenRadii.pill,
                    color: controller.index == i
                        ? LumenColors.accentViolet.withValues(alpha: 0.28)
                        : Colors.transparent,
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: controller.index == i
                              ? LumenColors.text
                              : LumenColors.textMuted,
                          fontWeight: controller.index == i
                              ? FontWeight.w600
                              : FontWeight.w500,
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.summary,
    required this.accounts,
    required this.currency,
    required this.monthTitle,
    required this.onPrev,
    required this.onNext,
    required this.onEditBudget,
    required this.onAddTx,
  });

  final MonthFinanceSummary summary;
  final List<FinanceAccount> accounts;
  final String currency;
  final String monthTitle;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onEditBudget;
  final VoidCallback onAddTx;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final net = summary.incomeMinor - summary.spentMinor;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        LumenSpacing.sm,
        LumenSpacing.pagePadding,
        120,
      ),
      children: [
        _MonthSwitcher(title: monthTitle, onPrev: onPrev, onNext: onNext),
        const SizedBox(height: LumenSpacing.md),
        SizedBox(
          height: 204,
          child: BudgetHeroRing(
            summary: summary,
            currencyCode: currency,
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        Row(
          children: [
            Expanded(
              child: GradientMetricCard(
                label: l10n.financeSpent,
                value: MoneyFormat.formatCard(summary.spentMinor),
                suffix: currency,
                gradient: LumenColors.gradEmber,
                compact: true,
              ),
            ),
            const SizedBox(width: LumenSpacing.sm),
            Expanded(
              child: GradientMetricCard(
                label: l10n.financeRemaining,
                value: summary.remainingMinor == null
                    ? '—'
                    : MoneyFormat.formatCard(summary.remainingMinor!),
                suffix: summary.remainingMinor == null ? null : currency,
                gradient: LumenColors.gradDusk,
                compact: true,
                onTap: onEditBudget,
              ),
            ),
          ],
        ),
        const SizedBox(height: LumenSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _MiniMetric(
                label: l10n.financeIncome,
                value: MoneyFormat.formatCompact(
                  summary.incomeMinor,
                  currencyCode: currency,
                ),
              ),
            ),
            const SizedBox(width: LumenSpacing.sm),
            Expanded(
              child: _MiniMetric(
                label: l10n.financeBudget,
                value: summary.budgetLimitMinor <= 0
                    ? l10n.financeNoBudget
                    : MoneyFormat.formatCompact(
                        summary.budgetLimitMinor,
                        currencyCode: currency,
                      ),
                onTap: onEditBudget,
              ),
            ),
            const SizedBox(width: LumenSpacing.sm),
            Expanded(
              child: _MiniMetric(
                label: l10n.financeNet,
                value: MoneyFormat.formatSigned(
                  net.abs(),
                  isExpense: net < 0,
                  currencyCode: currency,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: LumenSpacing.md),
        Row(
          children: [
            BudgetStatusChip(status: summary.budgetStatus),
            const Spacer(),
            TextButton(onPressed: onEditBudget, child: Text(
              summary.budgetLimitMinor <= 0
                  ? l10n.financeSetBudget
                  : l10n.financeEditBudget,
            )),
            IconButton(
              onPressed: onAddTx,
              icon: const Icon(
                PhosphorIconsRegular.plusCircle,
                color: LumenColors.accentMint,
              ),
            ),
          ],
        ),
        if (accounts.isNotEmpty) ...[
          const SizedBox(height: LumenSpacing.md),
          Text(l10n.financeAccounts, style: theme.titleMedium),
          const SizedBox(height: LumenSpacing.sm),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
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
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          acc.name,
                          style: theme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab({
    required this.summary,
    required this.categories,
    required this.currency,
    required this.onEditBudget,
    required this.onEqualSplit,
    required this.onManageCategories,
  });

  final MonthFinanceSummary summary;
  final List<FinanceCategory> categories;
  final String currency;
  final VoidCallback onEditBudget;
  final VoidCallback onEqualSplit;
  final VoidCallback onManageCategories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final entries = summary.allocationByCategory.entries.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        LumenSpacing.sm,
        LumenSpacing.pagePadding,
        120,
      ),
      children: [
        GlowCard(
          onTap: onEditBudget,
          padding: const EdgeInsets.all(LumenSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.financeBudgetTotal,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.labelMedium?.copyWith(
                        color: LumenColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        summary.budgetLimitMinor <= 0
                            ? l10n.financeNoBudget
                            : MoneyFormat.formatCompact(
                                summary.budgetLimitMinor,
                                currencyCode: currency,
                              ),
                        style: theme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                PhosphorIconsRegular.pencilSimple,
                color: LumenColors.accentViolet,
              ),
            ],
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.financeAllocations,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: onEqualSplit,
              child: Text(l10n.financeEqualSplit),
            ),
          ],
        ),
        const SizedBox(height: LumenSpacing.sm),
        if (entries.isEmpty)
          Text(
            l10n.financeAllocationsHint,
            style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
          )
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: LumenSpacing.sm),
              child: _AllocationRow(
                category:
                    categories.where((c) => c.id == entry.key).firstOrNull,
                allocated: entry.value,
                spent: summary.spentByCategory[entry.key] ?? 0,
                currencyCode: currency,
              ),
            ),
        const SizedBox(height: LumenSpacing.md),
        TextButton.icon(
          onPressed: onManageCategories,
          icon: const Icon(PhosphorIconsRegular.tag, size: 16),
          label: Text(l10n.financeManageCategories),
        ),
      ],
    );
  }
}

class _InsightsTab extends StatelessWidget {
  const _InsightsTab({
    required this.summary,
    required this.categories,
    required this.currency,
  });

  final MonthFinanceSummary summary;
  final List<FinanceCategory> categories;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        LumenSpacing.pagePadding,
        LumenSpacing.sm,
        LumenSpacing.pagePadding,
        120,
      ),
      children: [
        SizedBox(
          height: 220,
          child: FinanceDonutChart(
            summary: summary,
            categories: categories,
            currencyCode: currency,
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        SizedBox(
          height: 205,
          child: FinanceCashflowChart(
            summary: summary,
            currencyCode: currency,
          ),
        ),
        const SizedBox(height: LumenSpacing.md),
        FinanceBarChart(summary: summary, currencyCode: currency),
      ],
    );
  }
}

class _LedgerTab extends StatelessWidget {
  const _LedgerTab({
    required this.txs,
    required this.categories,
    required this.currency,
    required this.filterKind,
    required this.filterCategoryId,
    required this.onFilter,
    required this.onAddTx,
    required this.onOpenTx,
  });

  final List<TxWithMeta> txs;
  final List<FinanceCategory> categories;
  final String currency;
  final String? filterKind;
  final int? filterCategoryId;
  final void Function(String? kind, int? categoryId) onFilter;
  final VoidCallback onAddTx;
  final ValueChanged<TxWithMeta> onOpenTx;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        LumenSpacing.sm,
        0,
        120,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.pagePadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.financeTransactions,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleLarge,
                ),
              ),
              TextButton.icon(
                onPressed: onAddTx,
                icon: const Icon(PhosphorIconsRegular.plus, size: 16),
                label: Text(l10n.financeAddTx),
              ),
            ],
          ),
        ),
        const SizedBox(height: LumenSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.pagePadding,
          ),
          child: Row(
            children: [
              _FilterChip(
                label: l10n.financeFilterAll,
                selected: filterKind == null && filterCategoryId == null,
                onTap: () => onFilter(null, null),
              ),
              const SizedBox(width: LumenSpacing.xs),
              _FilterChip(
                label: l10n.financeTypeExpense,
                selected: filterKind == 'expense',
                onTap: () => onFilter('expense', null),
              ),
              const SizedBox(width: LumenSpacing.xs),
              _FilterChip(
                label: l10n.financeTypeIncome,
                selected: filterKind == 'income',
                onTap: () => onFilter('income', null),
              ),
              for (final cat
                  in categories.where((c) => c.kind == 'expense').take(6)) ...[
                const SizedBox(width: LumenSpacing.xs),
                _FilterChip(
                  label: categoryLabel(l10n, cat),
                  selected: filterCategoryId == cat.id,
                  color: Color(cat.colorArgb),
                  onTap: () => onFilter(null, cat.id),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: LumenSpacing.sm),
        if (txs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: LumenSpacing.pagePadding,
            ),
            child: Text(l10n.financeEmptyTx, style: theme.bodySmall),
          )
        else
          for (final item in txs)
            TransactionRow(
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
              onTap: () => onOpenTx(item),
            ),
      ],
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.labelMedium,
          ),
          const SizedBox(height: LumenSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.titleMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

    return GlowCard(
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
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleMedium,
                ),
              ),
              Flexible(
                child: Text(
                  '${MoneyFormat.formatCard(spent)} / ${MoneyFormat.formatCard(allocated)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: theme.labelMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.bodySmall?.copyWith(
              color: delta < 0
                  ? LumenColors.accentRed
                  : LumenColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

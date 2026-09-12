import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'category_labels.dart';
import 'money_format.dart';

Future<void> showBudgetEditorSheet({
  required BuildContext context,
  required AppDatabase database,
  required String currencyCode,
  required int year,
  required int month,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BudgetEditorSheet(
        database: database,
        currencyCode: currencyCode,
        year: year,
        month: month,
      );
    },
  );
}

class BudgetEditorSheet extends StatefulWidget {
  const BudgetEditorSheet({
    super.key,
    required this.database,
    required this.currencyCode,
    required this.year,
    required this.month,
  });

  final AppDatabase database;
  final String currencyCode;
  final int year;
  final int month;

  @override
  State<BudgetEditorSheet> createState() => _BudgetEditorSheetState();
}

class _BudgetEditorSheetState extends State<BudgetEditorSheet> {
  late final TextEditingController _total;
  final Map<int, TextEditingController> _allocControllers = {};
  List<FinanceCategory> _expenseCats = const [];
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _total = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final budget =
        await widget.database.getMonthlyBudget(widget.year, widget.month);
    final allocs =
        await widget.database.getAllocations(widget.year, widget.month);
    final cats =
        await widget.database.getCategories(kind: 'expense');
    if (!mounted) return;
    setState(() {
      _expenseCats = cats;
      if (budget != null && budget.totalLimitMinor > 0) {
        _total.text = (budget.totalLimitMinor / 100).toStringAsFixed(2);
      }
      for (final cat in cats) {
        final a = allocs.where((x) => x.categoryId == cat.id).firstOrNull;
        _allocControllers[cat.id] = TextEditingController(
          text: a == null || a.allocatedMinor <= 0
              ? ''
              : (a.allocatedMinor / 100).toStringAsFixed(2),
        );
      }
    });
  }

  @override
  void dispose() {
    _total.dispose();
    for (final c in _allocControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final total = MoneyFormat.parseToMinor(_total.text);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.database.upsertMonthlyBudget(
        year: widget.year,
        month: widget.month,
        totalLimitMinor: total,
      );
      for (final entry in _allocControllers.entries) {
        await widget.database.upsertCategoryAllocation(
          year: widget.year,
          month: widget.month,
          categoryId: entry.key,
          allocatedMinor: MoneyFormat.parseToMinor(entry.value.text),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.financeSaveError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: GlassSurface(
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
              Text(l10n.financeEditBudget, style: theme.titleLarge),
              const SizedBox(height: LumenSpacing.xs),
              Text(
                l10n.financeBudgetHint,
                style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
              ),
              const SizedBox(height: LumenSpacing.lg),
              TextField(
                controller: _total,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: theme.headlineSmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                decoration: InputDecoration(
                  labelText: l10n.financeBudgetTotal,
                  suffixText: widget.currencyCode,
                ),
              ),
              const SizedBox(height: LumenSpacing.xl),
              Text(l10n.financeAllocations, style: theme.titleMedium),
              const SizedBox(height: LumenSpacing.xxs),
              Text(
                l10n.financeAllocationsHint,
                style: theme.bodySmall?.copyWith(color: LumenColors.textMuted),
              ),
              const SizedBox(height: LumenSpacing.md),
              for (final cat in _expenseCats) ...[
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(cat.colorArgb),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: LumenSpacing.sm),
                    Expanded(
                      child: Text(
                        categoryLabel(l10n, cat),
                        style: theme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _allocControllers[cat.id],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.end,
                        style: theme.titleMedium?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '0',
                          suffixText: widget.currencyCode,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LumenSpacing.sm),
              ],
              if (_error != null) ...[
                Text(
                  _error!,
                  style: theme.bodySmall?.copyWith(color: LumenColors.accentRed),
                ),
                const SizedBox(height: LumenSpacing.sm),
              ],
              const SizedBox(height: LumenSpacing.md),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: LumenColors.accentCream,
                  foregroundColor: LumenColors.bg,
                  padding: const EdgeInsets.symmetric(vertical: LumenSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: LumenRadii.pill,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(PhosphorIconsRegular.check, size: 18),
                    const SizedBox(width: LumenSpacing.xs),
                    Text(
                      l10n.financeSave,
                      style: theme.titleMedium?.copyWith(color: LumenColors.bg),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

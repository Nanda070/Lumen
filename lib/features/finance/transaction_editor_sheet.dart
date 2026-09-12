import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../calendar/calendar_date_utils.dart';
import 'category_labels.dart';
import 'money_format.dart';

Future<void> showTransactionEditorSheet({
  required BuildContext context,
  required AppDatabase database,
  required String currencyCode,
  TxWithMeta? existing,
  DateTime? initialDate,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return TransactionEditorSheet(
        database: database,
        currencyCode: currencyCode,
        existing: existing,
        initialDate: initialDate,
      );
    },
  );
}

class TransactionEditorSheet extends StatefulWidget {
  const TransactionEditorSheet({
    super.key,
    required this.database,
    required this.currencyCode,
    this.existing,
    this.initialDate,
  });

  final AppDatabase database;
  final String currencyCode;
  final TxWithMeta? existing;
  final DateTime? initialDate;

  @override
  State<TransactionEditorSheet> createState() => _TransactionEditorSheetState();
}

class _TransactionEditorSheetState extends State<TransactionEditorSheet> {
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late DateTime _day;
  late String _kind;
  List<FinanceCategory> _categories = const [];
  List<FinanceAccount> _accounts = const [];
  int? _categoryId;
  int? _accountId;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _amount = TextEditingController(
        text: (existing.tx.amountMinor / 100).toStringAsFixed(2),
      );
      _note = TextEditingController(text: existing.tx.note);
      _day = CalendarDateUtils.dateOnly(existing.tx.occurredAt);
      _kind = existing.tx.kind;
      _categoryId = existing.tx.categoryId;
      _accountId = existing.tx.accountId;
    } else {
      _amount = TextEditingController();
      _note = TextEditingController();
      _day = CalendarDateUtils.dateOnly(widget.initialDate ?? DateTime.now());
      _kind = 'expense';
    }
    _load();
  }

  Future<void> _load() async {
    final cats = await widget.database.getCategories();
    final accounts = await widget.database.getAccounts();
    if (!mounted) return;
    setState(() {
      _categories = cats;
      _accounts = accounts;
      _accountId ??= accounts.isNotEmpty ? accounts.first.id : null;
      _syncCategoryForKind();
    });
  }

  void _syncCategoryForKind() {
    final filtered = _categories.where((c) => c.kind == _kind).toList();
    if (filtered.isEmpty) {
      _categoryId = null;
      return;
    }
    if (_categoryId == null ||
        !filtered.any((c) => c.id == _categoryId)) {
      _categoryId = filtered.first.id;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: LumenColors.accentViolet,
              surface: LumenColors.surfaceRaised,
              onSurface: LumenColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _day = CalendarDateUtils.dateOnly(picked));
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final minor = MoneyFormat.parseToMinor(_amount.text);
    if (minor <= 0) {
      setState(() => _error = l10n.financeAmountRequired);
      return;
    }
    if (_categoryId == null || _accountId == null) {
      setState(() => _error = l10n.financeSaveError);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final occurredAt = DateTime(
        _day.year,
        _day.month,
        _day.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );
      if (_isEdit) {
        await widget.database.updateTransaction(
          id: widget.existing!.tx.id,
          amountMinor: minor,
          kind: _kind,
          categoryId: _categoryId!,
          accountId: _accountId!,
          occurredAt: occurredAt,
          note: _note.text,
        );
      } else {
        await widget.database.insertTransaction(
          amountMinor: minor,
          kind: _kind,
          categoryId: _categoryId!,
          accountId: _accountId!,
          occurredAt: occurredAt,
          note: _note.text,
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

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LumenColors.surfaceRaised,
          title: Text(l10n.financeDeleteTxTitle),
          content: Text(l10n.financeDeleteTxBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.financeCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.financeDelete,
                style: const TextStyle(color: LumenColors.accentRed),
              ),
            ),
          ],
        );
      },
    );
    if (confirm != true || !mounted) return;
    await widget.database.deleteTransaction(widget.existing!.tx.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final filtered = _categories.where((c) => c.kind == _kind).toList();

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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEdit ? l10n.financeEditTx : l10n.financeNewTx,
                      style: theme.titleLarge,
                    ),
                  ),
                  if (_isEdit)
                    IconButton(
                      onPressed: _saving ? null : _delete,
                      icon: const Icon(
                        PhosphorIconsRegular.trash,
                        color: LumenColors.accentRed,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _KindChip(
                      label: l10n.financeTypeExpense,
                      selected: _kind == 'expense',
                      onTap: () => setState(() {
                        _kind = 'expense';
                        _syncCategoryForKind();
                      }),
                    ),
                  ),
                  const SizedBox(width: LumenSpacing.xs),
                  Expanded(
                    child: _KindChip(
                      label: l10n.financeTypeIncome,
                      selected: _kind == 'income',
                      onTap: () => setState(() {
                        _kind = 'income';
                        _syncCategoryForKind();
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              TextField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: theme.displaySmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                decoration: InputDecoration(
                  labelText: l10n.financeAmount,
                  suffixText: widget.currencyCode,
                ),
              ),
              const SizedBox(height: LumenSpacing.md),
              Text(l10n.financeCategory, style: theme.labelMedium),
              const SizedBox(height: LumenSpacing.xs),
              Wrap(
                spacing: LumenSpacing.xs,
                runSpacing: LumenSpacing.xs,
                children: [
                  for (final cat in filtered)
                    ChoiceChip(
                      label: Text(categoryLabel(l10n, cat)),
                      selected: _categoryId == cat.id,
                      selectedColor: Color(cat.colorArgb).withValues(alpha: 0.35),
                      onSelected: (_) => setState(() => _categoryId = cat.id),
                      backgroundColor: LumenColors.surfaceRaised,
                      labelStyle: theme.labelMedium?.copyWith(
                        color: _categoryId == cat.id
                            ? LumenColors.text
                            : LumenColors.textMuted,
                      ),
                      side: BorderSide(
                        color: _categoryId == cat.id
                            ? Color(cat.colorArgb)
                            : LumenColors.glassStroke,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              Text(l10n.financeAccount, style: theme.labelMedium),
              const SizedBox(height: LumenSpacing.xs),
              Wrap(
                spacing: LumenSpacing.xs,
                children: [
                  for (final acc in _accounts)
                    ChoiceChip(
                      label: Text(acc.name),
                      selected: _accountId == acc.id,
                      onSelected: (_) => setState(() => _accountId = acc.id),
                      backgroundColor: LumenColors.surfaceRaised,
                      selectedColor:
                          LumenColors.accentViolet.withValues(alpha: 0.3),
                      labelStyle: theme.labelMedium,
                      side: BorderSide(
                        color: _accountId == acc.id
                            ? LumenColors.accentViolet
                            : LumenColors.glassStroke,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: LumenSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.financeDate, style: theme.labelMedium),
                subtitle: Text(
                  '${_day.day}.${_day.month}.${_day.year}',
                  style: theme.titleMedium,
                ),
                trailing: const Icon(
                  PhosphorIconsRegular.calendarBlank,
                  color: LumenColors.accentViolet,
                ),
                onTap: _pickDay,
              ),
              TextField(
                controller: _note,
                decoration: InputDecoration(
                  labelText: l10n.financeNote,
                  hintText: l10n.financeNoteHint,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: LumenSpacing.sm),
                Text(
                  _error!,
                  style: theme.bodySmall?.copyWith(color: LumenColors.accentRed),
                ),
              ],
              const SizedBox(height: LumenSpacing.lg),
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
                child: Text(
                  _isEdit ? l10n.financeSave : l10n.financeAddTx,
                  style: theme.titleMedium?.copyWith(color: LumenColors.bg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? LumenColors.accentViolet.withValues(alpha: 0.28)
          : LumenColors.surfaceRaised,
      borderRadius: LumenRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: LumenRadii.pill,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: LumenSpacing.sm),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: LumenRadii.pill,
            border: Border.all(
              color: selected
                  ? LumenColors.accentViolet
                  : LumenColors.glassStroke,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: selected ? LumenColors.text : LumenColors.textMuted,
                ),
          ),
        ),
      ),
    );
  }
}

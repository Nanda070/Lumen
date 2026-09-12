import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/app_database.dart';
import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'category_labels.dart';
import 'money_format.dart';

Future<void> showCategoryManagerSheet({
  required BuildContext context,
  required AppDatabase database,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CategoryManagerSheet(database: database),
  );
}

class CategoryManagerSheet extends StatelessWidget {
  const CategoryManagerSheet({super.key, required this.database});

  final AppDatabase database;

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
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    child: Text(l10n.financeCategories, style: theme.titleLarge),
                  ),
                  IconButton(
                    onPressed: () => _editCategory(context, null),
                    icon: const Icon(
                      PhosphorIconsRegular.plusCircle,
                      color: LumenColors.accentMint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LumenSpacing.sm),
              Expanded(
                child: StreamBuilder<List<FinanceCategory>>(
                  stream: database.watchCategories(),
                  builder: (context, snapshot) {
                    final cats = snapshot.data ?? const [];
                    if (cats.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.separated(
                      itemCount: cats.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: LumenSpacing.xs),
                      itemBuilder: (context, i) {
                        final cat = cats[i];
                        return GlowCard(
                          onTap: () => _editCategory(context, cat),
                          padding: const EdgeInsets.symmetric(
                            horizontal: LumenSpacing.md,
                            vertical: LumenSpacing.md,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(cat.colorArgb),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: LumenSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryLabel(l10n, cat),
                                      style: theme.titleMedium,
                                    ),
                                    Text(
                                      cat.kind == 'expense'
                                          ? l10n.financeTypeExpense
                                          : l10n.financeTypeIncome,
                                      style: theme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                PhosphorIconsRegular.caretRight,
                                color: LumenColors.textMuted,
                                size: 16,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editCategory(
    BuildContext context,
    FinanceCategory? existing,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryEditor(
        database: database,
        existing: existing,
      ),
    );
  }
}

class _CategoryEditor extends StatefulWidget {
  const _CategoryEditor({required this.database, this.existing});

  final AppDatabase database;
  final FinanceCategory? existing;

  @override
  State<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<_CategoryEditor> {
  late final TextEditingController _name;
  late String _kind;
  late int _color;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(
      text: e == null
          ? ''
          : (e.displayName?.trim().isNotEmpty == true
              ? e.displayName!
              : ''),
    );
    _kind = e?.kind ?? 'expense';
    _color = e?.colorArgb ?? kCategoryPalette.first;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty && widget.existing == null) {
      setState(() => _error = l10n.financeCategoryNameRequired);
      return;
    }
    // For system cats keep i18n unless user typed a custom name.
    final display = name.isEmpty && widget.existing != null
        ? (widget.existing!.displayName ?? '')
        : name;
    if (display.isEmpty && widget.existing == null) {
      setState(() => _error = l10n.financeCategoryNameRequired);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (widget.existing == null) {
        await widget.database.insertCategory(
          displayName: display,
          kind: _kind,
          colorArgb: _color,
        );
      } else {
        await widget.database.updateCategory(
          id: widget.existing!.id,
          displayName: display.isEmpty
              ? (widget.existing!.displayName ??
                  categoryLabel(l10n, widget.existing!))
              : display,
          colorArgb: _color,
          kind: widget.existing!.isSystem ? widget.existing!.kind : _kind,
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

  Future<void> _archive() async {
    if (widget.existing == null) return;
    await widget.database.deleteCategory(widget.existing!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final isEdit = widget.existing != null;
    final hintName = isEdit
        ? categoryLabel(l10n, widget.existing!)
        : l10n.financeCategoryName;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: GlassSurface(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LumenRadii.lg),
        ),
        fillColor: LumenColors.bgElevated.withValues(alpha: 0.96),
        padding: const EdgeInsets.fromLTRB(
          LumenSpacing.pagePadding,
          LumenSpacing.lg,
          LumenSpacing.pagePadding,
          LumenSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEdit ? l10n.financeEditCategory : l10n.financeNewCategory,
              style: theme.titleLarge,
            ),
            const SizedBox(height: LumenSpacing.md),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: l10n.financeCategoryName,
                hintText: hintName,
              ),
            ),
            if (!isEdit || !(widget.existing?.isSystem ?? false)) ...[
              const SizedBox(height: LumenSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _MiniChip(
                      label: l10n.financeTypeExpense,
                      selected: _kind == 'expense',
                      onTap: () => setState(() => _kind = 'expense'),
                    ),
                  ),
                  const SizedBox(width: LumenSpacing.xs),
                  Expanded(
                    child: _MiniChip(
                      label: l10n.financeTypeIncome,
                      selected: _kind == 'income',
                      onTap: () => setState(() => _kind = 'income'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: LumenSpacing.md),
            Text(l10n.financeColor, style: theme.labelMedium),
            const SizedBox(height: LumenSpacing.xs),
            Wrap(
              spacing: LumenSpacing.xs,
              children: [
                for (final c in kCategoryPalette)
                  GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == c
                              ? LumenColors.text
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
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
                shape: RoundedRectangleBorder(borderRadius: LumenRadii.pill),
              ),
              child: Text(
                l10n.financeSave,
                style: theme.titleMedium?.copyWith(color: LumenColors.bg),
              ),
            ),
            if (isEdit) ...[
              const SizedBox(height: LumenSpacing.sm),
              TextButton(
                onPressed: _archive,
                child: Text(
                  widget.existing!.isSystem
                      ? l10n.financeArchiveCategory
                      : l10n.financeDeleteCategory,
                  style: const TextStyle(color: LumenColors.accentRed),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: LumenSpacing.sm),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? LumenColors.text : LumenColors.textMuted,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showAccountManagerSheet({
  required BuildContext context,
  required AppDatabase database,
  required String currencyCode,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AccountManagerSheet(
      database: database,
      currencyCode: currencyCode,
    ),
  );
}

class AccountManagerSheet extends StatelessWidget {
  const AccountManagerSheet({
    super.key,
    required this.database,
    required this.currencyCode,
  });

  final AppDatabase database;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;

    return GlassSurface(
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
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: Text(l10n.financeAccounts, style: theme.titleLarge),
                ),
                IconButton(
                  onPressed: () => _edit(context, null),
                  icon: const Icon(
                    PhosphorIconsRegular.plusCircle,
                    color: LumenColors.accentMint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: LumenSpacing.sm),
            Expanded(
              child: StreamBuilder<List<FinanceAccount>>(
                stream: database.watchAccounts(),
                builder: (context, snapshot) {
                  final accounts = snapshot.data ?? const [];
                  return ListView.separated(
                    itemCount: accounts.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: LumenSpacing.xs),
                    itemBuilder: (context, i) {
                      final acc = accounts[i];
                      return GlowCard(
                        onTap: () => _edit(context, acc),
                        padding: const EdgeInsets.all(LumenSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(acc.name, style: theme.titleMedium),
                                  Text(
                                    l10n.financeBalance,
                                    style: theme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            BigNumber(
                              MoneyFormat.formatCompact(
                                acc.balanceMinor,
                                currencyCode: acc.currencyCode,
                              ),
                              style: theme.titleLarge?.copyWith(
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, FinanceAccount? existing) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AccountEditor(
        database: database,
        currencyCode: currencyCode,
        existing: existing,
      ),
    );
  }
}

class _AccountEditor extends StatefulWidget {
  const _AccountEditor({
    required this.database,
    required this.currencyCode,
    this.existing,
  });

  final AppDatabase database;
  final String currencyCode;
  final FinanceAccount? existing;

  @override
  State<_AccountEditor> createState() => _AccountEditorState();
}

class _AccountEditorState extends State<_AccountEditor> {
  late final TextEditingController _name;
  late final TextEditingController _balance;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _balance = TextEditingController(
      text: e == null ? '0' : (e.balanceMinor / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _balance.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.financeAccountRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final bal = MoneyFormat.parseToMinor(_balance.text);
      if (widget.existing == null) {
        await widget.database.insertAccount(
          name: name,
          currencyCode: widget.currencyCode,
          balanceMinor: bal,
        );
      } else {
        await widget.database.updateAccount(
          id: widget.existing!.id,
          name: name,
          balanceMinor: bal,
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

  Future<void> _archive() async {
    final l10n = AppLocalizations.of(context);
    if (widget.existing == null) return;
    final ok = await widget.database.archiveAccount(widget.existing!.id);
    if (!mounted) return;
    if (!ok) {
      setState(() => _error = l10n.financeCannotArchiveLastAccount);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final isEdit = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: GlassSurface(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LumenRadii.lg),
        ),
        fillColor: LumenColors.bgElevated.withValues(alpha: 0.96),
        padding: const EdgeInsets.fromLTRB(
          LumenSpacing.pagePadding,
          LumenSpacing.lg,
          LumenSpacing.pagePadding,
          LumenSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEdit ? l10n.financeEditAccount : l10n.financeNewAccount,
              style: theme.titleLarge,
            ),
            const SizedBox(height: LumenSpacing.md),
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.financeAccountName),
            ),
            const SizedBox(height: LumenSpacing.md),
            TextField(
              controller: _balance,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.financeAccountBalance,
                suffixText: widget.currencyCode,
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
                shape: RoundedRectangleBorder(borderRadius: LumenRadii.pill),
              ),
              child: Text(
                l10n.financeSave,
                style: theme.titleMedium?.copyWith(color: LumenColors.bg),
              ),
            ),
            if (isEdit) ...[
              const SizedBox(height: LumenSpacing.sm),
              TextButton(
                onPressed: _archive,
                child: Text(
                  l10n.financeArchiveAccount,
                  style: const TextStyle(color: LumenColors.accentRed),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

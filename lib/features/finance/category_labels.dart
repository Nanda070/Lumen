import '../../data/app_database.dart';
import '../../l10n/app_localizations.dart';

/// Resolve category label: custom displayName → i18n nameKey → raw key.
String categoryLabel(AppLocalizations l10n, FinanceCategory category) {
  final custom = category.displayName?.trim();
  if (custom != null && custom.isNotEmpty) return custom;
  return switch (category.nameKey) {
    'food' => l10n.catFood,
    'transport' => l10n.catTransport,
    'home' => l10n.catHome,
    'shopping' => l10n.catShopping,
    'health' => l10n.catHealth,
    'other_expense' => l10n.catOtherExpense,
    'salary' => l10n.catSalary,
    'other_income' => l10n.catOtherIncome,
    _ => category.nameKey,
  };
}

/// Default palette for new custom categories.
const List<int> kCategoryPalette = [
  0xFFFF6B3D,
  0xFF5B7CFF,
  0xFF8B6CFF,
  0xFFFFB347,
  0xFF5ECF9A,
  0xFFC53B4A,
  0xFFE6DDD0,
  0xFF8B919C,
];

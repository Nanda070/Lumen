import 'package:intl/intl.dart';

/// Money helpers — amounts stored as minor units (cents).
abstract final class MoneyFormat {
  static const int scale = 100;

  static int parseToMinor(String raw) {
    final cleaned = raw.trim().replaceAll(',', '.').replaceAll(' ', '');
    if (cleaned.isEmpty) return 0;
    final value = double.tryParse(cleaned);
    if (value == null) return 0;
    return (value * scale).round();
  }

  static String formatMinor(
    int minor, {
    String? currencyCode,
    String? locale,
    bool showSign = false,
  }) {
    final abs = minor.abs() / scale;
    var text = NumberFormat('#,##0.00', locale).format(abs);
    if (currencyCode != null && currencyCode.isNotEmpty) {
      text = '$text $currencyCode';
    }
    if (showSign) {
      if (minor < 0) return '−$text';
      if (minor > 0) return '+$text';
    }
    return text;
  }

  /// Card-friendly: drops cents for large values, uses k/M when needed.
  static String formatCompact(
    int minor, {
    String? currencyCode,
    bool forceShort = false,
  }) {
    final abs = minor.abs() / scale;
    String text;
    if (forceShort || abs >= 1000000) {
      text = NumberFormat.compact().format(abs);
    } else if (abs >= 10000) {
      text = NumberFormat('#,##0').format(abs.round());
    } else if (abs >= 1000) {
      text = NumberFormat('#,##0.#').format(abs);
    } else {
      text = NumberFormat('#,##0.##').format(abs);
    }
    if (currencyCode == null || currencyCode.isEmpty) return text;
    return '$text $currencyCode';
  }

  /// Short value without currency — for tight metric cards.
  static String formatCard(int minor) {
    final abs = minor.abs() / scale;
    if (abs >= 1000000) return NumberFormat.compact().format(abs);
    if (abs >= 1000) return NumberFormat('#,##0').format(abs.round());
    return NumberFormat('#,##0.##').format(abs);
  }

  static String formatSigned(
    int minor, {
    required bool isExpense,
    String? currencyCode,
  }) {
    final body = formatCompact(minor.abs(), currencyCode: currencyCode);
    return isExpense ? '−$body' : '+$body';
  }
}

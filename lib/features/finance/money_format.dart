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

  static String formatCompact(
    int minor, {
    String? currencyCode,
  }) {
    final abs = minor.abs() / scale;
    final text = NumberFormat('#,##0.##').format(abs);
    if (currencyCode == null || currencyCode.isEmpty) return text;
    return '$text $currencyCode';
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

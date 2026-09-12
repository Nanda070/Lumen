/// Local date helpers for calendar views (no timezone gymnastics beyond local).
abstract final class CalendarDateUtils {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime startOfWeek(DateTime d, {int startWeekday = DateTime.monday}) {
    final day = dateOnly(d);
    final diff = (day.weekday - startWeekday) % 7;
    return day.subtract(Duration(days: diff));
  }

  static DateTime endOfWeek(DateTime d, {int startWeekday = DateTime.monday}) {
    return startOfWeek(d, startWeekday: startWeekday)
        .add(const Duration(days: 7));
  }

  static DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month);

  static DateTime endOfMonth(DateTime d) =>
      DateTime(d.year, d.month + 1);

  /// Grid start (Monday of the week that contains the 1st).
  static DateTime monthGridStart(DateTime d) {
    return startOfWeek(startOfMonth(d));
  }

  /// Exclusive end after the last cell (6 weeks × 7 days).
  static DateTime monthGridEnd(DateTime d) {
    return monthGridStart(d).add(const Duration(days: 42));
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isToday(DateTime d) => isSameDay(d, DateTime.now());

  static double minutesSinceMidnight(DateTime t) =>
      t.hour * 60.0 + t.minute + t.second / 60.0;

  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  static String formatTimeRange(DateTime start, DateTime end) {
    final a = '${twoDigits(start.hour)}:${twoDigits(start.minute)}';
    final b = '${twoDigits(end.hour)}:${twoDigits(end.minute)}';
    return '$a – $b';
  }

  static String formatHourLabel(int hour) {
    return '${twoDigits(hour)}:00';
  }
}

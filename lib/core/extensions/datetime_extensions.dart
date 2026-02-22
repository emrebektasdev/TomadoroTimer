/// DateTime extension methods for cleaner date operations.
library;

extension DateTimeX on DateTime {
  /// Returns date-only DateTime (time set to midnight)
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns true if this date is the same day as [other]
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns true if this date is yesterday compared to [other]
  bool isYesterday(DateTime other) {
    final yesterday = other.subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Returns true if this date is today
  bool get isToday => isSameDay(DateTime.now());

  /// Returns the start of the week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return dateOnly.subtract(Duration(days: daysFromMonday));
  }

  /// Returns the end of the week (Sunday)
  DateTime get endOfWeek {
    final daysUntilSunday = 7 - weekday;
    return dateOnly.add(Duration(days: daysUntilSunday));
  }

  /// Returns the start of the month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns the end of the month
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// Returns ISO date string (YYYY-MM-DD)
  String get toDateKey =>
      '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// Returns the number of days in the current month
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Returns the difference in days from [other] (ignoring time)
  int daysDifference(DateTime other) {
    return dateOnly.difference(other.dateOnly).inDays;
  }
}

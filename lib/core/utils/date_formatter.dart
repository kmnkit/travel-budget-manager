import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} - ${formatDate(end)}';
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.isNegative) {
      final days = diff.inDays.abs();
      if (days == 0) return 'today';
      if (days == 1) return 'yesterday';
      return '$days days ago';
    } else {
      final days = diff.inDays;
      if (days == 0) return 'today';
      if (days == 1) return 'tomorrow';
      return 'in $days days';
    }
  }

  static int daysBetween(DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return endDate.difference(startDate).inDays;
  }
}

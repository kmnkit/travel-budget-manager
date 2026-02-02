import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('formatDate', () {
      test('formats date as yyyy.MM.dd', () {
        final date = DateTime(2026, 3, 15);
        expect(DateFormatter.formatDate(date), '2026.03.15');
      });
    });

    group('formatDateRange', () {
      test('formats date range with dash separator', () {
        final start = DateTime(2026, 3, 1);
        final end = DateTime(2026, 3, 10);
        expect(DateFormatter.formatDateRange(start, end), '2026.03.01 - 2026.03.10');
      });
    });

    group('daysBetween', () {
      test('returns correct number of days', () {
        final start = DateTime(2026, 3, 1);
        final end = DateTime(2026, 3, 10);
        expect(DateFormatter.daysBetween(start, end), 9);
      });

      test('returns 0 for same day', () {
        final date = DateTime(2026, 3, 1);
        expect(DateFormatter.daysBetween(date, date), 0);
      });

      test('ignores time component', () {
        final start = DateTime(2026, 3, 1, 23, 59);
        final end = DateTime(2026, 3, 2, 0, 1);
        expect(DateFormatter.daysBetween(start, end), 1);
      });
    });
  });
}

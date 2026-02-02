import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    group('format', () {
      test('formats KRW without decimals', () {
        expect(CurrencyFormatter.format(15000, 'KRW'), '₩15,000');
      });

      test('formats USD with 2 decimals', () {
        expect(CurrencyFormatter.format(42.5, 'USD'), '\$42.50');
      });

      test('formats EUR with 2 decimals', () {
        expect(CurrencyFormatter.format(100, 'EUR'), '€100.00');
      });

      test('formats JPY without decimals', () {
        expect(CurrencyFormatter.format(5000, 'JPY'), '¥5,000');
      });

      test('handles case-insensitive currency code', () {
        expect(CurrencyFormatter.format(100, 'usd'), '\$100.00');
      });
    });

    group('formatWithoutSymbol', () {
      test('formats number without currency symbol', () {
        expect(CurrencyFormatter.formatWithoutSymbol(15000, 'KRW'), '15,000');
      });

      test('formats decimal without symbol', () {
        expect(CurrencyFormatter.formatWithoutSymbol(42.5, 'USD'), '42.50');
      });
    });
  });
}

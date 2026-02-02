import 'package:intl/intl.dart';
import '../constants/currency_constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, String currencyCode) {
    final currency = SupportedCurrency.fromCode(currencyCode);
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: currency.decimalPlaces,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, String currencyCode) {
    final currency = SupportedCurrency.fromCode(currencyCode);
    final formatter = NumberFormat.compactCurrency(
      symbol: currency.symbol,
      decimalDigits: currency.decimalPlaces,
    );
    return formatter.format(amount);
  }

  static String formatWithoutSymbol(double amount, String currencyCode) {
    final currency = SupportedCurrency.fromCode(currencyCode);
    final formatter = NumberFormat.decimalPatternDigits(
      decimalDigits: currency.decimalPlaces,
    );
    return formatter.format(amount);
  }
}

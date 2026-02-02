import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';

abstract class ExchangeRateRepository {
  Future<List<ExchangeRate>> getRatesByTrip(int tripId);
  Future<ExchangeRate?> getRate(
    String baseCurrency,
    String targetCurrency, {
    int? tripId,
  });
  Future<double> convert(
    double amount,
    String fromCurrency,
    String toCurrency, {
    int? tripId,
  });
  Future<ExchangeRate> setManualRate({
    int? tripId,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
  });
  Future<List<ExchangeRate>> fetchLatestRates(String baseCurrency);
  Stream<List<ExchangeRate>> watchRatesByTrip(int tripId);
}

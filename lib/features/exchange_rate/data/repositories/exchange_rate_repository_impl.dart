import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_local_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';
import 'package:trip_wallet/features/exchange_rate/domain/repositories/exchange_rate_repository.dart';
import 'package:trip_wallet/core/errors/exceptions.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateLocalDatasource _localDatasource;
  final ExchangeRateRemoteDatasource _remoteDatasource;

  ExchangeRateRepositoryImpl(
    this._localDatasource,
    this._remoteDatasource,
  );

  @override
  Future<List<ExchangeRate>> getRatesByTrip(int tripId) {
    return _localDatasource.getRatesByTrip(tripId);
  }

  @override
  Future<ExchangeRate?> getRate(
    String baseCurrency,
    String targetCurrency, {
    int? tripId,
  }) {
    return _localDatasource.getRate(
      baseCurrency,
      targetCurrency,
      tripId: tripId,
    );
  }

  @override
  Future<double> convert(
    double amount,
    String fromCurrency,
    String toCurrency, {
    int? tripId,
  }) async {
    // Same currency, no conversion needed
    if (fromCurrency == toCurrency) {
      return amount;
    }

    final rate = await _localDatasource.getRate(
      fromCurrency,
      toCurrency,
      tripId: tripId,
    );

    if (rate == null) {
      throw DatabaseException(
          'Exchange rate not found for $fromCurrency to $toCurrency');
    }

    return amount * rate.rate;
  }

  @override
  Future<ExchangeRate> setManualRate({
    int? tripId,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
  }) {
    return _localDatasource.setManualRate(
      tripId: tripId,
      baseCurrency: baseCurrency,
      targetCurrency: targetCurrency,
      rate: rate,
    );
  }

  @override
  Future<List<ExchangeRate>> fetchLatestRates(String baseCurrency) async {
    try {
      // Try to fetch from remote API
      final remoteRates = await _remoteDatasource.fetchRates(baseCurrency);

      // Save to local database
      return await _localDatasource.saveRates(
        baseCurrency: baseCurrency,
        rates: remoteRates,
      );
    } on NetworkException {
      // Fallback to cached rates
      final cachedRates = await _localDatasource.getCachedRates(baseCurrency);

      if (cachedRates.isEmpty) {
        throw const NetworkException(
            'Unable to fetch rates and no cached rates available');
      }

      return cachedRates;
    }
  }

  @override
  Stream<List<ExchangeRate>> watchRatesByTrip(int tripId) {
    return _localDatasource.watchRatesByTrip(tripId);
  }
}

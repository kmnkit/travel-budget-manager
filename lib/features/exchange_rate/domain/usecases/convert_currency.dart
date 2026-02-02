import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/exchange_rate/domain/repositories/exchange_rate_repository.dart';
import 'package:trip_wallet/features/exchange_rate/data/repositories/exchange_rate_repository_impl.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_local_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';

class ConvertCurrency {
  final ExchangeRateRepository _repository;

  ConvertCurrency(this._repository);

  Future<double> call(
    double amount,
    String fromCurrency,
    String toCurrency, {
    int? tripId,
  }) {
    return _repository.convert(
      amount,
      fromCurrency,
      toCurrency,
      tripId: tripId,
    );
  }
}

final convertCurrencyProvider = Provider<ConvertCurrency>((ref) {
  final localDatasource = ref.watch(exchangeRateLocalDatasourceProvider);
  final remoteDatasource = ref.watch(exchangeRateRemoteDatasourceProvider);
  final repository = ExchangeRateRepositoryImpl(
    localDatasource,
    remoteDatasource,
  );
  return ConvertCurrency(repository);
});

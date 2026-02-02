import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';
import 'package:trip_wallet/features/exchange_rate/domain/repositories/exchange_rate_repository.dart';
import 'package:trip_wallet/features/exchange_rate/data/repositories/exchange_rate_repository_impl.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_local_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';

class GetExchangeRate {
  final ExchangeRateRepository _repository;

  GetExchangeRate(this._repository);

  Future<ExchangeRate?> call(
    String baseCurrency,
    String targetCurrency, {
    int? tripId,
  }) {
    return _repository.getRate(
      baseCurrency,
      targetCurrency,
      tripId: tripId,
    );
  }
}

final getExchangeRateProvider = Provider<GetExchangeRate>((ref) {
  final localDatasource = ref.watch(exchangeRateLocalDatasourceProvider);
  final remoteDatasource = ref.watch(exchangeRateRemoteDatasourceProvider);
  final repository = ExchangeRateRepositoryImpl(
    localDatasource,
    remoteDatasource,
  );
  return GetExchangeRate(repository);
});

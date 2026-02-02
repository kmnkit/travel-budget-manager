import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';
import 'package:trip_wallet/features/exchange_rate/domain/repositories/exchange_rate_repository.dart';
import 'package:trip_wallet/features/exchange_rate/domain/usecases/convert_currency.dart';
import 'package:trip_wallet/features/exchange_rate/domain/usecases/get_exchange_rate.dart';
import 'package:trip_wallet/features/exchange_rate/data/repositories/exchange_rate_repository_impl.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_local_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';

// Exchange rate mode enum
enum ExchangeRateMode { auto, manual }

// Repository provider
final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  final localDatasource = ref.watch(exchangeRateLocalDatasourceProvider);
  final remoteDatasource = ref.watch(exchangeRateRemoteDatasourceProvider);
  return ExchangeRateRepositoryImpl(localDatasource, remoteDatasource);
});

// Use case providers
final getExchangeRateProvider = Provider<GetExchangeRate>((ref) {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  return GetExchangeRate(repository);
});

final currencyConverterProvider = Provider<ConvertCurrency>((ref) {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  return ConvertCurrency(repository);
});

// Data providers
final tripExchangeRatesProvider = StreamProvider.family<List<ExchangeRate>, int>((ref, tripId) {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  return repository.watchRatesByTrip(tripId);
});

// Mode toggle provider
final exchangeRateModeProvider =
    NotifierProvider<ExchangeRateModeNotifier, ExchangeRateMode>(
  ExchangeRateModeNotifier.new,
);

/// Notifier for exchange rate mode toggle
class ExchangeRateModeNotifier extends Notifier<ExchangeRateMode> {
  @override
  ExchangeRateMode build() => ExchangeRateMode.auto;

  void setMode(ExchangeRateMode mode) {
    state = mode;
  }
}

// Fetch latest rates provider
final fetchRatesProvider = FutureProvider.family<void, String>((ref, baseCurrency) async {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  await repository.fetchLatestRates(baseCurrency);
});

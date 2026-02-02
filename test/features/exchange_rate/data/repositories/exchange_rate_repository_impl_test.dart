import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_local_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart';
import 'package:trip_wallet/features/exchange_rate/data/repositories/exchange_rate_repository_impl.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';
import 'package:trip_wallet/core/errors/exceptions.dart';

class MockExchangeRateLocalDatasource extends Mock
    implements ExchangeRateLocalDatasource {}

class MockExchangeRateRemoteDatasource extends Mock
    implements ExchangeRateRemoteDatasource {}

void main() {
  late ExchangeRateRepositoryImpl repository;
  late MockExchangeRateLocalDatasource mockLocalDatasource;
  late MockExchangeRateRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockLocalDatasource = MockExchangeRateLocalDatasource();
    mockRemoteDatasource = MockExchangeRateRemoteDatasource();
    repository = ExchangeRateRepositoryImpl(
      mockLocalDatasource,
      mockRemoteDatasource,
    );
  });

  group('getRatesByTrip', () {
    const tTripId = 1;
    final tRates = [
      ExchangeRate(
        id: 1,
        tripId: tTripId,
        baseCurrency: 'USD',
        targetCurrency: 'KRW',
        rate: 1300.0,
        isManual: false,
        updatedAt: DateTime(2024, 1, 1),
      ),
      ExchangeRate(
        id: 2,
        tripId: tTripId,
        baseCurrency: 'USD',
        targetCurrency: 'JPY',
        rate: 110.0,
        isManual: false,
        updatedAt: DateTime(2024, 1, 1),
      ),
    ];

    test('should return rates for trip from local datasource', () async {
      // arrange
      when(() => mockLocalDatasource.getRatesByTrip(tTripId))
          .thenAnswer((_) async => tRates);

      // act
      final result = await repository.getRatesByTrip(tTripId);

      // assert
      expect(result, tRates);
      verify(() => mockLocalDatasource.getRatesByTrip(tTripId)).called(1);
    });

    test('should throw DatabaseException when datasource fails', () async {
      // arrange
      when(() => mockLocalDatasource.getRatesByTrip(tTripId))
          .thenAnswer((_) async => throw const DatabaseException('Failed to fetch'));

      // act & assert
      await expectLater(
        repository.getRatesByTrip(tTripId),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('getRate', () {
    const tBaseCurrency = 'USD';
    const tTargetCurrency = 'KRW';
    const tTripId = 1;
    final tRate = ExchangeRate(
      id: 1,
      tripId: tTripId,
      baseCurrency: tBaseCurrency,
      targetCurrency: tTargetCurrency,
      rate: 1300.0,
      isManual: false,
      updatedAt: DateTime(2024, 1, 1),
    );

    test('should return rate from local datasource when found', () async {
      // arrange
      when(() => mockLocalDatasource.getRate(
            tBaseCurrency,
            tTargetCurrency,
            tripId: tTripId,
          )).thenAnswer((_) async => tRate);

      // act
      final result = await repository.getRate(
        tBaseCurrency,
        tTargetCurrency,
        tripId: tTripId,
      );

      // assert
      expect(result, tRate);
      verify(() => mockLocalDatasource.getRate(
            tBaseCurrency,
            tTargetCurrency,
            tripId: tTripId,
          )).called(1);
    });

    test('should return null when rate not found', () async {
      // arrange
      when(() => mockLocalDatasource.getRate(
            tBaseCurrency,
            tTargetCurrency,
            tripId: tTripId,
          )).thenAnswer((_) async => null);

      // act
      final result = await repository.getRate(
        tBaseCurrency,
        tTargetCurrency,
        tripId: tTripId,
      );

      // assert
      expect(result, null);
    });
  });

  group('convert', () {
    const tAmount = 100.0;
    const tFromCurrency = 'USD';
    const tToCurrency = 'KRW';
    const tTripId = 1;
    const tRate = 1300.0;
    const tExpectedResult = 130000.0;

    final tExchangeRate = ExchangeRate(
      id: 1,
      tripId: tTripId,
      baseCurrency: tFromCurrency,
      targetCurrency: tToCurrency,
      rate: tRate,
      isManual: false,
      updatedAt: DateTime(2024, 1, 1),
    );

    test('should convert amount using existing rate', () async {
      // arrange
      when(() => mockLocalDatasource.getRate(
            tFromCurrency,
            tToCurrency,
            tripId: tTripId,
          )).thenAnswer((_) async => tExchangeRate);

      // act
      final result = await repository.convert(
        tAmount,
        tFromCurrency,
        tToCurrency,
        tripId: tTripId,
      );

      // assert
      expect(result, tExpectedResult);
    });

    test('should return original amount when currencies are same', () async {
      // act
      final result = await repository.convert(
        tAmount,
        tFromCurrency,
        tFromCurrency,
        tripId: tTripId,
      );

      // assert
      expect(result, tAmount);
      verifyNever(() => mockLocalDatasource.getRate(any(), any(), tripId: any(named: 'tripId')));
    });

    test('should throw DatabaseException when rate not found', () async {
      // arrange
      when(() => mockLocalDatasource.getRate(
            tFromCurrency,
            tToCurrency,
            tripId: tTripId,
          )).thenAnswer((_) async => null);

      // act & assert
      await expectLater(
        repository.convert(
          tAmount,
          tFromCurrency,
          tToCurrency,
          tripId: tTripId,
        ),
        throwsA(isA<DatabaseException>().having(
          (e) => e.message,
          'message',
          contains('Exchange rate not found'),
        )),
      );
    });
  });

  group('setManualRate', () {
    const tTripId = 1;
    const tBaseCurrency = 'USD';
    const tTargetCurrency = 'KRW';
    const tRate = 1350.0;
    final tManualRate = ExchangeRate(
      id: 1,
      tripId: tTripId,
      baseCurrency: tBaseCurrency,
      targetCurrency: tTargetCurrency,
      rate: tRate,
      isManual: true,
      updatedAt: DateTime(2024, 1, 1),
    );

    test('should set manual rate and return it', () async {
      // arrange
      when(() => mockLocalDatasource.setManualRate(
            tripId: tTripId,
            baseCurrency: tBaseCurrency,
            targetCurrency: tTargetCurrency,
            rate: tRate,
          )).thenAnswer((_) async => tManualRate);

      // act
      final result = await repository.setManualRate(
        tripId: tTripId,
        baseCurrency: tBaseCurrency,
        targetCurrency: tTargetCurrency,
        rate: tRate,
      );

      // assert
      expect(result, tManualRate);
      expect(result.isManual, true);
      verify(() => mockLocalDatasource.setManualRate(
            tripId: tTripId,
            baseCurrency: tBaseCurrency,
            targetCurrency: tTargetCurrency,
            rate: tRate,
          )).called(1);
    });

    test('should throw ValidationException for invalid rate', () async {
      // arrange
      when(() => mockLocalDatasource.setManualRate(
            tripId: tTripId,
            baseCurrency: tBaseCurrency,
            targetCurrency: tTargetCurrency,
            rate: -1.0,
          )).thenAnswer((_) async => throw const ValidationException('Rate must be positive'));

      // act & assert
      await expectLater(
        repository.setManualRate(
          tripId: tTripId,
          baseCurrency: tBaseCurrency,
          targetCurrency: tTargetCurrency,
          rate: -1.0,
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('fetchLatestRates', () {
    const tBaseCurrency = 'USD';
    final tRemoteRates = {
      'KRW': 1300.0,
      'JPY': 110.0,
      'EUR': 0.85,
    };

    final tSavedRates = [
      ExchangeRate(
        id: 1,
        baseCurrency: tBaseCurrency,
        targetCurrency: 'KRW',
        rate: 1300.0,
        isManual: false,
        updatedAt: DateTime.now(),
      ),
      ExchangeRate(
        id: 2,
        baseCurrency: tBaseCurrency,
        targetCurrency: 'JPY',
        rate: 110.0,
        isManual: false,
        updatedAt: DateTime.now(),
      ),
      ExchangeRate(
        id: 3,
        baseCurrency: tBaseCurrency,
        targetCurrency: 'EUR',
        rate: 0.85,
        isManual: false,
        updatedAt: DateTime.now(),
      ),
    ];

    test('should fetch rates from remote and save to local', () async {
      // arrange
      when(() => mockRemoteDatasource.fetchRates(tBaseCurrency))
          .thenAnswer((_) async => tRemoteRates);
      when(() => mockLocalDatasource.saveRates(
            baseCurrency: tBaseCurrency,
            rates: tRemoteRates,
          )).thenAnswer((_) async => tSavedRates);

      // act
      final result = await repository.fetchLatestRates(tBaseCurrency);

      // assert
      expect(result, tSavedRates);
      verify(() => mockRemoteDatasource.fetchRates(tBaseCurrency)).called(1);
      verify(() => mockLocalDatasource.saveRates(
            baseCurrency: tBaseCurrency,
            rates: tRemoteRates,
          )).called(1);
    });

    test('should return cached rates when remote fetch fails', () async {
      // arrange
      when(() => mockRemoteDatasource.fetchRates(tBaseCurrency))
          .thenAnswer((_) async => throw const NetworkException('API unavailable'));
      when(() => mockLocalDatasource.getCachedRates(tBaseCurrency))
          .thenAnswer((_) async => tSavedRates);

      // act
      final result = await repository.fetchLatestRates(tBaseCurrency);

      // assert
      expect(result, tSavedRates);
      verify(() => mockRemoteDatasource.fetchRates(tBaseCurrency)).called(1);
      verify(() => mockLocalDatasource.getCachedRates(tBaseCurrency)).called(1);
    });

    test('should throw NetworkException when both remote and cache fail',
        () async {
      // arrange
      when(() => mockRemoteDatasource.fetchRates(tBaseCurrency))
          .thenAnswer((_) async => throw const NetworkException('API unavailable'));
      when(() => mockLocalDatasource.getCachedRates(tBaseCurrency))
          .thenAnswer((_) async => []);

      // act & assert
      await expectLater(
        repository.fetchLatestRates(tBaseCurrency),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('watchRatesByTrip', () {
    const tTripId = 1;
    final tRates = [
      ExchangeRate(
        id: 1,
        tripId: tTripId,
        baseCurrency: 'USD',
        targetCurrency: 'KRW',
        rate: 1300.0,
        isManual: false,
        updatedAt: DateTime(2024, 1, 1),
      ),
    ];

    test('should return stream of rates from local datasource', () {
      // arrange
      when(() => mockLocalDatasource.watchRatesByTrip(tTripId))
          .thenAnswer((_) => Stream.value(tRates));

      // act
      final result = repository.watchRatesByTrip(tTripId);

      // assert
      expect(result, emits(tRates));
      verify(() => mockLocalDatasource.watchRatesByTrip(tTripId)).called(1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';
import 'package:trip_wallet/features/exchange_rate/domain/repositories/exchange_rate_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

void main() {
  late MockExchangeRateRepository repository;

  setUp(() {
    repository = MockExchangeRateRepository();
  });

  group('ExchangeRateRepository Interface', () {
    test('should have getRatesByTrip method', () {
      final rates = [
        ExchangeRate(
          id: 1,
          tripId: 1,
          baseCurrency: 'USD',
          targetCurrency: 'KRW',
          rate: 1300.0,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => repository.getRatesByTrip(1))
          .thenAnswer((_) async => rates);

      expect(repository.getRatesByTrip(1), completes);
    });

    test('should have getRate method', () {
      final rate = ExchangeRate(
        id: 1,
        tripId: 1,
        baseCurrency: 'USD',
        targetCurrency: 'KRW',
        rate: 1300.0,
        isManual: false,
        updatedAt: DateTime(2024, 1, 1),
      );

      when(() => repository.getRate('USD', 'KRW', tripId: 1))
          .thenAnswer((_) async => rate);

      expect(repository.getRate('USD', 'KRW', tripId: 1), completes);
    });

    test('should have convert method', () {
      when(() => repository.convert(100.0, 'USD', 'KRW', tripId: 1))
          .thenAnswer((_) async => 130000.0);

      expect(repository.convert(100.0, 'USD', 'KRW', tripId: 1), completes);
    });

    test('should have setManualRate method', () {
      final rate = ExchangeRate(
        id: 1,
        tripId: 1,
        baseCurrency: 'USD',
        targetCurrency: 'KRW',
        rate: 1350.0,
        isManual: true,
        updatedAt: DateTime(2024, 1, 1),
      );

      when(() => repository.setManualRate(
            tripId: 1,
            baseCurrency: 'USD',
            targetCurrency: 'KRW',
            rate: 1350.0,
          )).thenAnswer((_) async => rate);

      expect(
        repository.setManualRate(
          tripId: 1,
          baseCurrency: 'USD',
          targetCurrency: 'KRW',
          rate: 1350.0,
        ),
        completes,
      );
    });

    test('should have fetchLatestRates method', () {
      final rates = [
        ExchangeRate(
          id: 1,
          baseCurrency: 'USD',
          targetCurrency: 'KRW',
          rate: 1300.0,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
        ExchangeRate(
          id: 2,
          baseCurrency: 'USD',
          targetCurrency: 'JPY',
          rate: 110.0,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => repository.fetchLatestRates('USD'))
          .thenAnswer((_) async => rates);

      expect(repository.fetchLatestRates('USD'), completes);
    });

    test('should have watchRatesByTrip method', () {
      final rates = [
        ExchangeRate(
          id: 1,
          tripId: 1,
          baseCurrency: 'USD',
          targetCurrency: 'KRW',
          rate: 1300.0,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => repository.watchRatesByTrip(1))
          .thenAnswer((_) => Stream.value(rates));

      expect(repository.watchRatesByTrip(1), emits(rates));
    });
  });
}

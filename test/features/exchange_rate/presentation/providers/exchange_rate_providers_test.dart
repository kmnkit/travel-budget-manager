import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';
import 'package:trip_wallet/features/exchange_rate/domain/repositories/exchange_rate_repository.dart';
import 'package:trip_wallet/features/exchange_rate/presentation/providers/exchange_rate_providers.dart';

class MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

void main() {
  late MockExchangeRateRepository mockRepository;

  setUp(() {
    mockRepository = MockExchangeRateRepository();
  });

  group('ExchangeRate Providers', () {
    test('tripExchangeRatesProvider streams exchange rates for trip',
        () async {
      // Arrange
      const tripId = 1;
      final rates = [
        ExchangeRate(
          id: 1,
          tripId: tripId,
          baseCurrency: 'USD',
          targetCurrency: 'EUR',
          rate: 0.85,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
        ExchangeRate(
          id: 2,
          tripId: tripId,
          baseCurrency: 'USD',
          targetCurrency: 'JPY',
          rate: 110.0,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => mockRepository.watchRatesByTrip(tripId))
          .thenAnswer((_) => Stream.value(rates));

      final container = ProviderContainer(
        overrides: [
          exchangeRateRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Subscribe to trigger the stream provider
      container.listen(tripExchangeRatesProvider(tripId), (_, _) {});

      // Wait for stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      final state = container.read(tripExchangeRatesProvider(tripId));
      expect(state.value, rates);
      verify(() => mockRepository.watchRatesByTrip(tripId)).called(1);
    });

    test('exchangeRateModeProvider has default auto mode', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final mode = container.read(exchangeRateModeProvider);

      // Assert
      expect(mode, ExchangeRateMode.auto);
    });

    test('exchangeRateModeProvider can be toggled to manual', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(exchangeRateModeProvider.notifier).setMode(
          ExchangeRateMode.manual);
      final mode = container.read(exchangeRateModeProvider);

      // Assert
      expect(mode, ExchangeRateMode.manual);
    });

    test('fetchRatesProvider fetches latest rates', () async {
      // Arrange
      const baseCurrency = 'USD';
      final rates = [
        ExchangeRate(
          id: 1,
          tripId: null,
          baseCurrency: baseCurrency,
          targetCurrency: 'EUR',
          rate: 0.85,
          isManual: false,
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => mockRepository.fetchLatestRates(baseCurrency))
          .thenAnswer((_) async => rates);

      final container = ProviderContainer(
        overrides: [
          exchangeRateRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      await container.read(fetchRatesProvider(baseCurrency).future);

      // Assert
      verify(() => mockRepository.fetchLatestRates(baseCurrency)).called(1);
    });

    test('currencyConverterProvider wires up correctly', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          exchangeRateRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(currencyConverterProvider);

      // Assert
      expect(useCase, isNotNull);
    });

    test('getExchangeRateProvider wires up correctly', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          exchangeRateRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(getExchangeRateProvider);

      // Assert
      expect(useCase, isNotNull);
    });
  });
}

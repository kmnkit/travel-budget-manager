import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/data/datasources/trip_local_datasource.dart';
import 'package:trip_wallet/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';
import 'package:trip_wallet/features/trip/domain/usecases/create_trip.dart';
import 'package:trip_wallet/features/trip/domain/usecases/delete_trip.dart';
import 'package:trip_wallet/features/trip/domain/usecases/get_trips.dart';
import 'package:trip_wallet/features/trip/domain/usecases/update_trip.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';

class MockTripLocalDataSource extends Mock implements TripLocalDataSource {}

class MockTripRepository extends Mock implements TripRepository {}

class FakeTrip extends Fake implements Trip {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTripLocalDataSource mockDataSource;
  late MockTripRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTrip());
    registerFallbackValue(DateTime(2024, 1, 1));
    registerFallbackValue(const AsyncValue<List<Trip>>.loading());
  });

  setUp(() {
    mockDataSource = MockTripLocalDataSource();
    mockRepository = MockTripRepository();

    // Provide default stubs to prevent null returns
    when(() => mockDataSource.watchAllTrips())
        .thenAnswer((_) => Stream.value([]));
    when(() => mockDataSource.getTripById(any()))
        .thenAnswer((_) async => null);
  });

  group('tripLocalDataSourceProvider', () {
    test('provides TripLocalDataSource instance', () {
      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final dataSource = container.read(tripLocalDataSourceProvider);
      expect(dataSource, equals(mockDataSource));
    });
  });

  group('tripRepositoryProvider', () {
    test('provides TripRepository instance', () {
      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(tripRepositoryProvider);
      expect(repository, isA<TripRepository>());
      expect(repository, isA<TripRepositoryImpl>());
    });
  });

  group('Use Case Providers', () {
    test('getTripsProvider provides GetTrips instance', () {
      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final useCase = container.read(getTripsProvider);
      expect(useCase, isA<GetTrips>());
    });

    test('createTripProvider provides CreateTrip instance', () {
      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final useCase = container.read(createTripProvider);
      expect(useCase, isA<CreateTrip>());
    });

    test('updateTripProvider provides UpdateTrip instance', () {
      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final useCase = container.read(updateTripProvider);
      expect(useCase, isA<UpdateTrip>());
    });

    test('deleteTripProvider provides DeleteTrip instance', () {
      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final useCase = container.read(deleteTripProvider);
      expect(useCase, isA<DeleteTrip>());
    });
  });

  group('tripListProvider', () {
    test('emits trips from datasource watchAllTrips', () async {
      final trips = [
        Trip(
          id: 1,
          title: 'Tokyo Trip',
          baseCurrency: 'JPY',
          budget: 1000000,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 7),
          createdAt: DateTime(2023, 12, 1),
          updatedAt: DateTime(2023, 12, 1),
        ),
      ];

      when(() => mockDataSource.watchAllTrips())
          .thenAnswer((_) => Stream.value(trips));

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final listener = Listener<AsyncValue<List<Trip>>>();
      container.listen(
        tripListProvider,
        listener.call,
        fireImmediately: true,
      );

      // Initial loading state
      verify(() => listener(null, const AsyncValue.loading()));

      // Wait for data
      await container.read(tripListProvider.future);

      // Verify data state
      verify(() => listener(
            const AsyncValue.loading(),
            AsyncValue.data(trips),
          ));

      verifyNoMoreInteractions(listener);
    });

    test('emits error when datasource fails', () async {
      final exception = Exception('Database error');
      when(() => mockDataSource.watchAllTrips())
          .thenAnswer((_) => Stream.error(exception));

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      // Subscribe to trigger the provider
      container.listen(tripListProvider, (_, __) {});

      // Wait for error to propagate
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Verify error state
      final state = container.read(tripListProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
    });
  });

  group('tripDetailProvider', () {
    test('returns trip when found', () async {
      final trip = Trip(
        id: 1,
        title: 'Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 1000000,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 7),
        createdAt: DateTime(2023, 12, 1),
        updatedAt: DateTime(2023, 12, 1),
      );

      when(() => mockDataSource.getTripById(1))
          .thenAnswer((_) async => trip);

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(tripDetailProvider(1).future);

      expect(result, equals(trip));
      verify(() => mockDataSource.getTripById(1)).called(1);
    });

    test('returns null when trip not found', () async {
      when(() => mockDataSource.getTripById(999))
          .thenAnswer((_) async => null);

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(tripDetailProvider(999).future);

      expect(result, isNull);
      verify(() => mockDataSource.getTripById(999)).called(1);
    });
  });

  group('TripNotifier', () {
    test('createTrip adds new trip and invalidates providers', () async {
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 1, 7);

      final newTrip = Trip(
        id: 1,
        title: 'Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 1000000,
        startDate: startDate,
        endDate: endDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockRepository.createTrip(
            title: 'Tokyo Trip',
            baseCurrency: 'JPY',
            budget: 1000000,
            startDate: startDate,
            endDate: endDate,
          )).thenAnswer((_) async => newTrip);

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
          tripRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tripNotifierProvider.notifier);

      final result = await notifier.createTrip(
        title: 'Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 1000000,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, equals(newTrip));
      verify(() => mockRepository.createTrip(
            title: 'Tokyo Trip',
            baseCurrency: 'JPY',
            budget: 1000000,
            startDate: startDate,
            endDate: endDate,
          )).called(1);
    });

    test('updateTrip modifies existing trip and invalidates providers',
        () async {
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 1, 10);
      final createdAt = DateTime(2023, 12, 1);
      final updatedAt = DateTime.now();

      final updatedTrip = Trip(
        id: 1,
        title: 'Updated Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 1500000,
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      when(() => mockRepository.updateTrip(any()))
          .thenAnswer((_) async => updatedTrip);

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
          tripRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tripNotifierProvider.notifier);

      final result = await notifier.updateTrip(updatedTrip);

      expect(result, equals(updatedTrip));
      verify(() => mockRepository.updateTrip(any())).called(1);
    });

    test('deleteTrip removes trip and invalidates providers', () async {
      when(() => mockRepository.deleteTrip(1))
          .thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          tripLocalDataSourceProvider.overrideWithValue(mockDataSource),
          tripRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tripNotifierProvider.notifier);

      await notifier.deleteTrip(1);

      verify(() => mockRepository.deleteTrip(1)).called(1);
    });
  });
}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

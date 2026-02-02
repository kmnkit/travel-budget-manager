import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/data/datasources/trip_local_datasource.dart';
import 'package:trip_wallet/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

class MockTripLocalDataSource extends Mock implements TripLocalDataSource {}

void main() {
  late TripRepositoryImpl repository;
  late MockTripLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTripLocalDataSource();
    repository = TripRepositoryImpl(mockDataSource);
  });

  group('TripRepositoryImpl', () {
    final testTrip = Trip(
      id: 1,
      title: 'Tokyo Trip',
      baseCurrency: 'JPY',
      budget: 500000.0,
      startDate: DateTime(2024, 3, 1),
      endDate: DateTime(2024, 3, 7),
      createdAt: DateTime(2024, 2, 1),
      updatedAt: DateTime(2024, 2, 1),
    );

    group('getAllTrips', () {
      test('returns list of trips from datasource', () async {
        // Arrange
        when(() => mockDataSource.getAllTrips())
            .thenAnswer((_) async => [testTrip]);

        // Act
        final result = await repository.getAllTrips();

        // Assert
        expect(result, [testTrip]);
        verify(() => mockDataSource.getAllTrips()).called(1);
      });

      test('returns empty list when no trips exist', () async {
        // Arrange
        when(() => mockDataSource.getAllTrips())
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getAllTrips();

        // Assert
        expect(result, isEmpty);
        verify(() => mockDataSource.getAllTrips()).called(1);
      });
    });

    group('getTripById', () {
      test('returns trip when found', () async {
        // Arrange
        when(() => mockDataSource.getTripById(1))
            .thenAnswer((_) async => testTrip);

        // Act
        final result = await repository.getTripById(1);

        // Assert
        expect(result, testTrip);
        verify(() => mockDataSource.getTripById(1)).called(1);
      });

      test('returns null when trip not found', () async {
        // Arrange
        when(() => mockDataSource.getTripById(999))
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getTripById(999);

        // Assert
        expect(result, isNull);
        verify(() => mockDataSource.getTripById(999)).called(1);
      });
    });

    group('createTrip', () {
      test('creates trip and returns it with generated id', () async {
        // Arrange
        final createdTrip = testTrip.copyWith(id: 2);
        when(() => mockDataSource.createTrip(
              title: 'Tokyo Trip',
              baseCurrency: 'JPY',
              budget: 500000.0,
              startDate: DateTime(2024, 3, 1),
              endDate: DateTime(2024, 3, 7),
            )).thenAnswer((_) async => createdTrip);

        // Act
        final result = await repository.createTrip(
          title: 'Tokyo Trip',
          baseCurrency: 'JPY',
          budget: 500000.0,
          startDate: DateTime(2024, 3, 1),
          endDate: DateTime(2024, 3, 7),
        );

        // Assert
        expect(result.id, 2);
        expect(result.title, 'Tokyo Trip');
        expect(result.baseCurrency, 'JPY');
        expect(result.budget, 500000.0);
        verify(() => mockDataSource.createTrip(
              title: 'Tokyo Trip',
              baseCurrency: 'JPY',
              budget: 500000.0,
              startDate: DateTime(2024, 3, 1),
              endDate: DateTime(2024, 3, 7),
            )).called(1);
      });
    });

    group('updateTrip', () {
      test('updates trip and returns updated version', () async {
        // Arrange
        final updatedTrip = testTrip.copyWith(
          title: 'Updated Trip',
          updatedAt: DateTime(2024, 2, 15),
        );
        when(() => mockDataSource.updateTrip(updatedTrip))
            .thenAnswer((_) async => updatedTrip);

        // Act
        final result = await repository.updateTrip(updatedTrip);

        // Assert
        expect(result.title, 'Updated Trip');
        expect(result.id, testTrip.id);
        verify(() => mockDataSource.updateTrip(updatedTrip)).called(1);
      });
    });

    group('deleteTrip', () {
      test('deletes trip by id', () async {
        // Arrange
        when(() => mockDataSource.deleteTrip(1))
            .thenAnswer((_) async => {});

        // Act
        await repository.deleteTrip(1);

        // Assert
        verify(() => mockDataSource.deleteTrip(1)).called(1);
      });
    });

    group('watchAllTrips', () {
      test('returns stream of trips', () async {
        // Arrange
        when(() => mockDataSource.watchAllTrips())
            .thenAnswer((_) => Stream.value([testTrip]));

        // Act
        final stream = repository.watchAllTrips();

        // Assert
        expect(stream, isA<Stream<List<Trip>>>());
        await expectLater(stream, emits([testTrip]));
        verify(() => mockDataSource.watchAllTrips()).called(1);
      });

      test('emits updates when trips change', () async {
        // Arrange
        final trip2 = testTrip.copyWith(id: 2, title: 'Osaka Trip');
        when(() => mockDataSource.watchAllTrips()).thenAnswer(
          (_) => Stream.fromIterable([
            [testTrip],
            [testTrip, trip2],
          ]),
        );

        // Act
        final stream = repository.watchAllTrips();

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            [testTrip],
            [testTrip, trip2],
          ]),
        );
      });
    });
  });
}

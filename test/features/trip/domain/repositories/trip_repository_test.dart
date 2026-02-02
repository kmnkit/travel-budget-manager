import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

class MockTripRepository extends Mock implements TripRepository {}

void main() {
  late MockTripRepository repository;

  setUp(() {
    repository = MockTripRepository();
  });

  group('TripRepository', () {
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

    test('getAllTrips returns list of trips', () async {
      // Arrange
      when(() => repository.getAllTrips())
          .thenAnswer((_) async => [testTrip]);

      // Act
      final result = await repository.getAllTrips();

      // Assert
      expect(result, isA<List<Trip>>());
      expect(result.length, 1);
      expect(result.first.title, 'Tokyo Trip');
      verify(() => repository.getAllTrips()).called(1);
    });

    test('getTripById returns trip when found', () async {
      // Arrange
      when(() => repository.getTripById(1))
          .thenAnswer((_) async => testTrip);

      // Act
      final result = await repository.getTripById(1);

      // Assert
      expect(result, isNotNull);
      expect(result?.id, 1);
      expect(result?.title, 'Tokyo Trip');
      verify(() => repository.getTripById(1)).called(1);
    });

    test('getTripById returns null when not found', () async {
      // Arrange
      when(() => repository.getTripById(999))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getTripById(999);

      // Assert
      expect(result, isNull);
      verify(() => repository.getTripById(999)).called(1);
    });

    test('createTrip returns created trip with generated id', () async {
      // Arrange
      final newTrip = testTrip.copyWith(id: 2);
      when(() => repository.createTrip(
            title: 'Tokyo Trip',
            baseCurrency: 'JPY',
            budget: 500000.0,
            startDate: DateTime(2024, 3, 1),
            endDate: DateTime(2024, 3, 7),
          )).thenAnswer((_) async => newTrip);

      // Act
      final result = await repository.createTrip(
        title: 'Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 500000.0,
        startDate: DateTime(2024, 3, 1),
        endDate: DateTime(2024, 3, 7),
      );

      // Assert
      expect(result.id, isPositive);
      expect(result.title, 'Tokyo Trip');
      expect(result.baseCurrency, 'JPY');
      verify(() => repository.createTrip(
            title: 'Tokyo Trip',
            baseCurrency: 'JPY',
            budget: 500000.0,
            startDate: DateTime(2024, 3, 1),
            endDate: DateTime(2024, 3, 7),
          )).called(1);
    });

    test('updateTrip returns updated trip', () async {
      // Arrange
      final updatedTrip = testTrip.copyWith(
        title: 'Tokyo Trip Updated',
        updatedAt: DateTime(2024, 2, 15),
      );
      when(() => repository.updateTrip(updatedTrip))
          .thenAnswer((_) async => updatedTrip);

      // Act
      final result = await repository.updateTrip(updatedTrip);

      // Assert
      expect(result.title, 'Tokyo Trip Updated');
      expect(result.id, testTrip.id);
      verify(() => repository.updateTrip(updatedTrip)).called(1);
    });

    test('deleteTrip completes successfully', () async {
      // Arrange
      when(() => repository.deleteTrip(1))
          .thenAnswer((_) async => {});

      // Act
      await repository.deleteTrip(1);

      // Assert
      verify(() => repository.deleteTrip(1)).called(1);
    });

    test('watchAllTrips returns stream of trips', () async {
      // Arrange
      when(() => repository.watchAllTrips())
          .thenAnswer((_) => Stream.value([testTrip]));

      // Act
      final stream = repository.watchAllTrips();

      // Assert
      expect(stream, isA<Stream<List<Trip>>>());
      await expectLater(
        stream,
        emits([testTrip]),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';
import 'package:trip_wallet/features/trip/domain/usecases/get_trips.dart';

class MockTripRepository extends Mock implements TripRepository {}

void main() {
  late GetTrips useCase;
  late MockTripRepository mockRepository;

  setUp(() {
    mockRepository = MockTripRepository();
    useCase = GetTrips(mockRepository);
  });

  group('GetTrips', () {
    final testTrips = [
      Trip(
        id: 1,
        title: 'Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 500000.0,
        startDate: DateTime(2024, 3, 1),
        endDate: DateTime(2024, 3, 7),
        createdAt: DateTime(2024, 2, 1),
        updatedAt: DateTime(2024, 2, 1),
      ),
      Trip(
        id: 2,
        title: 'Paris Trip',
        baseCurrency: 'EUR',
        budget: 2000.0,
        startDate: DateTime(2024, 5, 1),
        endDate: DateTime(2024, 5, 10),
        createdAt: DateTime(2024, 4, 1),
        updatedAt: DateTime(2024, 4, 1),
      ),
    ];

    test('should get all trips from repository', () async {
      // Arrange
      when(() => mockRepository.getAllTrips())
          .thenAnswer((_) async => testTrips);

      // Act
      final result = await useCase();

      // Assert
      expect(result, testTrips);
      verify(() => mockRepository.getAllTrips()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no trips exist', () async {
      // Arrange
      when(() => mockRepository.getAllTrips())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAllTrips()).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.getAllTrips()).thenThrow(exception);

      // Act & Assert
      expect(() => useCase(), throwsA(exception));
      verify(() => mockRepository.getAllTrips()).called(1);
    });
  });
}

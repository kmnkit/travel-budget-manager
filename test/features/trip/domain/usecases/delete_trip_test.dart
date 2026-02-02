import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';
import 'package:trip_wallet/features/trip/domain/usecases/delete_trip.dart';

class MockTripRepository extends Mock implements TripRepository {}

void main() {
  late DeleteTrip useCase;
  late MockTripRepository mockRepository;

  setUp(() {
    mockRepository = MockTripRepository();
    useCase = DeleteTrip(mockRepository);
  });

  group('DeleteTrip', () {
    test('should delete trip by id', () async {
      // Arrange
      when(() => mockRepository.deleteTrip(1))
          .thenAnswer((_) async => {});

      // Act
      await useCase(1);

      // Assert
      verify(() => mockRepository.deleteTrip(1)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      final exception = Exception('Trip not found');
      when(() => mockRepository.deleteTrip(999))
          .thenThrow(exception);

      // Act & Assert
      expect(() => useCase(999), throwsA(exception));
      verify(() => mockRepository.deleteTrip(999)).called(1);
    });

    test('should handle deletion of non-existent trip', () async {
      // Arrange
      when(() => mockRepository.deleteTrip(999))
          .thenAnswer((_) async => {}); // No-op for non-existent trip

      // Act
      await useCase(999);

      // Assert
      verify(() => mockRepository.deleteTrip(999)).called(1);
    });
  });
}

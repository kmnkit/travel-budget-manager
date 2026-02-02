import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';
import 'package:trip_wallet/features/trip/domain/usecases/update_trip.dart';

class MockTripRepository extends Mock implements TripRepository {}

void main() {
  late UpdateTrip useCase;
  late MockTripRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(Trip(
      id: 0,
      title: 'fallback',
      baseCurrency: 'USD',
      budget: 1.0,
      startDate: DateTime(2024),
      endDate: DateTime(2024, 1, 2),
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    ));
  });

  setUp(() {
    mockRepository = MockTripRepository();
    useCase = UpdateTrip(mockRepository);
  });

  group('UpdateTrip', () {
    final originalTrip = Trip(
      id: 1,
      title: 'Tokyo Trip',
      baseCurrency: 'JPY',
      budget: 500000.0,
      startDate: DateTime(2024, 3, 1),
      endDate: DateTime(2024, 3, 7),
      createdAt: DateTime(2024, 2, 1),
      updatedAt: DateTime(2024, 2, 1),
    );

    test('should update trip with valid data', () async {
      // Arrange
      final updatedTrip = originalTrip.copyWith(
        title: 'Tokyo Trip Updated',
        updatedAt: DateTime(2024, 2, 15),
      );
      when(() => mockRepository.updateTrip(updatedTrip))
          .thenAnswer((_) async => updatedTrip);

      // Act
      final result = await useCase(updatedTrip);

      // Assert
      expect(result, updatedTrip);
      expect(result.title, 'Tokyo Trip Updated');
      verify(() => mockRepository.updateTrip(updatedTrip)).called(1);
    });

    test('should throw ArgumentError when title is empty', () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(title: '');

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Title cannot be empty',
        )),
      );
      verifyNever(() => mockRepository.updateTrip(any()));
    });

    test('should throw ArgumentError when title is whitespace only', () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(title: '   ');

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Title cannot be empty',
        )),
      );
    });

    test('should throw ArgumentError when title is too long', () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(title: 'a' * 101);

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Title must be 100 characters or less',
        )),
      );
    });

    test('should throw ArgumentError when baseCurrency is not 3 characters',
        () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(baseCurrency: 'US');

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Base currency must be a 3-letter code',
        )),
      );
    });

    test('should throw ArgumentError when budget is negative', () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(budget: -100.0);

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Budget must be positive',
        )),
      );
    });

    test('should throw ArgumentError when budget is zero', () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(budget: 0.0);

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Budget must be positive',
        )),
      );
    });

    test('should throw ArgumentError when endDate is before startDate',
        () async {
      // Arrange
      final invalidTrip = originalTrip.copyWith(
        startDate: DateTime(2024, 3, 7),
        endDate: DateTime(2024, 3, 1),
      );

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'End date must be after start date',
        )),
      );
    });

    test('should throw ArgumentError when endDate equals startDate', () async {
      // Arrange
      final sameDate = DateTime(2024, 3, 1);
      final invalidTrip = originalTrip.copyWith(
        startDate: sameDate,
        endDate: sameDate,
      );

      // Act & Assert
      expect(
        () => useCase(invalidTrip),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'End date must be after start date',
        )),
      );
    });

    test('should accept maximum valid title length (100 characters)',
        () async {
      // Arrange
      final maxTitle = 'a' * 100;
      final validTrip = originalTrip.copyWith(title: maxTitle);
      when(() => mockRepository.updateTrip(any()))
          .thenAnswer((_) async => validTrip);

      // Act
      final result = await useCase(validTrip);

      // Assert
      expect(result.title, maxTitle);
      verify(() => mockRepository.updateTrip(any())).called(1);
    });

    test('should update all trip fields correctly', () async {
      // Arrange
      final updatedTrip = originalTrip.copyWith(
        title: 'New Title',
        baseCurrency: 'USD',
        budget: 3000.0,
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 15),
      );
      when(() => mockRepository.updateTrip(any()))
          .thenAnswer((_) async => updatedTrip);

      // Act
      final result = await useCase(updatedTrip);

      // Assert
      expect(result.title, 'New Title');
      expect(result.baseCurrency, 'USD');
      expect(result.budget, 3000.0);
      expect(result.startDate, DateTime(2024, 6, 1));
      expect(result.endDate, DateTime(2024, 6, 15));
      verify(() => mockRepository.updateTrip(any())).called(1);
    });
  });
}

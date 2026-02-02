import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';
import 'package:trip_wallet/features/trip/domain/usecases/create_trip.dart';

class MockTripRepository extends Mock implements TripRepository {}

void main() {
  late CreateTrip useCase;
  late MockTripRepository mockRepository;

  setUp(() {
    mockRepository = MockTripRepository();
    useCase = CreateTrip(mockRepository);
  });

  group('CreateTrip', () {
    final startDate = DateTime(2024, 3, 1);
    final endDate = DateTime(2024, 3, 7);
    final createdTrip = Trip(
      id: 1,
      title: 'Tokyo Trip',
      baseCurrency: 'JPY',
      budget: 500000.0,
      startDate: startDate,
      endDate: endDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('should create trip with valid data', () async {
      // Arrange
      when(() => mockRepository.createTrip(
            title: 'Tokyo Trip',
            baseCurrency: 'JPY',
            budget: 500000.0,
            startDate: startDate,
            endDate: endDate,
          )).thenAnswer((_) async => createdTrip);

      // Act
      final result = await useCase(
        title: 'Tokyo Trip',
        baseCurrency: 'JPY',
        budget: 500000.0,
        startDate: startDate,
        endDate: endDate,
      );

      // Assert
      expect(result, createdTrip);
      verify(() => mockRepository.createTrip(
            title: 'Tokyo Trip',
            baseCurrency: 'JPY',
            budget: 500000.0,
            startDate: startDate,
            endDate: endDate,
          )).called(1);
    });

    test('should throw ArgumentError when title is empty', () async {
      // Act & Assert
      expect(
        () => useCase(
          title: '',
          baseCurrency: 'JPY',
          budget: 500000.0,
          startDate: startDate,
          endDate: endDate,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Title cannot be empty',
        )),
      );
      verifyNever(() => mockRepository.createTrip(
            title: any(named: 'title'),
            baseCurrency: any(named: 'baseCurrency'),
            budget: any(named: 'budget'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ));
    });

    test('should throw ArgumentError when title is too long', () async {
      // Act & Assert
      expect(
        () => useCase(
          title: 'a' * 101, // 101 characters
          baseCurrency: 'JPY',
          budget: 500000.0,
          startDate: startDate,
          endDate: endDate,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Title must be 100 characters or less',
        )),
      );
    });

    test('should throw ArgumentError when baseCurrency is not 3 characters',
        () async {
      // Act & Assert
      expect(
        () => useCase(
          title: 'Tokyo Trip',
          baseCurrency: 'US',
          budget: 500000.0,
          startDate: startDate,
          endDate: endDate,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Base currency must be a 3-letter code',
        )),
      );
    });

    test('should throw ArgumentError when budget is negative', () async {
      // Act & Assert
      expect(
        () => useCase(
          title: 'Tokyo Trip',
          baseCurrency: 'JPY',
          budget: -100.0,
          startDate: startDate,
          endDate: endDate,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Budget must be positive',
        )),
      );
    });

    test('should throw ArgumentError when budget is zero', () async {
      // Act & Assert
      expect(
        () => useCase(
          title: 'Tokyo Trip',
          baseCurrency: 'JPY',
          budget: 0.0,
          startDate: startDate,
          endDate: endDate,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Budget must be positive',
        )),
      );
    });

    test('should throw ArgumentError when endDate is before startDate',
        () async {
      // Act & Assert
      expect(
        () => useCase(
          title: 'Tokyo Trip',
          baseCurrency: 'JPY',
          budget: 500000.0,
          startDate: endDate,
          endDate: startDate, // reversed dates
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'End date must be after start date',
        )),
      );
    });

    test('should throw ArgumentError when endDate equals startDate', () async {
      // Act & Assert
      expect(
        () => useCase(
          title: 'Tokyo Trip',
          baseCurrency: 'JPY',
          budget: 500000.0,
          startDate: startDate,
          endDate: startDate, // same date
        ),
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
      final tripWithMaxTitle = createdTrip.copyWith(title: maxTitle);
      when(() => mockRepository.createTrip(
            title: maxTitle,
            baseCurrency: 'JPY',
            budget: 500000.0,
            startDate: startDate,
            endDate: endDate,
          )).thenAnswer((_) async => tripWithMaxTitle);

      // Act
      final result = await useCase(
        title: maxTitle,
        baseCurrency: 'JPY',
        budget: 500000.0,
        startDate: startDate,
        endDate: endDate,
      );

      // Assert
      expect(result.title, maxTitle);
      verify(() => mockRepository.createTrip(
            title: maxTitle,
            baseCurrency: 'JPY',
            budget: 500000.0,
            startDate: startDate,
            endDate: endDate,
          )).called(1);
    });
  });
}

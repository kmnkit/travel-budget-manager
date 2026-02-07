import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/consent/data/datasources/consent_local_datasource.dart';
import 'package:trip_wallet/features/consent/data/repositories/consent_repository_impl.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_status.dart';

class MockConsentLocalDataSource extends Mock implements ConsentLocalDataSource {}

void main() {
  late MockConsentLocalDataSource mockDataSource;
  late ConsentRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const ConsentStatus(
      analyticsConsent: false,
      personalizedAdsConsent: false,
      attGranted: false,
      consentDate: null,
    ));
  });

  setUp(() {
    mockDataSource = MockConsentLocalDataSource();
    repository = ConsentRepositoryImpl(mockDataSource);
  });

  group('ConsentRepositoryImpl', () {
    group('getConsentStatus', () {
      test('should return ConsentStatus from datasource', () async {
        // Arrange
        final consentDate = DateTime(2024, 1, 1);
        final expectedStatus = ConsentStatus(
          analyticsConsent: true,
          personalizedAdsConsent: false,
          attGranted: true,
          consentDate: consentDate,
        );
        when(() => mockDataSource.getConsentStatus())
            .thenAnswer((_) async => expectedStatus);

        // Act
        final result = await repository.getConsentStatus();

        // Assert
        expect(result, expectedStatus);
        verify(() => mockDataSource.getConsentStatus()).called(1);
      });

      test('should return null when no consent saved', () async {
        // Arrange
        when(() => mockDataSource.getConsentStatus())
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getConsentStatus();

        // Assert
        expect(result, isNull);
        verify(() => mockDataSource.getConsentStatus()).called(1);
      });
    });

    group('saveConsentStatus', () {
      test('should call datasource to save consent status', () async {
        // Arrange
        final consentDate = DateTime(2024, 1, 1);
        final status = ConsentStatus(
          analyticsConsent: true,
          personalizedAdsConsent: true,
          attGranted: false,
          consentDate: consentDate,
        );
        when(() => mockDataSource.saveConsentStatus(any()))
            .thenAnswer((_) async {});

        // Act
        await repository.saveConsentStatus(status);

        // Assert
        verify(() => mockDataSource.saveConsentStatus(status)).called(1);
      });

      test('should save consent with null date', () async {
        // Arrange
        final status = ConsentStatus(
          analyticsConsent: false,
          personalizedAdsConsent: false,
          attGranted: false,
          consentDate: null,
        );
        when(() => mockDataSource.saveConsentStatus(any()))
            .thenAnswer((_) async {});

        // Act
        await repository.saveConsentStatus(status);

        // Assert
        verify(() => mockDataSource.saveConsentStatus(status)).called(1);
      });
    });

    group('isConsentCompleted', () {
      test('should return true when consent is saved', () async {
        // Arrange
        when(() => mockDataSource.isConsentCompleted())
            .thenAnswer((_) async => true);

        // Act
        final result = await repository.isConsentCompleted();

        // Assert
        expect(result, true);
        verify(() => mockDataSource.isConsentCompleted()).called(1);
      });

      test('should return false when consent is not saved', () async {
        // Arrange
        when(() => mockDataSource.isConsentCompleted())
            .thenAnswer((_) async => false);

        // Act
        final result = await repository.isConsentCompleted();

        // Assert
        expect(result, false);
        verify(() => mockDataSource.isConsentCompleted()).called(1);
      });
    });

    group('clearConsent', () {
      test('should call datasource to clear consent (GDPR deletion)', () async {
        // Arrange
        when(() => mockDataSource.clearConsent()).thenAnswer((_) async {});

        // Act
        await repository.clearConsent();

        // Assert
        verify(() => mockDataSource.clearConsent()).called(1);
      });
    });
  });
}

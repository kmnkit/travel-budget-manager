import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_status.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';

class MockConsentRepository extends Mock implements ConsentRepository {}

void main() {
  late MockConsentRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const ConsentStatus(
      analyticsConsent: false,
      personalizedAdsConsent: false,
      attGranted: false,
      consentDate: null,
    ));
  });

  setUp(() {
    mockRepository = MockConsentRepository();
    container = ProviderContainer(
      overrides: [
        consentRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('consentCompletedProvider', () {
    test('should return true when consent is completed', () async {
      // Arrange
      when(() => mockRepository.isConsentCompleted())
          .thenAnswer((_) async => true);

      // Act
      final result = await container.read(consentCompletedProvider.future);

      // Assert
      expect(result, true);
      verify(() => mockRepository.isConsentCompleted()).called(1);
    });

    test('should return false when consent is not completed', () async {
      // Arrange
      when(() => mockRepository.isConsentCompleted())
          .thenAnswer((_) async => false);

      // Act
      final result = await container.read(consentCompletedProvider.future);

      // Assert
      expect(result, false);
      verify(() => mockRepository.isConsentCompleted()).called(1);
    });
  });

  group('consentStatusProvider', () {
    test('should return ConsentStatus when saved', () async {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final expectedStatus = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => expectedStatus);

      // Act
      final result = await container.read(consentStatusProvider.future);

      // Assert
      expect(result, expectedStatus);
      verify(() => mockRepository.getConsentStatus()).called(1);
    });

    test('should return null when no consent saved', () async {
      // Arrange
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => null);

      // Act
      final result = await container.read(consentStatusProvider.future);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getConsentStatus()).called(1);
    });
  });

  group('ConsentNotifier', () {
    test('should initialize with loading state and then load consent', () async {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final expectedStatus = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => expectedStatus);

      // Act
      container.read(consentNotifierProvider.notifier);

      // Wait for async initialization
      await Future.delayed(Duration.zero);

      // Assert
      final state = container.read(consentNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, expectedStatus);
      verify(() => mockRepository.getConsentStatus()).called(1);
    });

    test('should handle error when loading consent fails', () async {
      // Arrange
      final error = Exception('Failed to load');
      when(() => mockRepository.getConsentStatus()).thenAnswer((_) async => throw error);

      // Act
      container.read(consentNotifierProvider.notifier);

      // Wait for async initialization
      await Future.delayed(Duration.zero);

      // Assert
      final state = container.read(consentNotifierProvider);
      expect(state.hasError, true);
      expect(state.error, error);
    });

    test('should save consent status successfully', () async {
      // Arrange
      // Initial load returns null
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => null);
      when(() => mockRepository.saveConsentStatus(any()))
          .thenAnswer((_) async {});

      // Act
      final notifier = container.read(consentNotifierProvider.notifier);
      await notifier.saveConsent(
        analyticsConsent: true,
        personalizedAdsConsent: false,
      );

      // Assert
      verify(() => mockRepository.saveConsentStatus(any())).called(1);

      final state = container.read(consentNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value?.analyticsConsent, true);
      expect(state.value?.personalizedAdsConsent, false);
      expect(state.value?.attGranted, false); // Non-iOS defaults to false
      expect(state.value?.consentDate, isNotNull);
    });

    test('should handle error when saving consent fails', () async {
      // Arrange
      final error = Exception('Failed to save');
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => null);
      when(() => mockRepository.saveConsentStatus(any())).thenAnswer((_) async => throw error);

      // Act
      final notifier = container.read(consentNotifierProvider.notifier);
      await notifier.saveConsent(
        analyticsConsent: true,
        personalizedAdsConsent: false,
      );

      // Assert
      final state = container.read(consentNotifierProvider);
      expect(state.hasError, true);
      expect(state.error, error);
    });

    test('should clear consent successfully', () async {
      // Arrange
      final initialStatus = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: DateTime(2024, 1, 1),
      );

      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => initialStatus);
      when(() => mockRepository.clearConsent()).thenAnswer((_) async {});

      // Act
      final notifier = container.read(consentNotifierProvider.notifier);

      // Wait for initial load
      await Future.delayed(Duration.zero);

      await notifier.clearConsent();

      // Assert
      verify(() => mockRepository.clearConsent()).called(1);

      final state = container.read(consentNotifierProvider);
      expect(state.hasValue, true);
      expect(state.value, isNull);
    });

    test('should handle error when clearing consent fails', () async {
      // Arrange
      final error = Exception('Failed to clear');
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => null);
      when(() => mockRepository.clearConsent()).thenAnswer((_) async => throw error);

      // Act
      final notifier = container.read(consentNotifierProvider.notifier);
      await notifier.clearConsent();

      // Assert
      final state = container.read(consentNotifierProvider);
      expect(state.hasError, true);
      expect(state.error, error);
    });

    test('should invalidate related providers after saving consent', () async {
      // Arrange
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => null);
      when(() => mockRepository.saveConsentStatus(any()))
          .thenAnswer((_) async {});
      when(() => mockRepository.isConsentCompleted())
          .thenAnswer((_) async => true);

      // Act
      final notifier = container.read(consentNotifierProvider.notifier);
      await notifier.saveConsent(
        analyticsConsent: true,
        personalizedAdsConsent: true,
      );

      // Read the invalidated providers to verify they fetch fresh data
      final isCompleted = await container.read(consentCompletedProvider.future);

      // Assert
      expect(isCompleted, true);
      // Verify repository methods were called
      verify(() => mockRepository.saveConsentStatus(any())).called(1);
      verify(() => mockRepository.isConsentCompleted()).called(1);
    });

    test('should invalidate related providers after clearing consent', () async {
      // Arrange
      when(() => mockRepository.getConsentStatus())
          .thenAnswer((_) async => null);
      when(() => mockRepository.clearConsent()).thenAnswer((_) async {});
      when(() => mockRepository.isConsentCompleted())
          .thenAnswer((_) async => false);

      // Act
      final notifier = container.read(consentNotifierProvider.notifier);
      await notifier.clearConsent();

      // Read the invalidated providers to verify they fetch fresh data
      final isCompleted = await container.read(consentCompletedProvider.future);

      // Assert
      expect(isCompleted, false);
      verify(() => mockRepository.clearConsent()).called(1);
      verify(() => mockRepository.isConsentCompleted()).called(1);
    });
  });
}

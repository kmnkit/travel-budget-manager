import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:trip_wallet/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_record.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class MockConsentRepository extends Mock implements ConsentRepository {}

void main() {
  group('Analytics Providers', () {
    late ProviderContainer container;
    late MockFirebaseAnalytics mockFirebaseAnalytics;
    late MockAnalyticsRepository mockAnalyticsRepo;
    late MockConsentRepository mockConsentRepo;

    setUp(() {
      mockFirebaseAnalytics = MockFirebaseAnalytics();
      mockAnalyticsRepo = MockAnalyticsRepository();
      mockConsentRepo = MockConsentRepository();

      container = ProviderContainer(
        overrides: [
          firebaseAnalyticsProvider.overrideWithValue(mockFirebaseAnalytics),
          analyticsRepositoryProvider.overrideWithValue(mockAnalyticsRepo),
          consentRepositoryProvider.overrideWithValue(mockConsentRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('firebaseAnalyticsProvider', () {
      test('provides FirebaseAnalytics instance', () {
        final analytics = container.read(firebaseAnalyticsProvider);
        expect(analytics, isA<FirebaseAnalytics>());
      });
    });

    group('analyticsRepositoryProvider', () {
      test('provides AnalyticsRepository instance', () {
        final repo = container.read(analyticsRepositoryProvider);
        expect(repo, isA<AnalyticsRepository>());
      });
    });

    group('analyticsInitializerProvider', () {
      test('enables analytics when user has consented', () async {
        // Arrange
        final consentRecord = ConsentRecord(
          isAccepted: true,
          acceptedAt: DateTime.now(),
          policyVersion: '1.0',
        );
        when(() => mockConsentRepo.getConsentRecord())
            .thenAnswer((_) async => consentRecord);
        when(() => mockAnalyticsRepo.setAnalyticsEnabled(true))
            .thenAnswer((_) async {});

        // Act
        await container.read(analyticsInitializerProvider.future);

        // Assert
        verify(() => mockAnalyticsRepo.setAnalyticsEnabled(true)).called(1);
      });

      test('disables analytics when user has not consented', () async {
        // Arrange
        final consentRecord = ConsentRecord(
          isAccepted: false,
          acceptedAt: null,
          policyVersion: '',
        );
        when(() => mockConsentRepo.getConsentRecord())
            .thenAnswer((_) async => consentRecord);
        when(() => mockAnalyticsRepo.setAnalyticsEnabled(false))
            .thenAnswer((_) async {});

        // Act
        await container.read(analyticsInitializerProvider.future);

        // Assert
        verify(() => mockAnalyticsRepo.setAnalyticsEnabled(false)).called(1);
      });

      test('disables analytics when consent record is null', () async {
        // Arrange
        const consentRecord = ConsentRecord(
          isAccepted: false,
          acceptedAt: null,
          policyVersion: '',
        );
        when(() => mockConsentRepo.getConsentRecord())
            .thenAnswer((_) async => consentRecord);
        when(() => mockAnalyticsRepo.setAnalyticsEnabled(false))
            .thenAnswer((_) async {});

        // Act
        await container.read(analyticsInitializerProvider.future);

        // Assert
        verify(() => mockAnalyticsRepo.setAnalyticsEnabled(false)).called(1);
      });
    });
  });
}

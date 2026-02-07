import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/analytics/data/repositories/analytics_repository_impl.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late AnalyticsRepositoryImpl repository;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    repository = AnalyticsRepositoryImpl(mockAnalytics);

    // Default stub to allow all calls unless overridden
    when(() => mockAnalytics.setAnalyticsCollectionEnabled(any()))
        .thenAnswer((_) async {});
    when(() => mockAnalytics.logScreenView(screenName: any(named: 'screenName')))
        .thenAnswer((_) async {});
    when(() => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        )).thenAnswer((_) async {});
    when(() => mockAnalytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        )).thenAnswer((_) async {});
    when(() => mockAnalytics.resetAnalyticsData()).thenAnswer((_) async {});
  });

  group('AnalyticsRepositoryImpl', () {
    group('setAnalyticsEnabled', () {
      test('should enable Firebase Analytics collection', () async {
        // Act
        await repository.setAnalyticsEnabled(true);

        // Assert
        verify(() => mockAnalytics.setAnalyticsCollectionEnabled(true))
            .called(1);
      });

      test('should disable Firebase Analytics collection', () async {
        // Act
        await repository.setAnalyticsEnabled(false);

        // Assert
        verify(() => mockAnalytics.setAnalyticsCollectionEnabled(false))
            .called(1);
      });
    });

    group('logScreenView', () {
      test('should log screen view when analytics is enabled', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);

        // Act
        await repository.logScreenView('trip_list');

        // Assert
        verify(() => mockAnalytics.logScreenView(screenName: 'trip_list'))
            .called(1);
      });

      test('should NOT log screen view when analytics is disabled', () async {
        // Arrange
        await repository.setAnalyticsEnabled(false);
        reset(mockAnalytics);

        // Act
        await repository.logScreenView('trip_list');

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(
            screenName: any(named: 'screenName')));
      });
    });

    group('logEvent', () {
      test('should log event when analytics is enabled', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final parameters = {'category': 'food', 'count': 5};

        // Act
        await repository.logEvent('add_expense', parameters);

        // Assert
        verify(() => mockAnalytics.logEvent(
              name: 'add_expense',
              parameters: parameters,
            )).called(1);
      });

      test('should NOT log event when analytics is disabled', () async {
        // Arrange
        await repository.setAnalyticsEnabled(false);
        reset(mockAnalytics);

        // Act
        await repository.logEvent('add_expense', {'category': 'food'});

        // Assert
        verifyNever(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            ));
      });

      test('should sanitize blocked parameters before logging', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final parameters = {
          'category': 'food',
          'amount': 15000, // BLOCKED
          'trip_name': 'Tokyo', // BLOCKED
          'count': 5,
        };

        // Act
        await repository.logEvent('add_expense', parameters);

        // Assert
        verify(() => mockAnalytics.logEvent(
              name: 'add_expense',
              parameters: {'category': 'food', 'count': 5},
            )).called(1);
      });

      test('should handle parameters with only blocked keys', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final parameters = {
          'amount': 15000,
          'budget': 100000,
          'email': 'test@example.com',
        };

        // Act
        await repository.logEvent('test_event', parameters);

        // Assert
        verify(() => mockAnalytics.logEvent(
              name: 'test_event',
              parameters: null, // All parameters filtered out
            )).called(1);
      });

      test('should handle null parameters', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);

        // Act
        await repository.logEvent('test_event', null);

        // Assert
        verify(() => mockAnalytics.logEvent(
              name: 'test_event',
              parameters: null,
            )).called(1);
      });

      test('should block all privacy-sensitive parameter keys', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final blockedParameters = {
          'amount': 100,
          'budget': 1000,
          'destination': 'Tokyo',
          'location': 'Seoul',
          'name': 'John',
          'email': 'test@test.com',
          'phone': '010-1234-5678',
          'card': '1234',
          'account': '5678',
          'trip_name': 'My Trip',
          'memo': 'Note',
          'note': 'Detail',
          'title': 'Title',
        };

        // Act
        await repository.logEvent('test_event', blockedParameters);

        // Assert - all parameters should be filtered out
        verify(() => mockAnalytics.logEvent(
              name: 'test_event',
              parameters: null,
            )).called(1);
      });

      test('should be case-insensitive for blocked parameters', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final parameters = {
          'AMOUNT': 100,
          'Budget': 1000,
          'TRIP_NAME': 'Tokyo', // matches 'trip_name' when lowercased
          'category': 'food', // allowed
        };

        // Act
        await repository.logEvent('test_event', parameters);

        // Assert - only 'category' should remain
        verify(() => mockAnalytics.logEvent(
              name: 'test_event',
              parameters: {'category': 'food'},
            )).called(1);
      });
    });

    group('setUserProperty', () {
      test('should set allowed user property when analytics is enabled',
          () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);

        // Act
        await repository.setUserProperty('preferred_currency', 'KRW');

        // Assert
        verify(() => mockAnalytics.setUserProperty(
              name: 'preferred_currency',
              value: 'KRW',
            )).called(1);
      });

      test('should NOT set user property when analytics is disabled',
          () async {
        // Arrange
        await repository.setAnalyticsEnabled(false);
        reset(mockAnalytics);

        // Act
        await repository.setUserProperty('preferred_currency', 'KRW');

        // Assert
        verifyNever(() => mockAnalytics.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            ));
      });

      test('should NOT set blocked user property even when enabled', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        reset(mockAnalytics);

        // Act - trying to set blocked properties
        await repository.setUserProperty('name', 'John');
        await repository.setUserProperty('email', 'test@test.com');
        await repository.setUserProperty('amount', '1000');

        // Assert
        verifyNever(() => mockAnalytics.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            ));
      });

      test('should be case-insensitive for blocked user properties',
          () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        reset(mockAnalytics);

        // Act
        await repository.setUserProperty('NAME', 'John');
        await repository.setUserProperty('Email', 'test@test.com');

        // Assert
        verifyNever(() => mockAnalytics.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            ));
      });
    });

    group('resetAnalyticsData', () {
      test('should reset Firebase Analytics data', () async {
        // Act
        await repository.resetAnalyticsData();

        // Assert
        verify(() => mockAnalytics.resetAnalyticsData()).called(1);
      });
    });

    group('privacy enforcement', () {
      test('should never log any financial data', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final financialParameters = {
          'amount': 15000,
          'budget': 100000,
          'card': '1234-5678',
          'account': '9999',
        };

        // Act
        await repository.logEvent('payment', financialParameters);

        // Assert - all financial parameters blocked
        verify(() => mockAnalytics.logEvent(
              name: 'payment',
              parameters: null,
            )).called(1);
      });

      test('should never log any personal data', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final personalParameters = {
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': '010-1234-5678',
          'location': 'Seoul',
        };

        // Act
        await repository.logEvent('user_action', personalParameters);

        // Assert - all personal parameters blocked
        verify(() => mockAnalytics.logEvent(
              name: 'user_action',
              parameters: null,
            )).called(1);
      });

      test('should never log trip-specific identifiable data', () async {
        // Arrange
        await repository.setAnalyticsEnabled(true);
        final tripParameters = {
          'trip_name': 'Tokyo Summer 2024',
          'destination': 'Tokyo',
          'memo': 'Personal note',
          'title': 'My Trip',
        };

        // Act
        await repository.logEvent('trip_event', tripParameters);

        // Assert - all trip-specific parameters blocked
        verify(() => mockAnalytics.logEvent(
              name: 'trip_event',
              parameters: null,
            )).called(1);
      });
    });
  });
}

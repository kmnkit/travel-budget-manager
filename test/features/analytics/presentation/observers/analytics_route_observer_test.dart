import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:trip_wallet/features/analytics/presentation/observers/analytics_route_observer.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class MockRoute extends Mock implements Route<dynamic> {}

void main() {
  group('AnalyticsRouteObserver', () {
    late AnalyticsRouteObserver observer;
    late MockAnalyticsRepository mockAnalytics;

    setUp(() {
      mockAnalytics = MockAnalyticsRepository();
      observer = AnalyticsRouteObserver(mockAnalytics);

      // Setup default behavior for logScreenView
      when(() => mockAnalytics.logScreenView(any()))
          .thenAnswer((_) async {});
    });

    group('didPush', () {
      test('logs screen view when route has a name', () {
        // Arrange
        final route = MockRoute();
        final settings = const RouteSettings(name: '/home');
        when(() => route.settings).thenReturn(settings);

        // Act
        observer.didPush(route, null);

        // Assert
        verify(() => mockAnalytics.logScreenView('/home')).called(1);
      });

      test('does not log screen view when route name is null', () {
        // Arrange
        final route = MockRoute();
        final settings = const RouteSettings(name: null);
        when(() => route.settings).thenReturn(settings);

        // Act
        observer.didPush(route, null);

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(any()));
      });

      test('does not log screen view when route name is empty', () {
        // Arrange
        final route = MockRoute();
        final settings = const RouteSettings(name: '');
        when(() => route.settings).thenReturn(settings);

        // Act
        observer.didPush(route, null);

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(any()));
      });
    });

    group('didReplace', () {
      test('logs screen view for new route when it has a name', () {
        // Arrange
        final newRoute = MockRoute();
        final oldRoute = MockRoute();
        final settings = const RouteSettings(name: '/settings');
        when(() => newRoute.settings).thenReturn(settings);

        // Act
        observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);

        // Assert
        verify(() => mockAnalytics.logScreenView('/settings')).called(1);
      });

      test('does not log when new route is null', () {
        // Arrange
        final oldRoute = MockRoute();

        // Act
        observer.didReplace(newRoute: null, oldRoute: oldRoute);

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(any()));
      });

      test('does not log when new route name is empty', () {
        // Arrange
        final newRoute = MockRoute();
        final oldRoute = MockRoute();
        final settings = const RouteSettings(name: '');
        when(() => newRoute.settings).thenReturn(settings);

        // Act
        observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(any()));
      });
    });

    group('didPop', () {
      test('logs screen view for previous route when it exists', () {
        // Arrange
        final route = MockRoute();
        final previousRoute = MockRoute();
        final settings = const RouteSettings(name: '/profile');
        when(() => previousRoute.settings).thenReturn(settings);

        // Act
        observer.didPop(route, previousRoute);

        // Assert
        verify(() => mockAnalytics.logScreenView('/profile')).called(1);
      });

      test('does not log when previous route is null', () {
        // Arrange
        final route = MockRoute();

        // Act
        observer.didPop(route, null);

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(any()));
      });

      test('does not log when previous route name is null', () {
        // Arrange
        final route = MockRoute();
        final previousRoute = MockRoute();
        final settings = const RouteSettings(name: null);
        when(() => previousRoute.settings).thenReturn(settings);

        // Act
        observer.didPop(route, previousRoute);

        // Assert
        verifyNever(() => mockAnalytics.logScreenView(any()));
      });
    });

    group('multiple navigation events', () {
      test('logs multiple screen views in sequence', () {
        // Arrange
        final route1 = MockRoute();
        final route2 = MockRoute();
        final route3 = MockRoute();

        when(() => route1.settings).thenReturn(const RouteSettings(name: '/home'));
        when(() => route2.settings).thenReturn(const RouteSettings(name: '/trips'));
        when(() => route3.settings).thenReturn(const RouteSettings(name: '/settings'));

        // Act
        observer.didPush(route1, null);
        observer.didPush(route2, route1);
        observer.didPop(route2, route1);

        // Assert
        verify(() => mockAnalytics.logScreenView('/home')).called(2); // push + pop return
        verify(() => mockAnalytics.logScreenView('/trips')).called(1); // push only
      });
    });
  });
}

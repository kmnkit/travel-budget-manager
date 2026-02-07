import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/ads/presentation/widgets/ad_banner_widget.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/features/trip/presentation/screens/home_screen.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

BudgetSummary _defaultBudgetSummary(int tripId) => BudgetSummary(
      tripId: tripId,
      totalBudget: 1000000.0,
      totalSpent: 0.0,
      remaining: 1000000.0,
      percentUsed: 0.0,
      status: BudgetStatus.comfortable,
      categoryBreakdown: const {},
      dailyAverage: 0.0,
      daysRemaining: 10,
      dailyBudgetRemaining: 100000.0,
    );

ProviderContainer _createContainer({
  required List<Trip> trips,
  required bool showAds,
}) {
  return ProviderContainer(
    overrides: [
      tripListProvider.overrideWith((ref) => Stream.value(trips)),
      filteredTripListProvider.overrideWith(
        (ref) => AsyncValue.data(trips),
      ),
      totalBalanceProvider.overrideWith(
        (ref) => Future.value((total: 0.0, currency: 'KRW')),
      ),
      shouldShowAdsProvider.overrideWith((ref) => showAds),
      budgetSummaryProvider.overrideWith(
        (ref, tripId) => Future.value(_defaultBudgetSummary(tripId)),
      ),
    ],
  );
}

Widget _buildTestWidget(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const HomeScreen(),
    ),
  );
}

void main() {
  final now = DateTime.now();

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock the google_mobile_ads platform channel to prevent MissingPluginException
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/google_mobile_ads');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/google_mobile_ads');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('HomeScreen Ad Integration', () {
    testWidgets('should show fixed top ad + interleave ads for non-premium users',
        (tester) async {
      // Arrange: Create 8 trips (1 fixed top + 2 interleave = 3 ads)
      final trips = List.generate(
        8,
        (i) => Trip(
          id: i + 1,
          title: 'Trip ${i + 1}',
          baseCurrency: 'KRW',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 10),
          budget: 1000000.0,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = _createContainer(trips: trips, showAds: true);

      // Use a large surface so ListView.builder renders enough items
      // and filter chips don't overflow
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildTestWidget(container));
      await tester.pumpAndSettle();

      // Assert: Should find 3 AdBannerWidget instances (1 fixed + 2 interleave)
      expect(find.byType(AdBannerWidget), findsNWidgets(3));
    });

    testWidgets('should NOT show ads for premium users', (tester) async {
      // Arrange
      final trips = List.generate(
        8,
        (i) => Trip(
          id: i + 1,
          title: 'Trip ${i + 1}',
          baseCurrency: 'KRW',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 10),
          budget: 1000000.0,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = _createContainer(trips: trips, showAds: false);

      await tester.pumpWidget(_buildTestWidget(container));
      await tester.pumpAndSettle();

      // Assert: Should find NO ads
      expect(find.byType(AdBannerWidget), findsNothing);
    });

    testWidgets('should show fixed top ad even with fewer than 4 trips', (tester) async {
      // Arrange: Only 3 trips (1 fixed top ad, no interleave)
      final trips = List.generate(
        3,
        (i) => Trip(
          id: i + 1,
          title: 'Trip ${i + 1}',
          baseCurrency: 'KRW',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 10),
          budget: 1000000.0,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = _createContainer(trips: trips, showAds: true);

      await tester.pumpWidget(_buildTestWidget(container));
      await tester.pumpAndSettle();

      // Assert: Should find 1 fixed top ad (no interleave ads)
      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('should handle empty trip list', (tester) async {
      // Arrange
      final container = _createContainer(trips: [], showAds: true);

      await tester.pumpWidget(_buildTestWidget(container));
      await tester.pumpAndSettle();

      // Assert: Should show empty state, no ads
      expect(find.byType(AdBannerWidget), findsNothing);
    });

    testWidgets('should calculate correct ad positions for exactly 4 trips',
        (tester) async {
      // Arrange: Exactly 4 trips (1 fixed top + 1 interleave = 2 ads)
      final trips = List.generate(
        4,
        (i) => Trip(
          id: i + 1,
          title: 'Trip ${i + 1}',
          baseCurrency: 'KRW',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 10),
          budget: 1000000.0,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final container = _createContainer(trips: trips, showAds: true);

      // Use a large surface so ListView.builder renders all items including the ad
      // and filter chips don't overflow
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildTestWidget(container));
      await tester.pumpAndSettle();

      // Assert: Should find 2 ads (1 fixed top + 1 interleave)
      expect(find.byType(AdBannerWidget), findsNWidgets(2));
    });
  });
}

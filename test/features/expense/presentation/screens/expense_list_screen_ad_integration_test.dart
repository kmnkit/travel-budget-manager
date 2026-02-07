import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/ads/presentation/widgets/ad_banner_widget.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/presentation/providers/expense_providers.dart';
import 'package:trip_wallet/features/expense/presentation/screens/expense_list_screen.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';

void main() {
  final now = DateTime.now();

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/google_mobile_ads');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  group('ExpenseListScreen Ad Integration', () {
    testWidgets('should show fixed top ad + interleave ads for non-premium users',
        (tester) async {
      // Use a large surface so ListView.builder renders all items
      tester.view.physicalSize = const Size(1080, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Arrange: Create 6 date groups (1 fixed top + 2 interleave = 3 ads)
      final expenses = List.generate(
        18, // 6 date groups * 3 expenses per day
        (i) => Expense(
          id: i + 1,
          tripId: 1,
          category: ExpenseCategory.food,
          amount: 10000.0,
          currency: 'KRW',
          convertedAmount: 10000.0,
          date: DateTime(2024, 1, 1 + (i ~/ 3)), // Different date every 3 expenses
          memo: 'Expense ${i + 1}',
          paymentMethodId: 1,
          createdAt: now,
        ),
      );

      final trip = Trip(
        id: 1,
        title: 'Test Trip',
        baseCurrency: 'KRW',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 10),
        budget: 1000000.0,
        createdAt: now,
        updatedAt: now,
      );

      final container = ProviderContainer(
        overrides: [
          expenseListProvider(1).overrideWith((ref) => Stream.value(expenses)),
          tripDetailProvider(1).overrideWith((ref) => Future.value(trip)),
          shouldShowAdsProvider.overrideWith((ref) => true), // Non-premium
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: ExpenseListScreen(tripId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should find 3 AdBannerWidget instances (1 fixed + 2 interleave)
      expect(find.byType(AdBannerWidget), findsNWidgets(3));
    });

    testWidgets('should NOT show ads for premium users', (tester) async {
      // Arrange
      final expenses = List.generate(
        18,
        (i) => Expense(
          id: i + 1,
          tripId: 1,
          category: ExpenseCategory.food,
          amount: 10000.0,
          currency: 'KRW',
          convertedAmount: 10000.0,
          date: DateTime(2024, 1, 1 + (i ~/ 3)),
          memo: 'Expense ${i + 1}',
          paymentMethodId: 1,
          createdAt: now,
        ),
      );

      final trip = Trip(
        id: 1,
        title: 'Test Trip',
        baseCurrency: 'KRW',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 10),
        budget: 1000000.0,
        createdAt: now,
        updatedAt: now,
      );

      final container = ProviderContainer(
        overrides: [
          expenseListProvider(1).overrideWith((ref) => Stream.value(expenses)),
          tripDetailProvider(1).overrideWith((ref) => Future.value(trip)),
          shouldShowAdsProvider.overrideWith((ref) => false), // Premium user
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: ExpenseListScreen(tripId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should find NO ads
      expect(find.byType(AdBannerWidget), findsNothing);
    });

    testWidgets('should show fixed top ad even with fewer than 3 date groups',
        (tester) async {
      // Arrange: Only 2 date groups (1 fixed top ad, no interleave)
      final expenses = List.generate(
        6, // 2 date groups * 3 expenses per day
        (i) => Expense(
          id: i + 1,
          tripId: 1,
          category: ExpenseCategory.food,
          amount: 10000.0,
          currency: 'KRW',
          convertedAmount: 10000.0,
          date: DateTime(2024, 1, 1 + (i ~/ 3)),
          memo: 'Expense ${i + 1}',
          paymentMethodId: 1,
          createdAt: now,
        ),
      );

      final trip = Trip(
        id: 1,
        title: 'Test Trip',
        baseCurrency: 'KRW',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 10),
        budget: 1000000.0,
        createdAt: now,
        updatedAt: now,
      );

      final container = ProviderContainer(
        overrides: [
          expenseListProvider(1).overrideWith((ref) => Stream.value(expenses)),
          tripDetailProvider(1).overrideWith((ref) => Future.value(trip)),
          shouldShowAdsProvider.overrideWith((ref) => true),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: ExpenseListScreen(tripId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should find 1 fixed top ad (no interleave ads)
      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('should handle empty expense list', (tester) async {
      // Arrange
      final trip = Trip(
        id: 1,
        title: 'Test Trip',
        baseCurrency: 'KRW',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 10),
        budget: 1000000.0,
        createdAt: now,
        updatedAt: now,
      );

      final container = ProviderContainer(
        overrides: [
          expenseListProvider(1).overrideWith((ref) => Stream.value([])),
          tripDetailProvider(1).overrideWith((ref) => Future.value(trip)),
          shouldShowAdsProvider.overrideWith((ref) => true),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: ExpenseListScreen(tripId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should show empty state, no ads
      expect(find.byType(AdBannerWidget), findsNothing);
      expect(find.text('지출을 기록해보세요!'), findsOneWidget);
    });

    testWidgets('should calculate correct ad positions for exactly 3 date groups',
        (tester) async {
      // Use a large surface so ListView.builder renders all items
      tester.view.physicalSize = const Size(1080, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Arrange: Exactly 3 date groups (1 fixed top + 1 interleave = 2 ads)
      final expenses = List.generate(
        9, // 3 date groups * 3 expenses per day
        (i) => Expense(
          id: i + 1,
          tripId: 1,
          category: ExpenseCategory.food,
          amount: 10000.0,
          currency: 'KRW',
          convertedAmount: 10000.0,
          date: DateTime(2024, 1, 1 + (i ~/ 3)),
          memo: 'Expense ${i + 1}',
          paymentMethodId: 1,
          createdAt: now,
        ),
      );

      final trip = Trip(
        id: 1,
        title: 'Test Trip',
        baseCurrency: 'KRW',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 10),
        budget: 1000000.0,
        createdAt: now,
        updatedAt: now,
      );

      final container = ProviderContainer(
        overrides: [
          expenseListProvider(1).overrideWith((ref) => Stream.value(expenses)),
          tripDetailProvider(1).overrideWith((ref) => Future.value(trip)),
          shouldShowAdsProvider.overrideWith((ref) => true),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: ExpenseListScreen(tripId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should find 2 ads (1 fixed top + 1 interleave)
      expect(find.byType(AdBannerWidget), findsNWidgets(2));
    });
  });
}

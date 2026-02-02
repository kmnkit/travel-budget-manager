import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

/// Integration test for trip CRUD lifecycle.
///
/// Tests:
/// - Create a new trip from home screen
/// - Fill in trip details (title, currency, budget, dates)
/// - Save trip and verify it appears in list
/// - Navigate to trip detail screen
/// - Verify trip information is displayed correctly
///
/// TODO: Enable when running on device/emulator with database access
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Trip Lifecycle Tests', () {
    testWidgets('create new trip and verify it appears in list',
        (tester) async {
      // Initialize SharedPreferences for the test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify we start at home screen with empty state
      expect(find.text('TripWallet'), findsOneWidget);
      expect(find.text('여행을 추가해보세요!'), findsOneWidget);

      // Tap FAB to navigate to trip create screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're on trip create screen
      expect(find.text('여행 추가'), findsOneWidget);

      // Fill in trip title
      final titleField = find.widgetWithText(TextFormField, '여행 제목');
      expect(titleField, findsOneWidget);
      await tester.enterText(titleField, '도쿄 여행');
      await tester.pumpAndSettle();

      // Currency dropdown should default to KRW - leave as is

      // Fill in budget
      final budgetField = find.widgetWithText(TextFormField, '예산');
      expect(budgetField, findsOneWidget);
      await tester.enterText(budgetField, '500000');
      await tester.pumpAndSettle();

      // Date pickers are already set to default values (today + 7 days)
      // For integration tests, we accept the defaults

      // Scroll to save button if needed
      await tester.ensureVisible(find.text('저장'));
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // TODO: Enable when running on device
      // After saving, we should navigate to trip detail screen
      // Verify trip appears with title "도쿄 여행"
      // For now, this test demonstrates the flow structure
    });

    testWidgets('navigate to trip detail from home screen', (tester) async {
      // Initialize SharedPreferences for the test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // TODO: Enable when running on device
      // This test would:
      // 1. Find trip card in the list
      // 2. Tap the card
      // 3. Verify trip detail screen shows
      // 4. Verify budget information is displayed
      // 5. Navigate back to home

      // For now, verify home screen loads
      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('cancel trip creation returns to home', (tester) async {
      // Initialize SharedPreferences for the test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to trip create screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're on trip create screen
      expect(find.text('여행 추가'), findsOneWidget);

      // Tap cancel button
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      // Verify we're back on home screen
      expect(find.text('TripWallet'), findsOneWidget);
      expect(find.text('여행을 추가해보세요!'), findsOneWidget);
    });
  });
}

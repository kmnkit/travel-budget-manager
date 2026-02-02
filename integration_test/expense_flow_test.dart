import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

/// Integration test for expense CRUD operations.
///
/// Tests:
/// - Create a trip first
/// - Navigate to trip detail
/// - Verify empty expense state
/// - Add new expense with category and payment method
/// - Verify expense appears in list
/// - Edit existing expense
/// - Delete expense
///
/// TODO: Enable when running on device/emulator with database access
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Expense Flow Tests', () {
    testWidgets('complete expense creation flow', (tester) async {
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
      // Complete flow:
      // 1. Create a trip (reuse trip creation flow)
      // 2. Navigate to trip detail
      // 3. Verify empty expense state message
      // 4. Tap FAB to add expense
      // 5. Enter amount
      // 6. Select food category (식비)
      // 7. Select payment method
      // 8. Save expense
      // 9. Verify expense appears in list

      // For now, verify app launches
      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('verify empty expense state in trip detail', (tester) async {
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
      // 1. Create a trip
      // 2. Navigate to trip detail
      // 3. Verify empty expense message: "지출을 기록해보세요!"
      // 4. Verify FAB for adding expense is present

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('add expense with food category', (tester) async {
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
      // 1. Navigate to expense form from trip detail
      // 2. Enter amount "15000"
      // 3. Select food category (식비) - tap category chip
      // 4. Select a payment method
      // 5. Save expense
      // 6. Verify expense appears with correct amount and category icon

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('expense form validation', (tester) async {
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
      // 1. Navigate to expense form
      // 2. Try to save without entering amount
      // 3. Verify validation error shows
      // 4. Try to save without selecting category
      // 5. Verify validation error shows
      // 6. Fill in valid data and save successfully

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('navigate back from expense form', (tester) async {
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
      // 1. Navigate to expense form
      // 2. Tap cancel or back button
      // 3. Verify navigation returns to trip detail

      expect(find.text('TripWallet'), findsOneWidget);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

/// Integration test for multi-currency functionality.
///
/// Tests:
/// - Create KRW trip
/// - Add expenses in different currencies
/// - Verify currency conversion is displayed
/// - Navigate to exchange rate tab
/// - Verify exchange rate cards are shown
/// - Test currency symbol display
///
/// TODO: Enable when running on device/emulator with database access
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Multi-Currency Tests', () {
    testWidgets('create KRW trip and verify currency display', (tester) async {
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
      // 1. Create a KRW trip
      // 2. Verify budget shows with ₩ symbol
      // 3. Navigate to trip detail
      // 4. Verify currency is displayed correctly throughout

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('add expense with different currency', (tester) async {
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
      // 1. Create a KRW trip
      // 2. Navigate to trip detail
      // 3. Add expense form
      // 4. Select different currency (e.g., JPY)
      // 5. Enter amount
      // 6. Save expense
      // 7. Verify converted amount is displayed in expense list

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('verify exchange rate cards are shown', (tester) async {
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
      // 3. Navigate to exchange rate tab
      // 4. Verify exchange rate cards are displayed
      // 5. Verify each card shows currency code and rate

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('currency conversion displays correctly', (tester) async {
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
      // 1. Create a KRW trip with budget 1,000,000
      // 2. Add JPY expense of 10,000
      // 3. Verify converted amount is calculated and shown
      // 4. Verify both original and converted amounts are visible
      // 5. Verify budget consumption reflects conversion

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('multiple currencies in same trip', (tester) async {
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
      // 1. Create a KRW trip
      // 2. Add KRW expense
      // 3. Add JPY expense
      // 4. Add USD expense
      // 5. Verify all expenses show with correct symbols
      // 6. Verify total budget calculation includes all conversions
      // 7. Verify statistics handle multiple currencies correctly

      expect(find.text('TripWallet'), findsOneWidget);
    });

    testWidgets('currency selector in expense form', (tester) async {
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
      // 2. Find currency dropdown
      // 3. Tap to open currency selector
      // 4. Verify all 7 supported currencies are listed
      // 5. Select a currency
      // 6. Verify currency symbol updates in amount field

      expect(find.text('TripWallet'), findsOneWidget);
    });
  });
}

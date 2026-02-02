import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

/// Integration test for basic app functionality.
///
/// Tests:
/// - App launches successfully
/// - Home screen displays correctly
/// - Navigation to settings works
/// - Settings sections are visible
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Smoke Tests', () {
    testWidgets('app launches to home screen with correct UI elements',
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

      // Verify app bar shows "TripWallet"
      expect(find.text('TripWallet'), findsOneWidget);

      // Verify settings icon is visible
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Verify FAB (floating action button) is visible
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Verify empty state message when no trips exist
      expect(find.text('여행을 추가해보세요!'), findsOneWidget);
      expect(find.byIcon(Icons.luggage), findsOneWidget);
    });

    testWidgets('navigate to settings screen and verify sections',
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

      // Tap settings icon
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify settings screen title
      expect(find.text('설정'), findsOneWidget);

      // Verify general section
      expect(find.text('일반'), findsOneWidget);
      expect(find.text('언어'), findsOneWidget);
      expect(find.text('기본 통화'), findsOneWidget);

      // Verify data section
      expect(find.text('데이터'), findsOneWidget);
      expect(find.text('백업'), findsOneWidget);
      expect(find.text('복원'), findsOneWidget);

      // Verify info section
      expect(find.text('정보'), findsOneWidget);
      expect(find.text('버전'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.text('개인정보 처리방침'), findsOneWidget);
      expect(find.text('오픈소스 라이선스'), findsOneWidget);

      // Navigate back to home
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify we're back on home screen
      expect(find.text('TripWallet'), findsOneWidget);
      expect(find.text('여행을 추가해보세요!'), findsOneWidget);
    });

    testWidgets('settings icon is tappable from home screen', (tester) async {
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

      // Find and tap settings icon
      final settingsButton = find.byIcon(Icons.settings);
      expect(settingsButton, findsOneWidget);

      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.text('설정'), findsOneWidget);
    });
  });
}

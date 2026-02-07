import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';
import 'package:trip_wallet/features/consent/data/repositories/consent_repository_impl.dart';

/// Screenshot test for App Store submission
///
/// Run with:
/// ```bash
/// flutter drive \
///   --driver=test_driver/integration_test.dart \
///   --target=integration_test/screenshot_test.dart \
///   -d "iPhone 15 Pro Max"
/// ```
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Store Screenshots', () {
    testWidgets('Capture all screens for App Store', (tester) async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Initialize consent repository
      final consentRepository = ConsentRepositoryImpl(prefs);

      // Start app without Firebase
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            consentRepositoryProvider.overrideWithValue(consentRepository),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Screenshot 1: Home Screen (Trip List)
      await tester.pumpAndSettle();
      await takeScreenshot(binding, '01_home_screen');

      // Try to find and tap FAB to create a trip (if visible)
      final fabFinder = find.byType(FloatingActionButton);
      if (fabFinder.evaluate().isNotEmpty) {
        await tester.tap(fabFinder.first);
        await tester.pumpAndSettle();

        // Screenshot 2: Create Trip Screen
        await takeScreenshot(binding, '02_create_trip');

        // Go back
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
          await tester.pumpAndSettle();
        } else {
          // Try navigator pop
          await tester.pageBack();
          await tester.pumpAndSettle();
        }
      }

      // Try to find a trip card to tap
      final listTiles = find.byType(ListTile);
      final cards = find.byType(Card);

      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();

        // Screenshot 3: Trip Detail Screen
        await takeScreenshot(binding, '03_trip_detail');
      } else if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle();

        // Screenshot 3: Trip Detail Screen
        await takeScreenshot(binding, '03_trip_detail');
      }

      // Look for statistics/chart tab
      final statsTab = find.text('통계');
      final statsTabEn = find.text('Statistics');

      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
        await takeScreenshot(binding, '04_statistics');
      } else if (statsTabEn.evaluate().isNotEmpty) {
        await tester.tap(statsTabEn);
        await tester.pumpAndSettle();
        await takeScreenshot(binding, '04_statistics');
      }

      // Look for settings
      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();

        // Screenshot 5: Settings Screen
        await takeScreenshot(binding, '05_settings');
      }
    });
  });
}

Future<void> takeScreenshot(
  IntegrationTestWidgetsFlutterBinding binding,
  String name,
) async {
  if (Platform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot(name);
  } else {
    await binding.takeScreenshot(name);
  }
}

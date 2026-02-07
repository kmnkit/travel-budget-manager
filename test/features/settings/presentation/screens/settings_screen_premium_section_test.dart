import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/settings/presentation/screens/settings_screen.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('SettingsScreen Premium Section', () {
    testWidgets('should show premium section for non-premium users',
        (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          isPremiumActiveProvider.overrideWith((ref) => false), // Non-premium
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should find premium section
      expect(find.text('Premium'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('should hide premium section for premium users',
        (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          isPremiumActiveProvider.overrideWith((ref) => true), // Premium user
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should NOT find premium section
      expect(find.text('Premium'), findsNothing);
      expect(find.byIcon(Icons.workspace_premium), findsNothing);
    });

    // Note: Navigation testing requires GoRouter setup which is complex
    // This test is commented out for now but demonstrates the intent
    // testWidgets('should navigate to /premium when premium card is tapped',
    //     (tester) async {
    //   // This would require full router setup
    // });

    testWidgets('should display premium benefits in the section',
        (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          isPremiumActiveProvider.overrideWith((ref) => false),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should show premium benefits
      expect(find.textContaining('광고 없음'), findsOneWidget);
    });

    testWidgets('should show premium badge icon', (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          isPremiumActiveProvider.overrideWith((ref) => false),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Should show workspace_premium icon
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });
  });
}

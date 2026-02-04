import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/settings/presentation/screens/settings_screen.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

void main() {
  group('SettingsScreen Locale Switching', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('displays Korean labels when locale is ko', (tester) async {
      await prefs.setString('locale', 'ko');

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check AppBar title
      expect(find.text('설정'), findsOneWidget);

      // Check section labels
      expect(find.text('일반'), findsOneWidget);
      expect(find.text('데이터'), findsOneWidget);
      expect(find.text('정보'), findsOneWidget);

      // Check list tile labels
      expect(find.text('언어'), findsOneWidget);
      expect(find.text('기본 통화'), findsOneWidget);
      expect(find.text('백업'), findsOneWidget);
      expect(find.text('복원'), findsOneWidget);
      expect(find.text('버전'), findsOneWidget);
      expect(find.text('개인정보 처리방침'), findsOneWidget);
      expect(find.text('오픈소스 라이선스'), findsOneWidget);
    });

    testWidgets('displays English labels when locale is en', (tester) async {
      await prefs.setString('locale', 'en');

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check AppBar title
      expect(find.text('Settings'), findsOneWidget);

      // Check section labels
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Data'), findsOneWidget);
      expect(find.text('Info'), findsOneWidget);

      // Check list tile labels
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Default Currency'), findsOneWidget);
      expect(find.text('Backup'), findsOneWidget);
      expect(find.text('Restore'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Open Source Licenses'), findsOneWidget);
    });

    testWidgets('displays Korean as subtitle when locale is ko', (tester) async {
      await prefs.setString('locale', 'ko');

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check language subtitle shows Korean
      expect(find.text('한국어'), findsOneWidget);
    });

    testWidgets('displays English as subtitle when locale is en', (tester) async {
      await prefs.setString('locale', 'en');

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check language subtitle shows English
      expect(find.text('English'), findsOneWidget);
    });
  });
}

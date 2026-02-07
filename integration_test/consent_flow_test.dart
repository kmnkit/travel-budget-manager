import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/consent/presentation/widgets/privacy_policy_content.dart';

/// Integration test for consent flow.
///
/// Tests:
/// - Test Case 1: First-time user (onboarding → consent → main app)
/// - Test Case 2: Decline consent (dialog appears, stays on consent screen)
/// - Test Case 3: Settings privacy policy navigation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Consent Flow Tests', () {
    testWidgets('Test Case 1: First-time user completes onboarding and consent',
        (tester) async {
      // Setup: Clear all data for fresh start
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Launch app
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // STEP 1: Verify onboarding screen appears
      expect(find.text('트립월렛에 오신 것을 환영합니다'), findsOneWidget);
      expect(find.text('다양한 통화로 여행 경비를 관리하는 스마트한 여행 동반자'), findsOneWidget);

      // Complete onboarding by swiping through pages
      // Page 1: Welcome
      expect(find.byIcon(Icons.flight_takeoff), findsOneWidget);
      await tester.drag(
          find.byType(PageView), const Offset(-300, 0)); // Swipe left
      await tester.pumpAndSettle();

      // Page 2: Features
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      // Page 3: Get Started - tap "시작하기" button
      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
      await tester.tap(find.text('시작하기'));
      await tester.pumpAndSettle();

      // STEP 2: Verify consent screen appears after onboarding
      expect(find.text('개인정보 보호 및 데이터 처리'), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip), findsOneWidget);
      expect(find.text('동의합니다'), findsOneWidget);
      expect(find.text('동의하지 않습니다'), findsOneWidget);

      // Verify privacy policy content is displayed
      expect(find.textContaining('Trip Wallet'), findsWidgets); // Appears in markdown content

      // STEP 3: Accept consent
      await tester.tap(find.text('동의합니다'));
      await tester.pumpAndSettle();

      // STEP 4: Verify main app appears (home screen)
      expect(find.text('TripWallet'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('여행을 추가해보세요!'), findsOneWidget);

      // Verify consent was saved
      final savedConsent = prefs.getBool('privacy_consent_accepted');
      expect(savedConsent, true);
    });

    testWidgets('Test Case 2: User declines consent and sees dialog',
        (tester) async {
      // Setup: Onboarding completed, but no consent
      SharedPreferences.setMockInitialValues({
        'onboarding_completed': true,
      });
      final prefs = await SharedPreferences.getInstance();

      // Launch app
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // STEP 1: Verify consent screen appears directly (skip onboarding)
      expect(find.text('개인정보 보호 및 데이터 처리'), findsOneWidget);
      expect(find.text('동의합니다'), findsOneWidget);
      expect(find.text('동의하지 않습니다'), findsOneWidget);

      // STEP 2: Tap decline button
      await tester.tap(find.text('동의하지 않습니다'));
      await tester.pumpAndSettle();

      // STEP 3: Verify alert dialog appears
      expect(find.text('동의 필요'), findsOneWidget);
      expect(
          find.textContaining(
              'TripWallet은 여행 데이터를 기기에 로컬로 처리하기 위해 동의가 필요합니다'),
          findsOneWidget);
      expect(find.text('이해했습니다'), findsOneWidget);

      // STEP 4: Dismiss dialog
      await tester.tap(find.text('이해했습니다'));
      await tester.pumpAndSettle();

      // STEP 5: Verify still on consent screen (not advanced to main app)
      expect(find.text('개인정보 보호 및 데이터 처리'), findsOneWidget);
      expect(find.text('동의합니다'), findsOneWidget);
      expect(find.text('동의하지 않습니다'), findsOneWidget);

      // Verify consent was NOT saved
      final savedConsent = prefs.getBool('privacy_consent_accepted');
      expect(savedConsent, isNull);
    });

    testWidgets(
        'Test Case 3: Privacy policy viewer displays content correctly',
        (tester) async {
      // Setup: Just test the privacy policy viewer screen in isolation
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Import needed for direct screen testing
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp(
            locale: const Locale('ko'),
            supportedLocales: const [Locale('ko'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              appBar: AppBar(title: const Text('개인정보 처리방침')),
              body: const Padding(
                padding: EdgeInsets.all(16.0),
                child: PrivacyPolicyContent(scrollable: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Wait for markdown content to load
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // STEP 1: Verify privacy policy content is displayed
      expect(find.text('개인정보 처리방침'), findsOneWidget);
      expect(find.textContaining('Trip Wallet'), findsWidgets); // Appears in content

      // STEP 2: Verify Korean content is loaded
      expect(find.textContaining('여행'), findsWidgets); // Korean text should be present
    });

    testWidgets('Test Case 4: Consent screen displays privacy policy content',
        (tester) async {
      // Setup: Onboarding completed, no consent
      SharedPreferences.setMockInitialValues({
        'onboarding_completed': true,
      });
      final prefs = await SharedPreferences.getInstance();

      // Launch app
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify consent screen with policy content
      expect(find.text('개인정보 보호 및 데이터 처리'), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip), findsOneWidget);

      // Verify policy content is displayed (markdown renders the content)
      expect(find.textContaining('Trip Wallet'), findsWidgets);
      expect(find.text('동의합니다'), findsOneWidget);
      expect(find.text('동의하지 않습니다'), findsOneWidget);
    });
  });
}

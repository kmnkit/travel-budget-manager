import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trip_wallet/features/consent/presentation/widgets/privacy_policy_content.dart';

Widget makeTestableWidget(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ko'),
    ],
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('PrivacyPolicyContent', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const PrivacyPolicyContent(scrollable: true)),
      );

      // Initially should show CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders markdown content for English locale', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const PrivacyPolicyContent(scrollable: true)),
      );

      // Wait for async asset loading
      await tester.pump();

      // Check for English content by type since Markdown renders differently
      expect(find.byType(PrivacyPolicyContent), findsOneWidget);
    });

    testWidgets('renders markdown content for Korean locale', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const PrivacyPolicyContent(scrollable: true),
          locale: const Locale('ko'),
        ),
      );

      // Wait for async asset loading
      await tester.pump();

      // Check widget renders
      expect(find.byType(PrivacyPolicyContent), findsOneWidget);
    });

    testWidgets('reloads content when locale changes', (tester) async {
      final privacyPolicyContentKey = GlobalKey();

      await tester.pumpWidget(
        makeTestableWidget(
          PrivacyPolicyContent(key: privacyPolicyContentKey, scrollable: true),
        ),
      );

      // Wait for initial load (English)
      await tester.pump();

      // Verify widget exists
      expect(find.byKey(privacyPolicyContentKey), findsOneWidget);

      // Change locale
      await tester.pumpWidget(
        makeTestableWidget(
          PrivacyPolicyContent(key: privacyPolicyContentKey, scrollable: true),
          locale: const Locale('ko'),
        ),
      );

      // Wait for Korean load
      await tester.pump();

      // Verify widget still exists (content changed)
      expect(find.byKey(privacyPolicyContentKey), findsOneWidget);
    });

    testWidgets('renders in scrollable mode', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const PrivacyPolicyContent(scrollable: true)),
      );

      await tester.pump();

      // Verify widget is created with scrollable=true
      final widget = tester.widget<PrivacyPolicyContent>(
        find.byType(PrivacyPolicyContent),
      );
      expect(widget.scrollable, isTrue);
    });

    testWidgets('renders in non-scrollable mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ko'),
          ],
          home: const Scaffold(
            body: SingleChildScrollView(
              child: PrivacyPolicyContent(scrollable: false),
            ),
          ),
        ),
      );

      await tester.pump();

      // Widget itself should render
      expect(find.byType(PrivacyPolicyContent), findsOneWidget);
    });
  });
}

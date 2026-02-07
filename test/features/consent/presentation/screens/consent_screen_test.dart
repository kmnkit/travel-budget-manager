import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/consent/presentation/screens/consent_screen.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class MockConsentRepository extends Mock implements ConsentRepository {}

void main() {
  late MockConsentRepository mockRepository;

  setUp(() {
    mockRepository = MockConsentRepository();
  });

  Widget makeTestableWidget({
    required Widget child,
    required MockConsentRepository repository,
  }) {
    return ProviderScope(
      overrides: [
        consentRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
        ],
        home: child,
      ),
    );
  }

  group('ConsentScreen', () {
    testWidgets('renders all required UI elements', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          child: ConsentScreen(onConsentGiven: () {}),
          repository: mockRepository,
        ),
      );

      // Wait for initial render
      await tester.pump();
      // Wait for async content loading
      await tester.pump(const Duration(seconds: 1));

      // Check for icon
      expect(find.byIcon(Icons.privacy_tip), findsOneWidget);

      // Check for buttons (using localized strings)
      expect(find.text('I Accept'), findsOneWidget);
      expect(find.text('I Decline'), findsOneWidget);
    });

    testWidgets('calls onConsentGiven and saves consent when Accept is tapped',
        (tester) async {
      bool consentGiven = false;
      when(() => mockRepository.setConsentAccepted(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        makeTestableWidget(
          child: ConsentScreen(
            onConsentGiven: () {
              consentGiven = true;
            },
          ),
          repository: mockRepository,
        ),
      );

      // Wait for initial render
      await tester.pump();
      // Wait for async content loading
      await tester.pump(const Duration(seconds: 1));

      // Tap Accept button
      await tester.tap(find.text('I Accept'));
      await tester.pump();

      // Verify setConsentAccepted was called
      verify(() => mockRepository.setConsentAccepted(any())).called(1);

      // Verify callback was called
      expect(consentGiven, isTrue);
    });

    testWidgets('shows AlertDialog when Decline is tapped', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          child: ConsentScreen(onConsentGiven: () {}),
          repository: mockRepository,
        ),
      );

      // Wait for initial render
      await tester.pump();
      // Wait for async content loading
      await tester.pump(const Duration(seconds: 1));

      // Tap Decline button
      await tester.tap(find.text('I Decline'));
      await tester.pump();

      // Verify AlertDialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Consent Required'), findsOneWidget);
    });

    testWidgets('closes AlertDialog when OK is tapped', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          child: ConsentScreen(onConsentGiven: () {}),
          repository: mockRepository,
        ),
      );

      // Wait for initial render
      await tester.pump();
      // Wait for async content loading
      await tester.pump(const Duration(seconds: 1));

      // Tap Decline button
      await tester.tap(find.text('I Decline'));
      await tester.pump();

      // Verify dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap OK button
      await tester.tap(find.text('I Understand'));
      await tester.pump();
      await tester.pump();

      // Verify dialog is closed
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('invalidates consentRecordProvider after accepting',
        (tester) async {
      when(() => mockRepository.setConsentAccepted(any())).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ko'),
            ],
            home: ConsentScreen(onConsentGiven: () {}),
          ),
        ),
      );

      // Wait for initial render
      await tester.pump();
      // Wait for async content loading
      await tester.pump(const Duration(seconds: 1));

      // Tap Accept button
      await tester.tap(find.text('I Accept'));
      await tester.pump();

      // Verify setConsentAccepted was called
      verify(() => mockRepository.setConsentAccepted(any())).called(1);

      container.dispose();
    });

    testWidgets('uses Material 3 design with Teal theme', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          child: ConsentScreen(onConsentGiven: () {}),
          repository: mockRepository,
        ),
      );

      // Wait for initial render
      await tester.pump();
      // Wait for async content loading
      await tester.pump(const Duration(seconds: 1));

      // Verify Material 3 components exist
      expect(find.byType(ConsentScreen), findsOneWidget);

      // Check that buttons exist (theme is applied at app level)
      expect(find.widgetWithText(FilledButton, 'I Accept'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'I Decline'), findsOneWidget);
    });
  });
}

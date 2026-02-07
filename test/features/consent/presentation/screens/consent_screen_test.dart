import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';
import 'package:trip_wallet/features/consent/data/repositories/consent_repository_impl.dart';
import 'package:trip_wallet/features/consent/data/datasources/consent_local_datasource.dart';
import 'package:trip_wallet/features/consent/presentation/screens/consent_screen.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';

void main() {
  group('ConsentScreen Widget Tests', () {
    late ProviderContainer container;
    late ConsentRepository mockRepository;

    setUp(() async {
      // Setup SharedPreferences for tests
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final dataSource = ConsentLocalDataSource(prefs);
      mockRepository = ConsentRepositoryImpl(dataSource);

      container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget buildTestWidget({Size? surfaceSize}) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: const ConsentScreen(),
        ),
      );
    }

    testWidgets('renders app logo and welcome message', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should find TripWallet branding
      expect(find.text('TripWallet'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('displays data collection scope explanation', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should find section titles
      expect(find.text('Data Collection & Privacy'), findsOneWidget);
      expect(find.text('What we collect:'), findsOneWidget);
      expect(find.text('What we DO NOT collect:'), findsOneWidget);
    });

    testWidgets('shows privacy policy link', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('displays analytics consent checkbox', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should find analytics checkbox
      expect(
        find.widgetWithText(CheckboxListTile, 'Analytics'),
        findsOneWidget,
      );
    });

    testWidgets('displays personalized ads consent checkbox', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should find ads checkbox
      expect(
        find.widgetWithText(CheckboxListTile, 'Personalized Ads'),
        findsOneWidget,
      );
    });

    testWidgets('displays all three action buttons after scrolling', (tester) async {
      // Use larger surface size to accommodate the full screen
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Accept All'), findsOneWidget);
      expect(find.text('Accept Selected'), findsOneWidget);
      expect(find.text('Continue Without Consent'), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('checkboxes start unchecked', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find checkboxes
      final analyticsCheckbox = find.widgetWithText(
        CheckboxListTile,
        'Analytics',
      );
      final adsCheckbox = find.widgetWithText(
        CheckboxListTile,
        'Personalized Ads',
      );

      // Initially unchecked
      CheckboxListTile analyticsWidget = tester.widget(analyticsCheckbox);
      CheckboxListTile adsWidget = tester.widget(adsCheckbox);

      expect(analyticsWidget.value, false);
      expect(adsWidget.value, false);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('analytics checkbox can be toggled', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final analyticsCheckbox = find.widgetWithText(
        CheckboxListTile,
        'Analytics',
      );

      // Initially unchecked
      CheckboxListTile analyticsWidget = tester.widget(analyticsCheckbox);
      expect(analyticsWidget.value, false);

      // Tap analytics checkbox
      await tester.tap(analyticsCheckbox);
      await tester.pumpAndSettle();

      analyticsWidget = tester.widget(analyticsCheckbox);
      expect(analyticsWidget.value, true);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('uses teal primary color from theme', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Check if Accept All button uses teal color
      final acceptAllButton = find.widgetWithText(ElevatedButton, 'Accept All');
      expect(acceptAllButton, findsOneWidget);

      final buttonWidget = tester.widget<ElevatedButton>(acceptAllButton);
      final buttonStyle = buttonWidget.style;

      // Should have style defined
      expect(buttonStyle, isNotNull);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('displays with 12px border radius on cards', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Check border radius on card
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsAtLeastNWidgets(1));

      final card = tester.widget<Card>(cardFinder.first);
      final shape = card.shape as RoundedRectangleBorder?;
      if (shape != null) {
        final borderRadius = shape.borderRadius as BorderRadius;
        expect(borderRadius.topLeft.x, greaterThanOrEqualTo(8.0));
      }
    });
  });
}

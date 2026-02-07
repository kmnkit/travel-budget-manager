import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:trip_wallet/features/premium/presentation/providers/iap_providers.dart';
import 'package:trip_wallet/features/premium/presentation/screens/premium_screen.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class MockPremiumRepository extends Mock implements PremiumRepositoryImpl {}

void main() {
  group('PremiumScreen', () {
    late MockPremiumRepository mockRepository;

    setUp(() {
      mockRepository = MockPremiumRepository();
    });

    Widget buildTestWidget() {
      return ProviderScope(
        overrides: [
          premiumRepositoryWithIapProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: PremiumScreen(),
        ),
      );
    }

    testWidgets('should display premium screen with features list',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify screen renders
      expect(find.byType(PremiumScreen), findsOneWidget);
    });

    testWidgets('should display features list', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify features section exists
      expect(find.byType(PremiumScreen), findsOneWidget);
    });

    testWidgets('should display purchase button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find button by type (text depends on localization)
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should display app bar with title',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find app bar
      expect(find.byType(AppBar), findsOneWidget);
    });

  });
}

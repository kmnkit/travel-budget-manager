import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/internals.dart' show Override;
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/quick_filter_chips.dart';

Widget createTestWidget(Widget child, {List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('QuickFilterChips Widget', () {
    testWidgets('renders without filters active', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      expect(find.byType(QuickFilterChips), findsOneWidget);
    });

    testWidgets('shows all 8 category chips', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      // Wait for widget to build
      await tester.pumpAndSettle();

      // Verify all 8 categories are present
      expect(find.text('식비'), findsOneWidget);
      expect(find.text('교통'), findsOneWidget);
      expect(find.text('숙박'), findsOneWidget);
      expect(find.text('쇼핑'), findsOneWidget);
      expect(find.text('오락'), findsOneWidget);
      expect(find.text('관광'), findsOneWidget);
      expect(find.text('통신'), findsOneWidget);
      expect(find.text('기타'), findsOneWidget);
    });

    testWidgets('shows payment method chips when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(
            availablePaymentMethods: ['Cash', 'Credit Card'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Credit Card'), findsOneWidget);
    });

    testWidgets('does not show payment method row when empty list',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      await tester.pumpAndSettle();

      // Only category chips should be visible
      expect(find.byType(FilterChip), equals(findsNWidgets(8)));
    });

    testWidgets('shows "전체 초기화" chip when filter active', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      await tester.pumpAndSettle();

      // No clear chip initially
      expect(find.text('전체 초기화'), findsNothing);

      // Tap a category
      await tester.tap(find.text('식비'));
      await tester.pumpAndSettle();

      // Now clear chip should appear
      expect(find.text('전체 초기화'), findsOneWidget);
    });

    testWidgets('does not show "전체 초기화" when no filter active',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('전체 초기화'), findsNothing);
    });

    testWidgets('tapping category chip toggles selection', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      await tester.pumpAndSettle();

      // Find the food category chip
      final foodChip = find.ancestor(
        of: find.text('식비'),
        matching: find.byType(FilterChip),
      );

      // Initially not selected
      FilterChip chip = tester.widget(foodChip);
      expect(chip.selected, false);

      // Tap to select
      await tester.tap(foodChip);
      await tester.pumpAndSettle();

      // Now selected
      chip = tester.widget(foodChip);
      expect(chip.selected, true);

      // Tap to deselect
      await tester.tap(foodChip);
      await tester.pumpAndSettle();

      // Now not selected again
      chip = tester.widget(foodChip);
      expect(chip.selected, false);
    });

    testWidgets('tapping payment method chip toggles selection',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(
            availablePaymentMethods: ['Cash', 'Credit Card'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the Cash chip
      final cashChip = find.ancestor(
        of: find.text('Cash'),
        matching: find.byType(FilterChip),
      );

      // Initially not selected
      FilterChip chip = tester.widget(cashChip);
      expect(chip.selected, false);

      // Tap to select
      await tester.tap(cashChip);
      await tester.pumpAndSettle();

      // Now selected
      chip = tester.widget(cashChip);
      expect(chip.selected, true);
    });

    testWidgets('tapping "전체 초기화" clears all filters', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(
            availablePaymentMethods: ['Cash'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select a category and payment method
      await tester.tap(find.text('식비'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cash'));
      await tester.pumpAndSettle();

      // Clear all button should be visible
      expect(find.text('전체 초기화'), findsOneWidget);

      // Tap the delete icon on the clear all chip
      final deleteIcon = find.descendant(
        of: find.ancestor(
          of: find.text('전체 초기화'),
          matching: find.byType(Chip),
        ),
        matching: find.byIcon(Icons.close),
      );
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      // All filters should be cleared (clear button disappears)
      expect(find.text('전체 초기화'), findsNothing);
    });

    testWidgets('selected chips have primary color', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFilterChips(availablePaymentMethods: []),
        ),
      );

      await tester.pumpAndSettle();

      // Tap to select food category
      await tester.tap(find.text('식비'));
      await tester.pumpAndSettle();

      // Find the selected chip
      final foodChip = find.ancestor(
        of: find.text('식비'),
        matching: find.byType(FilterChip),
      );

      final chip = tester.widget<FilterChip>(foodChip);
      expect(chip.selected, true);
      expect(chip.selectedColor, AppColors.primary);
    });
  });
}

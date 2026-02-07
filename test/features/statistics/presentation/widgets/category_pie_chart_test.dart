import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/category_pie_chart.dart';

void main() {
  group('CategoryPieChart Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('should render with valid category data', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 100.0,
        ExpenseCategory.transport: 50.0,
        ExpenseCategory.accommodation: 150.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 300.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('카테고리별 지출'), findsOneWidget);
    });

    testWidgets('should render empty when all categories are zero', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 0.0,
        ExpenseCategory.transport: 0.0,
        ExpenseCategory.accommodation: 0.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 0.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should render empty when category data is empty', (tester) async {
      // Arrange
      final categoryData = <ExpenseCategory, double>{};

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 0.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('should filter out zero-value categories', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 100.0,
        ExpenseCategory.transport: 0.0,    // Should be filtered out
        ExpenseCategory.accommodation: 50.0,
        ExpenseCategory.shopping: 0.0,     // Should be filtered out
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 150.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Should show only non-zero categories in legend
      expect(find.textContaining(ExpenseCategory.food.labelKo), findsOneWidget);
      expect(find.textContaining(ExpenseCategory.accommodation.labelKo), findsOneWidget);

      // Zero categories should not appear
      expect(find.textContaining(ExpenseCategory.transport.labelKo), findsNothing);
      expect(find.textContaining(ExpenseCategory.shopping.labelKo), findsNothing);
    });

    testWidgets('should display all 8 categories when all have values', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 100.0,
        ExpenseCategory.transport: 50.0,
        ExpenseCategory.accommodation: 200.0,
        ExpenseCategory.shopping: 75.0,
        ExpenseCategory.entertainment: 30.0,
        ExpenseCategory.sightseeing: 45.0,
        ExpenseCategory.communication: 20.0,
        ExpenseCategory.other: 10.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 530.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // All 8 categories should appear in legend
      for (final category in ExpenseCategory.values) {
        expect(find.textContaining(category.labelKo), findsOneWidget);
      }
    });

    testWidgets('should display category colors correctly', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 100.0,
        ExpenseCategory.transport: 50.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 150.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Find color boxes in legend
      final containerFinder = find.descendant(
        of: find.byType(Card),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsWidgets);
    });

    testWidgets('should display percentage labels', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 60.0,      // 60% of 100
        ExpenseCategory.transport: 40.0, // 40% of 100
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages should be displayed in legend (60.0% and 40.0%)
      expect(find.textContaining('60.0%'), findsOneWidget);
      expect(find.textContaining('40.0%'), findsOneWidget);
    });

    testWidgets('should calculate percentages correctly', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 75.0,       // 75% of 100
        ExpenseCategory.transport: 25.0,  // 25% of 100
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('75.0%'), findsOneWidget);
      expect(find.textContaining('25.0%'), findsOneWidget);
    });

    testWidgets('should display formatted currency amounts', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 1234.56,
        ExpenseCategory.transport: 789.01,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 2023.57,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Currency formatter should format amounts with $ symbol
      // formatCompact uses currency symbol, not code
      expect(find.textContaining('\$'), findsWidgets);
    });

    testWidgets('should handle single category', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 500.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 500.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining(ExpenseCategory.food.labelKo), findsOneWidget);
      expect(find.textContaining('100.0%'), findsOneWidget); // 100% for single category
    });

    testWidgets('should handle decimal percentages correctly', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 33.33,
        ExpenseCategory.transport: 33.33,
        ExpenseCategory.accommodation: 33.34,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages should be displayed with 1 decimal place
      expect(find.textContaining('33.3%'), findsWidgets);
    });

    testWidgets('should use different currency codes', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 100.0,
      };

      // Act - Test with KRW
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 100.0,
            currencyCode: 'KRW',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      // Currency symbol for KRW is ₩
      // Just verify the widget renders without error for different currency
      expect(find.textContaining('100.0%'), findsOneWidget);
    });

    testWidgets('should render legend with proper layout', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 100.0,
        ExpenseCategory.transport: 50.0,
        ExpenseCategory.accommodation: 150.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 300.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget); // Legend uses Wrap layout

      // Each legend item should have a color box and text
      final rowFinder = find.descendant(
        of: find.byType(Wrap),
        matching: find.byType(Row),
      );

      expect(rowFinder, findsNWidgets(3)); // 3 categories = 3 legend items
    });

    testWidgets('should handle very small amounts', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 0.01,
        ExpenseCategory.transport: 0.99,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 1.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages: 1% and 99%
      expect(find.textContaining('1.0%'), findsOneWidget);
      expect(find.textContaining('99.0%'), findsOneWidget);
    });

    testWidgets('should handle large amounts', (tester) async {
      // Arrange
      final categoryData = {
        ExpenseCategory.food: 1000000.0,
        ExpenseCategory.transport: 500000.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          CategoryPieChart(
            categoryData: categoryData,
            totalAmount: 1500000.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages should still be correct
      expect(find.textContaining('66.7%'), findsOneWidget); // 1M / 1.5M ≈ 66.7%
      expect(find.textContaining('33.3%'), findsOneWidget); // 500k / 1.5M ≈ 33.3%
    });
  });
}

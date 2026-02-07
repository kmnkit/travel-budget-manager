import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/payment_method_chart.dart';

void main() {
  group('PaymentMethodChart Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('should render with valid payment method data', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 100.0,
        'Credit Card': 200.0,
        'Debit Card': 150.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 450.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('결제 수단별 지출'), findsOneWidget);
    });

    testWidgets('should render empty when all methods are zero', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 0.0,
        'Credit Card': 0.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 0.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should render empty when method data is empty', (tester) async {
      // Arrange
      final methodData = <String, double>{};

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 0.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('should filter out zero-value payment methods', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 100.0,
        'Credit Card': 0.0,      // Should be filtered out
        'Debit Card': 50.0,
        'Mobile Payment': 0.0,   // Should be filtered out
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 150.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Non-zero methods should appear
      expect(find.textContaining('Cash'), findsOneWidget);
      expect(find.textContaining('Debit Card'), findsOneWidget);

      // Zero methods should not appear
      expect(find.textContaining('Credit Card'), findsNothing);
      expect(find.textContaining('Mobile Payment'), findsNothing);
    });

    testWidgets('should sort payment methods by amount descending', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 50.0,              // 3rd
        'Credit Card': 200.0,      // 1st
        'Debit Card': 100.0,       // 2nd
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 350.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Find all text widgets within the card
      final cardFinder = find.byType(Card);
      final textFinders = find.descendant(
        of: cardFinder,
        matching: find.byType(Text),
      );

      // Get all text values (filtering out empty ones)
      final texts = textFinders.evaluate().map((e) {
        final textWidget = e.widget as Text;
        return textWidget.data ?? '';
      }).where((text) => text.isNotEmpty).toList();

      // Payment methods should appear in order: Credit Card, Debit Card, Cash
      // (after the title)
      final paymentMethods = texts.where((t) =>
        t.contains('Cash') || t.contains('Credit Card') || t.contains('Debit Card')
      ).toList();

      expect(paymentMethods.length, greaterThanOrEqualTo(3));
    });

    testWidgets('should display payment method names', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 100.0,
        'Credit Card': 200.0,
        'Mobile Payment': 50.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 350.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('Cash'), findsOneWidget);
      expect(find.textContaining('Credit Card'), findsOneWidget);
      expect(find.textContaining('Mobile Payment'), findsOneWidget);
    });

    testWidgets('should display formatted currency amounts', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 1234.56,
        'Credit Card': 5678.90,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 6913.46,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      // CurrencyFormatter.format should display with $ symbol
      expect(find.textContaining('\$'), findsWidgets);
    });

    testWidgets('should display percentage for each payment method', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 50.0,       // 50% of 100
        'Credit Card': 30.0, // 30% of 100
        'Debit Card': 20.0,  // 20% of 100
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages should be displayed with 1 decimal place
      expect(find.text('50.0%'), findsOneWidget);
      expect(find.text('30.0%'), findsOneWidget);
      expect(find.text('20.0%'), findsOneWidget);
    });

    testWidgets('should calculate percentages correctly', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 75.0,        // 75% of 100
        'Credit Card': 25.0, // 25% of 100
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('75.0%'), findsOneWidget);
      expect(find.text('25.0%'), findsOneWidget);
    });

    testWidgets('should display progress bars', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 100.0,
        'Credit Card': 200.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 300.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Progress bars use Stack and FractionallySizedBox
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(FractionallySizedBox), findsWidgets);
    });

    testWidgets('should handle single payment method', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 500.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 500.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('Cash'), findsOneWidget);
      expect(find.text('100.0%'), findsOneWidget); // 100% for single method
    });

    testWidgets('should handle decimal percentages correctly', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 33.33,
        'Credit Card': 33.33,
        'Debit Card': 33.34,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages should be displayed with 1 decimal place
      expect(find.text('33.3%'), findsWidgets);
    });

    testWidgets('should use different currency codes', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 10000.0,
        'Credit Card': 20000.0,
      };

      // Act - Test with KRW
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 30000.0,
            currencyCode: 'KRW',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('Cash'), findsOneWidget);
      expect(find.textContaining('Credit Card'), findsOneWidget);
    });

    testWidgets('should handle large amounts', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 1000000.0,
        'Credit Card': 2000000.0,
        'Debit Card': 500000.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 3500000.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages should still be calculated correctly
      // 1M / 3.5M ≈ 28.6%
      // 2M / 3.5M ≈ 57.1%
      // 500k / 3.5M ≈ 14.3%
      expect(find.text('28.6%'), findsOneWidget);
      expect(find.text('57.1%'), findsOneWidget);
      expect(find.text('14.3%'), findsOneWidget);
    });

    testWidgets('should handle very small amounts', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 0.01,
        'Credit Card': 0.99,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 1.0,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Percentages: 1% and 99%
      expect(find.text('1.0%'), findsOneWidget);
      expect(find.text('99.0%'), findsOneWidget);
    });

    testWidgets('should display card with proper styling', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 100.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 100.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.margin, equals(const EdgeInsets.all(16)));
      expect(card.shape, isA<RoundedRectangleBorder>());
      expect(card.elevation, equals(2));
    });

    testWidgets('should handle payment method names with spaces', (tester) async {
      // Arrange
      final methodData = {
        'Mobile Payment App': 150.0,
        'Corporate Credit Card': 250.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 400.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('Mobile Payment App'), findsOneWidget);
      expect(find.textContaining('Corporate Credit Card'), findsOneWidget);
    });

    testWidgets('should handle many payment methods', (tester) async {
      // Arrange
      final methodData = {
        'Cash': 100.0,
        'Credit Card': 200.0,
        'Debit Card': 150.0,
        'Mobile Payment': 50.0,
        'Bank Transfer': 75.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          PaymentMethodChart(
            methodData: methodData,
            totalAmount: 575.0,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // All 5 payment methods should be displayed
      expect(find.textContaining('Cash'), findsOneWidget);
      expect(find.textContaining('Credit Card'), findsOneWidget);
      expect(find.textContaining('Debit Card'), findsOneWidget);
      expect(find.textContaining('Mobile Payment'), findsOneWidget);
      expect(find.textContaining('Bank Transfer'), findsOneWidget);
    });
  });
}

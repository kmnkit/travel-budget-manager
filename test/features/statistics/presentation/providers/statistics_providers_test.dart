import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';

void main() {
  group('StatisticsData', () {
    test('should create instance with all required fields', () {
      // Arrange
      final categoryTotals = {
        ExpenseCategory.food: 100.0,
        ExpenseCategory.transport: 50.0,
        ExpenseCategory.accommodation: 200.0,
        ExpenseCategory.shopping: 75.0,
        ExpenseCategory.entertainment: 30.0,
        ExpenseCategory.sightseeing: 45.0,
        ExpenseCategory.communication: 20.0,
        ExpenseCategory.other: 10.0,
      };
      final dailyTotals = {
        DateTime(2024, 1, 1): 150.0,
        DateTime(2024, 1, 2): 200.0,
        DateTime(2024, 1, 3): 180.0,
      };
      final paymentMethodTotals = {
        'Cash': 250.0,
        'Credit Card': 280.0,
      };
      const totalAmount = 530.0;

      // Act
      final statisticsData = StatisticsData(
        categoryTotals: categoryTotals,
        dailyTotals: dailyTotals,
        paymentMethodTotals: paymentMethodTotals,
        totalAmount: totalAmount,
      );

      // Assert
      expect(statisticsData.categoryTotals, equals(categoryTotals));
      expect(statisticsData.categoryTotals[ExpenseCategory.food], equals(100.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.transport], equals(50.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.accommodation], equals(200.0));

      expect(statisticsData.dailyTotals, equals(dailyTotals));
      expect(statisticsData.dailyTotals[DateTime(2024, 1, 1)], equals(150.0));
      expect(statisticsData.dailyTotals.length, equals(3));

      expect(statisticsData.paymentMethodTotals, equals(paymentMethodTotals));
      expect(statisticsData.paymentMethodTotals['Cash'], equals(250.0));
      expect(statisticsData.paymentMethodTotals['Credit Card'], equals(280.0));

      expect(statisticsData.totalAmount, equals(totalAmount));
    });

    test('should handle empty data collections', () {
      // Arrange & Act
      final statisticsData = StatisticsData(
        categoryTotals: {},
        dailyTotals: {},
        paymentMethodTotals: {},
        totalAmount: 0.0,
      );

      // Assert
      expect(statisticsData.categoryTotals.isEmpty, isTrue);
      expect(statisticsData.dailyTotals.isEmpty, isTrue);
      expect(statisticsData.paymentMethodTotals.isEmpty, isTrue);
      expect(statisticsData.totalAmount, equals(0.0));
    });

    test('should correctly store all 8 expense categories', () {
      // Arrange
      final categoryTotals = {
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
      final statisticsData = StatisticsData(
        categoryTotals: categoryTotals,
        dailyTotals: {},
        paymentMethodTotals: {},
        totalAmount: 530.0,
      );

      // Assert
      expect(statisticsData.categoryTotals.length, equals(8));
      expect(statisticsData.categoryTotals.keys.toSet(), equals(ExpenseCategory.values.toSet()));

      // Verify each category value
      expect(statisticsData.categoryTotals[ExpenseCategory.food], equals(100.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.transport], equals(50.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.accommodation], equals(200.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.shopping], equals(75.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.entertainment], equals(30.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.sightseeing], equals(45.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.communication], equals(20.0));
      expect(statisticsData.categoryTotals[ExpenseCategory.other], equals(10.0));
    });

    test('should handle multiple daily totals correctly', () {
      // Arrange
      final dailyTotals = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 150.0,
        DateTime(2024, 1, 3): 200.0,
        DateTime(2024, 1, 4): 80.0,
        DateTime(2024, 1, 5): 120.0,
      };

      // Act
      final statisticsData = StatisticsData(
        categoryTotals: {},
        dailyTotals: dailyTotals,
        paymentMethodTotals: {},
        totalAmount: 650.0,
      );

      // Assert
      expect(statisticsData.dailyTotals.length, equals(5));
      expect(statisticsData.dailyTotals[DateTime(2024, 1, 1)], equals(100.0));
      expect(statisticsData.dailyTotals[DateTime(2024, 1, 5)], equals(120.0));
    });

    test('should handle multiple payment methods correctly', () {
      // Arrange
      final paymentMethodTotals = {
        'Cash': 150.0,
        'Credit Card': 300.0,
        'Debit Card': 100.0,
        'Mobile Payment': 50.0,
      };

      // Act
      final statisticsData = StatisticsData(
        categoryTotals: {},
        dailyTotals: {},
        paymentMethodTotals: paymentMethodTotals,
        totalAmount: 600.0,
      );

      // Assert
      expect(statisticsData.paymentMethodTotals.length, equals(4));
      expect(statisticsData.paymentMethodTotals['Cash'], equals(150.0));
      expect(statisticsData.paymentMethodTotals['Credit Card'], equals(300.0));
      expect(statisticsData.paymentMethodTotals['Debit Card'], equals(100.0));
      expect(statisticsData.paymentMethodTotals['Mobile Payment'], equals(50.0));
    });

    test('should preserve exact decimal values', () {
      // Arrange
      final categoryTotals = {
        ExpenseCategory.food: 123.45,
        ExpenseCategory.transport: 67.89,
      };

      // Act
      final statisticsData = StatisticsData(
        categoryTotals: categoryTotals,
        dailyTotals: {},
        paymentMethodTotals: {},
        totalAmount: 191.34,
      );

      // Assert
      expect(statisticsData.categoryTotals[ExpenseCategory.food], equals(123.45));
      expect(statisticsData.categoryTotals[ExpenseCategory.transport], equals(67.89));
      expect(statisticsData.totalAmount, equals(191.34));
    });
  });

  group('statisticsDataProvider', () {
    // Note: statisticsDataProvider requires database initialization (Drift)
    // and depends on expenseListProvider (StreamProvider) and paymentMethodListProvider.
    // Following project patterns (see expense_providers_test.dart), providers that
    // require database are tested indirectly through integration tests rather than
    // unit tests, as mocking the full Riverpod + Drift stack is complex.
    //
    // Integration tests cover:
    // - Category aggregation (8 categories)
    // - Daily totals aggregation (date normalization)
    // - Payment method aggregation
    // - Total amount calculation
    // - Empty expense list handling
    // - Period filtering logic
    //
    // See: test/integration_test/ for full provider integration tests
  });
}

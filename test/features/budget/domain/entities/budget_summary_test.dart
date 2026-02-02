import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

void main() {
  group('BudgetSummary', () {
    test('creates instance with all required fields', () {
      final summary = BudgetSummary(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        remaining: 600.0,
        percentUsed: 40.0,
        status: BudgetStatus.comfortable,
        categoryBreakdown: {
          ExpenseCategory.food: 200.0,
          ExpenseCategory.transport: 200.0,
        },
        dailyAverage: 50.0,
        daysRemaining: 5,
        dailyBudgetRemaining: 120.0,
      );

      expect(summary.tripId, 1);
      expect(summary.totalBudget, 1000.0);
      expect(summary.totalSpent, 400.0);
      expect(summary.remaining, 600.0);
      expect(summary.percentUsed, 40.0);
      expect(summary.status, BudgetStatus.comfortable);
      expect(summary.categoryBreakdown.length, 2);
      expect(summary.dailyAverage, 50.0);
      expect(summary.daysRemaining, 5);
      expect(summary.dailyBudgetRemaining, 120.0);
    });

    test('supports equality comparison', () {
      final summary1 = BudgetSummary(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        remaining: 600.0,
        percentUsed: 40.0,
        status: BudgetStatus.comfortable,
        categoryBreakdown: {ExpenseCategory.food: 200.0},
        dailyAverage: 50.0,
        daysRemaining: 5,
        dailyBudgetRemaining: 120.0,
      );

      final summary2 = BudgetSummary(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        remaining: 600.0,
        percentUsed: 40.0,
        status: BudgetStatus.comfortable,
        categoryBreakdown: {ExpenseCategory.food: 200.0},
        dailyAverage: 50.0,
        daysRemaining: 5,
        dailyBudgetRemaining: 120.0,
      );

      expect(summary1, summary2);
    });

    test('supports copyWith', () {
      final original = BudgetSummary(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        remaining: 600.0,
        percentUsed: 40.0,
        status: BudgetStatus.comfortable,
        categoryBreakdown: {ExpenseCategory.food: 200.0},
        dailyAverage: 50.0,
        daysRemaining: 5,
        dailyBudgetRemaining: 120.0,
      );

      final modified = original.copyWith(totalSpent: 500.0);

      expect(modified.totalSpent, 500.0);
      expect(modified.tripId, 1);
      expect(modified.totalBudget, 1000.0);
    });
  });

  group('BudgetStatus', () {
    test('has all expected values', () {
      expect(BudgetStatus.values.length, 4);
      expect(BudgetStatus.values, contains(BudgetStatus.comfortable));
      expect(BudgetStatus.values, contains(BudgetStatus.caution));
      expect(BudgetStatus.values, contains(BudgetStatus.warning));
      expect(BudgetStatus.values, contains(BudgetStatus.exceeded));
    });
  });
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

part 'budget_summary.freezed.dart';

enum BudgetStatus {
  comfortable,  // < 50%
  caution,      // 50-75%
  warning,      // 75-100%
  exceeded,     // >= 100%
}

@freezed
abstract class BudgetSummary with _$BudgetSummary {
  const factory BudgetSummary({
    required int tripId,
    required double totalBudget,
    required double totalSpent,
    required double remaining,
    required double percentUsed,
    required BudgetStatus status,
    required Map<ExpenseCategory, double> categoryBreakdown,
    required double dailyAverage,
    required int daysRemaining,
    required double dailyBudgetRemaining,
  }) = _BudgetSummary;
}

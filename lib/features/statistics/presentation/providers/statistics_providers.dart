import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/payment_method/presentation/providers/payment_method_providers.dart';

/// Statistics data for a trip
class StatisticsData {
  final Map<ExpenseCategory, double> categoryTotals;
  final Map<DateTime, double> dailyTotals;
  final Map<String, double> paymentMethodTotals;
  final double totalAmount;
  final Map<ExpenseCategory, Map<DateTime, double>> categoryDailyTotals;

  const StatisticsData({
    required this.categoryTotals,
    required this.dailyTotals,
    required this.paymentMethodTotals,
    required this.totalAmount,
    required this.categoryDailyTotals,
  });
}

/// Provider that computes statistics data for a trip
final statisticsDataProvider = FutureProvider.family<StatisticsData, int>((ref, tripId) async {
  // Watch expense list
  final expensesAsync = await ref.watch(expenseListProvider(tripId).future);

  // Watch payment methods
  final paymentMethods = await ref.watch(paymentMethodListProvider.future);

  // Compute category totals
  final categoryTotals = <ExpenseCategory, double>{};
  for (final category in ExpenseCategory.values) {
    categoryTotals[category] = 0.0;
  }

  // Compute daily totals
  final dailyTotals = <DateTime, double>{};

  // Compute payment method totals
  final paymentMethodTotals = <String, double>{};

  // Compute category daily totals
  final categoryDailyTotals = <ExpenseCategory, Map<DateTime, double>>{};

  double totalAmount = 0.0;

  for (final expense in expensesAsync) {
    // Category totals
    categoryTotals[expense.category] =
        (categoryTotals[expense.category] ?? 0.0) + expense.convertedAmount;

    // Daily totals (normalize to date only)
    final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
    dailyTotals[date] = (dailyTotals[date] ?? 0.0) + expense.convertedAmount;

    // Payment method totals
    final paymentMethod = paymentMethods.firstWhere(
      (m) => m.id == expense.paymentMethodId,
      orElse: () => throw Exception('Payment method not found'),
    );
    paymentMethodTotals[paymentMethod.name] =
        (paymentMethodTotals[paymentMethod.name] ?? 0.0) + expense.convertedAmount;

    // Category daily totals
    categoryDailyTotals.putIfAbsent(expense.category, () => <DateTime, double>{});
    categoryDailyTotals[expense.category]![date] =
        (categoryDailyTotals[expense.category]![date] ?? 0.0) + expense.convertedAmount;

    // Total amount
    totalAmount += expense.convertedAmount;
  }

  return StatisticsData(
    categoryTotals: categoryTotals,
    dailyTotals: dailyTotals,
    paymentMethodTotals: paymentMethodTotals,
    totalAmount: totalAmount,
    categoryDailyTotals: categoryDailyTotals,
  );
});

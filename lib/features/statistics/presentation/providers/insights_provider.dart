import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/generate_insights.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/detect_anomalies.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';

/// Wrapper class for insights data with custom equality
class InsightsData {
  final List<AnalyticsInsight> insights;

  const InsightsData({required this.insights});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightsData &&
          runtimeType == other.runtimeType &&
          listEquals(insights, other.insights);

  @override
  int get hashCode => insights.hashCode;
}

/// Provider that generates intelligent insights for a trip
final insightsProvider =
    FutureProvider.family<InsightsData, int>((ref, tripId) async {
  final stats = await ref.watch(statisticsDataProvider(tripId).future);

  // Try to get budget data (optional - trip may not have a budget)
  double? totalBudget;
  double? budgetRemaining;
  int? daysRemaining;
  double? dailyBudgetRemaining;
  double? dailyAverage;

  try {
    final budget = await ref.watch(budgetSummaryProvider(tripId).future);
    totalBudget = budget.totalBudget;
    budgetRemaining = budget.remaining;
    daysRemaining = budget.daysRemaining;
    dailyBudgetRemaining = budget.dailyBudgetRemaining;
    dailyAverage = budget.dailyAverage;
  } catch (_) {
    // Budget data not available - that's fine, we'll generate insights without it
  }

  final generateInsights = GenerateInsights();
  final detectAnomalies = DetectAnomalies();

  // Convert ExpenseCategory keys to String
  final categoryTotals = <String, double>{};
  stats.categoryTotals.forEach((category, amount) {
    if (amount > 0) {
      categoryTotals[category.name] = amount;
    }
  });

  // Generate spending & budget insights
  final insights = generateInsights.call(
    categoryTotals: categoryTotals,
    totalAmount: stats.totalAmount,
    totalBudget: totalBudget,
    budgetRemaining: budgetRemaining,
    daysRemaining: daysRemaining,
    dailyBudgetRemaining: dailyBudgetRemaining,
    dailyAverage: dailyAverage,
  );

  // Detect anomalies
  final anomalies = detectAnomalies.call(
    dailyTotals: stats.dailyTotals,
    categoryTotals: categoryTotals,
    totalBudget: totalBudget,
  );

  // Combine and sort by priority (high first)
  final allInsights = [...insights, ...anomalies];
  allInsights.sort((a, b) => a.priority.index.compareTo(b.priority.index));

  return InsightsData(insights: allInsights);
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/statistics/domain/entities/comparison_result.dart';
import 'package:trip_wallet/features/statistics/domain/entities/category_insight.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/compare_period_statistics.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/generate_category_insights.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';


/// Period comparison data containing overall and category comparisons
class PeriodComparisonData {
  final List<ComparisonResult> comparisons;
  final String periodLabel;

  const PeriodComparisonData({
    required this.comparisons,
    required this.periodLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodComparisonData &&
          runtimeType == other.runtimeType &&
          listEquals(comparisons, other.comparisons) &&
          periodLabel == other.periodLabel;

  @override
  int get hashCode => Object.hash(comparisons, periodLabel);
}

/// Category insights data
class CategoryInsightsData {
  final List<CategoryInsight> insights;

  const CategoryInsightsData({required this.insights});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryInsightsData &&
          runtimeType == other.runtimeType &&
          listEquals(insights, other.insights);

  @override
  int get hashCode => insights.hashCode;
}

/// Provider that compares spending between current and previous week
final periodComparisonProvider =
    FutureProvider.family<PeriodComparisonData, int>((ref, tripId) async {
  final stats = await ref.watch(statisticsDataProvider(tripId).future);

  final comparePeriod = ComparePeriodStatistics();

  // Split daily totals into current week and previous week
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  final twoWeeksAgo = now.subtract(const Duration(days: 14));

  final currentWeek = <DateTime, double>{};
  final previousWeek = <DateTime, double>{};

  stats.dailyTotals.forEach((date, amount) {
    if (date.isAfter(weekAgo)) {
      currentWeek[date] = amount;
    } else if (date.isAfter(twoWeeksAgo)) {
      previousWeek[date] = amount;
    }
  });

  // Overall period comparison
  final overallComparison = comparePeriod.call(
    currentDailyTotals: currentWeek,
    previousDailyTotals: previousWeek,
    label: 'totalExpense',
  );

  // Category comparison
  // Convert ExpenseCategory keys to String for the use case
  final currentCategoryTotals = <String, double>{};
  final previousCategoryTotals = <String, double>{};

  // For now, use overall category totals as approximation
  // TODO: Split category data by time period
  stats.categoryTotals.forEach((category, amount) {
    currentCategoryTotals[category.name] = amount;
  });

  final categoryComparisons = comparePeriod.compareCategories(
    currentCategoryTotals: currentCategoryTotals,
    previousCategoryTotals: previousCategoryTotals,
  );

  return PeriodComparisonData(
    comparisons: [overallComparison, ...categoryComparisons],
    periodLabel: 'thisWeekVsLastWeek',
  );
});

/// Provider that generates category insights for a trip
final categoryInsightsProvider =
    FutureProvider.family<CategoryInsightsData, int>((ref, tripId) async {
  final stats = await ref.watch(statisticsDataProvider(tripId).future);

  final generateInsights = GenerateCategoryInsights();

  // Convert ExpenseCategory keys to String
  final categoryTotals = <String, double>{};
  stats.categoryTotals.forEach((category, amount) {
    if (amount > 0) {
      categoryTotals[category.name] = amount;
    }
  });

  final insights = generateInsights.call(
    categoryTotals: categoryTotals,
  );

  return CategoryInsightsData(insights: insights);
});

import '../entities/category_insight.dart';

/// Use case for generating insights for each expense category
///
/// Analyzes category spending data to produce ranked insights with
/// percentages and optional comparison to previous period.
class GenerateCategoryInsights {
  /// Generate category insights from spending data
  ///
  /// [categoryTotals] - Map of category name to total spending
  /// [previousCategoryTotals] - Optional previous period data for comparison
  /// [topExpenseDescriptions] - Optional map of category to top expense descriptions
  List<CategoryInsight> call({
    required Map<String, double> categoryTotals,
    Map<String, double>? previousCategoryTotals,
    Map<String, List<String>>? topExpenseDescriptions,
  }) {
    if (categoryTotals.isEmpty) return [];

    final totalAmount = categoryTotals.values.fold(0.0, (sum, v) => sum + v);

    // Sort categories by amount descending
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryEntry = entry.value;
      final category = categoryEntry.key;
      final amount = categoryEntry.value;

      // Calculate percentage
      final percentage = totalAmount > 0 ? (amount / totalAmount) * 100 : 0.0;

      // Previous period comparison
      double? previousAmount;
      double? changePercentage;

      if (previousCategoryTotals != null) {
        previousAmount = previousCategoryTotals[category] ?? 0.0;
        changePercentage = _calculatePercentageChange(previousAmount, amount);
      }

      // Top expense descriptions
      final descriptions = topExpenseDescriptions?[category] ?? [];

      return CategoryInsight(
        category: category,
        amount: amount,
        percentage: percentage,
        rank: index + 1,
        topExpenseDescriptions: descriptions,
        previousAmount: previousAmount,
        changePercentage: changePercentage,
      );
    }).toList();
  }

  double _calculatePercentageChange(double previousValue, double currentValue) {
    if (previousValue == 0.0) {
      return currentValue == 0.0 ? 0.0 : 100.0;
    }
    return ((currentValue - previousValue) / previousValue) * 100;
  }
}

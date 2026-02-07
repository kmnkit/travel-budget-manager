import '../entities/comparison_result.dart';
import '../entities/trend_data.dart';

/// Use case for comparing spending statistics between two time periods
///
/// Compares total spending, calculates difference and percentage change,
/// and determines the trend direction.
class ComparePeriodStatistics {
  /// Compare total spending between current and previous periods
  ///
  /// [currentDailyTotals] - Daily spending map for current period
  /// [previousDailyTotals] - Daily spending map for previous period
  /// [label] - Description label for the comparison
  ComparisonResult call({
    required Map<DateTime, double> currentDailyTotals,
    required Map<DateTime, double> previousDailyTotals,
    required String label,
  }) {
    final currentTotal =
        currentDailyTotals.values.fold(0.0, (sum, v) => sum + v);
    final previousTotal =
        previousDailyTotals.values.fold(0.0, (sum, v) => sum + v);

    final difference = currentTotal - previousTotal;
    final percentageChange =
        _calculatePercentageChange(previousTotal, currentTotal);
    final direction = _determineDirection(percentageChange);

    return ComparisonResult(
      label: label,
      currentValue: currentTotal,
      comparisonValue: previousTotal,
      difference: difference,
      percentageChange: percentageChange,
      direction: direction,
    );
  }

  /// Compare spending by category between two periods
  ///
  /// Returns a list of ComparisonResult, one per category found in either period
  List<ComparisonResult> compareCategories({
    required Map<String, double> currentCategoryTotals,
    required Map<String, double> previousCategoryTotals,
  }) {
    final allCategories = <String>{
      ...currentCategoryTotals.keys,
      ...previousCategoryTotals.keys,
    };

    return allCategories.map((category) {
      final current = currentCategoryTotals[category] ?? 0.0;
      final previous = previousCategoryTotals[category] ?? 0.0;
      final difference = current - previous;
      final percentageChange =
          _calculatePercentageChange(previous, current);
      final direction = _determineDirection(percentageChange);

      return ComparisonResult(
        label: category,
        currentValue: current,
        comparisonValue: previous,
        difference: difference,
        percentageChange: percentageChange,
        direction: direction,
      );
    }).toList();
  }

  double _calculatePercentageChange(double previousValue, double currentValue) {
    if (previousValue == 0.0) {
      return currentValue == 0.0 ? 0.0 : 100.0;
    }
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  TrendDirection _determineDirection(double percentageChange) {
    const stableThreshold = 5.0;
    if (percentageChange.abs() < stableThreshold) {
      return TrendDirection.stable;
    } else if (percentageChange > 0) {
      return TrendDirection.up;
    } else {
      return TrendDirection.down;
    }
  }
}

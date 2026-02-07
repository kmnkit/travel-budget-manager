import 'dart:math' as math;
import '../entities/budget_forecast.dart';
import '../entities/trend_data.dart';

/// Use case for calculating budget forecast with linear projection
///
/// Calculates:
/// - Daily spending rate (average)
/// - Projected total spend based on linear extrapolation
/// - Days until budget exhaustion
/// - Confidence interval (1-sigma, 68%)
/// - Cumulative historical and projected spending data points
class CalculateBudgetForecast {
  BudgetForecast call({
    required double totalBudget,
    required Map<DateTime, double> dailySpending,
    required DateTime tripStartDate,
    required DateTime tripEndDate,
  }) {
    // Sort daily spending by date
    final sortedEntries = dailySpending.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Calculate totals
    final totalSpent = sortedEntries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.value,
    );

    final daysElapsed = sortedEntries.length;
    final totalTripDays = tripEndDate.difference(tripStartDate).inDays + 1;
    final daysRemaining = math.max(0, totalTripDays - daysElapsed);

    // Calculate daily spending rate
    final dailyRate = daysElapsed > 0 ? totalSpent / daysElapsed : 0.0;

    // Linear projection: current spent + rate * remaining days
    final projectedTotalSpend = totalSpent + (dailyRate * daysRemaining);

    // Days until budget exhaustion
    int? daysUntilExhaustion;
    if (dailyRate > 0) {
      final remaining = totalBudget - totalSpent;
      if (remaining <= 0) {
        daysUntilExhaustion = 0;
      } else {
        daysUntilExhaustion = (remaining / dailyRate).floor();
      }
    }

    // Determine forecast status
    final status = _determineStatus(
      totalBudget: totalBudget,
      totalSpent: totalSpent,
      projectedTotalSpend: projectedTotalSpend,
    );

    // Generate cumulative historical spending data points
    final historicalSpending = <DataPoint>[];
    double cumulative = 0.0;
    for (final entry in sortedEntries) {
      cumulative += entry.value;
      historicalSpending.add(DataPoint(date: entry.key, value: cumulative));
    }

    // Generate projected spending data points
    final projectedSpending = <DataPoint>[];
    if (daysElapsed > 0 && daysRemaining > 0) {
      final lastDate = sortedEntries.last.key;
      double projCumulative = totalSpent;
      for (int i = 1; i <= daysRemaining; i++) {
        projCumulative += dailyRate;
        projectedSpending.add(DataPoint(
          date: lastDate.add(Duration(days: i)),
          value: projCumulative,
        ));
      }
    }

    // Generate budget line (flat horizontal line)
    final budgetLine = <DataPoint>[
      DataPoint(date: tripStartDate, value: totalBudget),
      DataPoint(date: tripEndDate, value: totalBudget),
    ];

    // Calculate confidence interval (1-sigma, 68%)
    final confidenceInterval = _calculateConfidenceInterval(
      sortedEntries.map((e) => e.value).toList(),
      totalSpent,
      daysRemaining,
    );

    return BudgetForecast(
      tripId: 0, // Will be set by provider
      totalBudget: totalBudget,
      totalSpent: totalSpent,
      dailySpendingRate: dailyRate,
      projectedTotalSpend: projectedTotalSpend,
      daysElapsed: daysElapsed,
      daysRemaining: daysRemaining,
      daysUntilExhaustion: daysUntilExhaustion,
      status: status,
      historicalSpending: historicalSpending,
      projectedSpending: projectedSpending,
      budgetLine: budgetLine,
      confidenceInterval: confidenceInterval,
    );
  }

  /// Determine forecast status based on spending vs budget
  ForecastStatus _determineStatus({
    required double totalBudget,
    required double totalSpent,
    required double projectedTotalSpend,
  }) {
    // Already exhausted
    if (totalSpent >= totalBudget) {
      return ForecastStatus.exhausted;
    }

    if (totalBudget == 0) {
      return ForecastStatus.exhausted;
    }

    final projectedPercentage = projectedTotalSpend / totalBudget;

    if (projectedPercentage > 1.0) {
      return ForecastStatus.overBudget;
    } else if (projectedPercentage > 0.9) {
      return ForecastStatus.atRisk;
    } else {
      return ForecastStatus.onTrack;
    }
  }

  /// Calculate confidence interval based on standard deviation of daily spending
  ConfidenceInterval _calculateConfidenceInterval(
    List<double> dailyValues,
    double totalSpent,
    int daysRemaining,
  ) {
    if (dailyValues.length < 2) {
      // Not enough data for meaningful stddev
      final projected = totalSpent + (dailyValues.isEmpty ? 0.0 : dailyValues.first * daysRemaining);
      return ConfidenceInterval(
        bestCase: projected,
        worstCase: projected,
        confidenceLevel: 0.68,
      );
    }

    // Calculate mean
    final mean = dailyValues.reduce((a, b) => a + b) / dailyValues.length;

    // Calculate standard deviation
    final variance = dailyValues
            .map((v) => math.pow(v - mean, 2))
            .reduce((a, b) => a + b) /
        dailyValues.length;
    final stdDev = math.sqrt(variance);

    // 1-sigma confidence interval (68%)
    // Best case: lower daily rate for remaining days
    // Worst case: higher daily rate for remaining days
    final bestCase = totalSpent + ((mean - stdDev) * daysRemaining);
    final worstCase = totalSpent + ((mean + stdDev) * daysRemaining);

    return ConfidenceInterval(
      bestCase: math.max(totalSpent, bestCase), // Can't spend less than already spent
      worstCase: worstCase,
      confidenceLevel: 0.68,
    );
  }
}

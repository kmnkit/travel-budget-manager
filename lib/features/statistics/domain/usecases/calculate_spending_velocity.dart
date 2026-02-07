import 'dart:math' as math;
import '../entities/spending_velocity.dart';

/// Use case for calculating spending velocity and acceleration metrics
///
/// Analyzes daily spending patterns to determine:
/// - Daily average spending rate
/// - Weekly average spending rate
/// - Acceleration (rate of change in spending over time)
class CalculateSpendingVelocity {
  /// Calculate spending velocity from daily spending data
  ///
  /// [dailyData] - Map of dates to spending amounts
  ///
  /// Returns [SpendingVelocity] with calculated metrics
  SpendingVelocity call(Map<DateTime, double> dailyData) {
    if (dailyData.isEmpty) {
      throw ArgumentError('Daily data cannot be empty');
    }

    // Sort dates chronologically
    final sortedDates = dailyData.keys.toList()..sort();
    final periodStart = sortedDates.first;
    final periodEnd = sortedDates.last;

    // Calculate daily average
    final totalSpending = dailyData.values.reduce((a, b) => a + b);
    final numberOfDays = dailyData.length;
    final dailyAverage = totalSpending / numberOfDays;

    // Calculate weekly average (extrapolate from daily)
    final weeklyAverage = dailyAverage * 7;

    // Calculate acceleration (rate of change in spending over time)
    final acceleration = _calculateAcceleration(sortedDates, dailyData);

    return SpendingVelocity(
      dailyAverage: dailyAverage,
      weeklyAverage: weeklyAverage,
      acceleration: acceleration,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );
  }

  /// Calculate acceleration using linear regression
  ///
  /// Acceleration represents how the spending rate is changing:
  /// - Positive: spending is increasing over time
  /// - Negative: spending is decreasing over time
  /// - Zero: spending rate is stable
  double _calculateAcceleration(
    List<DateTime> sortedDates,
    Map<DateTime, double> dailyData,
  ) {
    if (sortedDates.length < 2) {
      return 0.0; // No acceleration for single day
    }

    // Convert dates to numeric x values (days since first date)
    final firstDate = sortedDates.first;
    final xValues = sortedDates
        .map((date) => date.difference(firstDate).inDays.toDouble())
        .toList();
    final yValues = sortedDates.map((date) => dailyData[date]!).toList();

    // Calculate linear regression slope (acceleration)
    return _calculateSlope(xValues, yValues);
  }

  /// Calculate slope using least squares linear regression
  double _calculateSlope(List<double> xValues, List<double> yValues) {
    final n = xValues.length;

    // Calculate means
    final xMean = xValues.reduce((a, b) => a + b) / n;
    final yMean = yValues.reduce((a, b) => a + b) / n;

    // Calculate slope: m = Σ((x - x̄)(y - ȳ)) / Σ((x - x̄)²)
    double numerator = 0;
    double denominator = 0;

    for (int i = 0; i < n; i++) {
      numerator += (xValues[i] - xMean) * (yValues[i] - yMean);
      denominator += math.pow(xValues[i] - xMean, 2);
    }

    if (denominator == 0) {
      return 0.0; // All x values are the same (shouldn't happen with dates)
    }

    return numerator / denominator;
  }
}

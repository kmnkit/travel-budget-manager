import 'dart:math' as math;
import '../entities/trend_data.dart';

/// Use case for calculating trend analysis from historical data points
///
/// Performs linear regression to determine:
/// - Trend direction (up, down, stable)
/// - Change percentage from first to last value
/// - Confidence score (R² coefficient)
/// - Optional future value projections
class CalculateTrendAnalysis {
  /// Calculate trend analysis from data points
  ///
  /// [dataPoints] - Historical data to analyze (minimum 2 points required)
  /// [projectDays] - Optional number of days to project into the future
  ///
  /// Returns [TrendData] with analysis results
  TrendData call(List<DataPoint> dataPoints, {int? projectDays}) {
    if (dataPoints.length < 2) {
      throw ArgumentError('At least 2 data points required for trend analysis');
    }

    // Sort by date to ensure chronological order
    final sortedPoints = List<DataPoint>.from(dataPoints)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate linear regression
    final regression = _calculateLinearRegression(sortedPoints);

    // Determine trend direction
    final direction = _determineTrendDirection(
      regression.slope,
      sortedPoints.first.value,
      sortedPoints.last.value,
    );

    // Calculate change percentage
    final changePercentage = _calculateChangePercentage(
      sortedPoints.first.value,
      sortedPoints.last.value,
    );

    // Generate projected data if requested
    final projectedData = projectDays != null && projectDays > 0
        ? _generateProjections(sortedPoints, regression, projectDays)
        : null;

    return TrendData(
      historicalData: sortedPoints,
      projectedData: projectedData,
      direction: direction,
      changePercentage: changePercentage,
      confidence: regression.rSquared,
    );
  }

  /// Calculate linear regression parameters
  _LinearRegression _calculateLinearRegression(List<DataPoint> points) {
    // Convert dates to numeric x values (days since first point)
    final firstDate = points.first.date;
    final xValues = points
        .map((p) => p.date.difference(firstDate).inDays.toDouble())
        .toList();
    final yValues = points.map((p) => p.value).toList();

    final n = points.length;

    // Calculate means
    final xMean = xValues.reduce((a, b) => a + b) / n;
    final yMean = yValues.reduce((a, b) => a + b) / n;

    // Calculate slope (m) and intercept (b) for y = mx + b
    double numerator = 0;
    double denominator = 0;

    for (int i = 0; i < n; i++) {
      numerator += (xValues[i] - xMean) * (yValues[i] - yMean);
      denominator += math.pow(xValues[i] - xMean, 2);
    }

    final slope = denominator != 0 ? numerator / denominator : 0.0;
    final intercept = yMean - (slope * xMean);

    // Calculate R² (coefficient of determination)
    final rSquared = _calculateRSquared(xValues, yValues, slope, intercept);

    return _LinearRegression(
      slope: slope,
      intercept: intercept,
      rSquared: rSquared,
    );
  }

  /// Calculate R² coefficient (goodness of fit)
  double _calculateRSquared(
    List<double> xValues,
    List<double> yValues,
    double slope,
    double intercept,
  ) {
    final n = xValues.length;
    final yMean = yValues.reduce((a, b) => a + b) / n;

    double ssTotal = 0; // Total sum of squares
    double ssResidual = 0; // Residual sum of squares

    for (int i = 0; i < n; i++) {
      final yPredicted = slope * xValues[i] + intercept;
      ssTotal += math.pow(yValues[i] - yMean, 2);
      ssResidual += math.pow(yValues[i] - yPredicted, 2);
    }

    if (ssTotal == 0) return 1.0; // Perfect fit (all values identical)

    final rSquared = 1 - (ssResidual / ssTotal);
    return rSquared.clamp(0.0, 1.0); // Ensure 0 ≤ R² ≤ 1
  }

  /// Determine trend direction based on slope and actual change
  TrendDirection _determineTrendDirection(
    double slope,
    double firstValue,
    double lastValue,
  ) {
    // Use actual change percentage for direction
    final changePercent = _calculateChangePercentage(firstValue, lastValue);

    // Threshold for "stable" classification (less than 5% change)
    const stableThreshold = 5.0;

    if (changePercent.abs() < stableThreshold) {
      return TrendDirection.stable;
    } else if (changePercent > 0) {
      return TrendDirection.up;
    } else {
      return TrendDirection.down;
    }
  }

  /// Calculate percentage change from first to last value
  double _calculateChangePercentage(double firstValue, double lastValue) {
    if (firstValue == 0) {
      return lastValue == 0 ? 0.0 : 100.0; // Avoid division by zero
    }
    return ((lastValue - firstValue) / firstValue) * 100;
  }

  /// Generate future projections based on trend line
  List<DataPoint> _generateProjections(
    List<DataPoint> historicalPoints,
    _LinearRegression regression,
    int days,
  ) {
    final projections = <DataPoint>[];
    final lastDate = historicalPoints.last.date;
    final firstDate = historicalPoints.first.date;

    for (int i = 1; i <= days; i++) {
      final futureDate = lastDate.add(Duration(days: i));
      final x = futureDate.difference(firstDate).inDays.toDouble();
      final predictedValue = regression.slope * x + regression.intercept;

      // Ensure projected values don't go negative
      final clampedValue = math.max(0.0, predictedValue);

      projections.add(DataPoint(
        date: futureDate,
        value: clampedValue,
      ));
    }

    return projections;
  }
}

/// Internal class to hold linear regression results
class _LinearRegression {
  final double slope;
  final double intercept;
  final double rSquared;

  _LinearRegression({
    required this.slope,
    required this.intercept,
    required this.rSquared,
  });
}

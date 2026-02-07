import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/domain/entities/spending_velocity.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_trend_analysis.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_spending_velocity.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// Trend analysis data containing category-specific and overall trends
class TrendAnalysisData {
  final Map<String, TrendData> categoryTrends;
  final TrendData overallTrend;

  const TrendAnalysisData({
    required this.categoryTrends,
    required this.overallTrend,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendAnalysisData &&
          runtimeType == other.runtimeType &&
          _mapEquals(categoryTrends, other.categoryTrends) &&
          overallTrend == other.overallTrend;

  @override
  int get hashCode => Object.hash(categoryTrends, overallTrend);

  bool _mapEquals(Map<String, TrendData> a, Map<String, TrendData> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

/// Spending velocity data
class SpendingVelocityData {
  final SpendingVelocity velocity;

  const SpendingVelocityData({
    required this.velocity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpendingVelocityData &&
          runtimeType == other.runtimeType &&
          velocity == other.velocity;

  @override
  int get hashCode => velocity.hashCode;
}

/// Provider that calculates trend analysis for a trip
final trendAnalysisProvider =
    FutureProvider.family<TrendAnalysisData, int>((ref, tripId) async {
  // Get statistics data
  final stats = await ref.watch(statisticsDataProvider(tripId).future);

  // Use case for trend calculation
  final calculateTrend = CalculateTrendAnalysis();

  // Convert daily totals to data points
  final dailyDataPoints = stats.dailyTotals.entries
      .map((e) => DataPoint(date: e.key, value: e.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  // Calculate overall trend (with 7-day projection)
  final overallTrend = dailyDataPoints.length >= 2
      ? calculateTrend(dailyDataPoints, projectDays: 7)
      : TrendData(
          historicalData: dailyDataPoints,
          projectedData: null,
          direction: TrendDirection.stable,
          changePercentage: 0.0,
          confidence: 0.0,
        );

  // Calculate category-specific trends
  final categoryTrends = <String, TrendData>{};

  for (final category in ExpenseCategory.values) {
    final categoryTotal = stats.categoryTotals[category] ?? 0.0;
    if (categoryTotal > 0) {
      // For category trends, we need daily breakdown by category
      // For now, use overall trend as approximation
      // TODO: In future, break down daily data by category
      final categoryDataPoints = dailyDataPoints.map((dp) {
        // Approximate category portion of daily spending
        final proportion = categoryTotal / stats.totalAmount;
        return DataPoint(date: dp.date, value: dp.value * proportion);
      }).toList();

      if (categoryDataPoints.length >= 2) {
        categoryTrends[category.name] = calculateTrend(categoryDataPoints);
      }
    }
  }

  return TrendAnalysisData(
    categoryTrends: categoryTrends,
    overallTrend: overallTrend,
  );
});

/// Provider that calculates spending velocity for a trip
final spendingVelocityProvider =
    FutureProvider.family<SpendingVelocityData, int>((ref, tripId) async {
  // Get statistics data
  final stats = await ref.watch(statisticsDataProvider(tripId).future);

  // Use case for velocity calculation
  final calculateVelocity = CalculateSpendingVelocity();

  // Calculate velocity from daily data
  final velocity = stats.dailyTotals.isNotEmpty
      ? calculateVelocity(stats.dailyTotals)
      : SpendingVelocity(
          dailyAverage: 0.0,
          weeklyAverage: 0.0,
          acceleration: 0.0,
          periodStart: DateTime.now(),
          periodEnd: DateTime.now(),
        );

  return SpendingVelocityData(velocity: velocity);
});

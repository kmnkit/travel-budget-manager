import 'package:freezed_annotation/freezed_annotation.dart';
import 'trend_data.dart';

part 'budget_forecast.freezed.dart';

/// Status of budget forecast
enum ForecastStatus {
  onTrack,     // Projected spend <= 90% of budget
  atRisk,      // Projected spend > 90% but <= 100% of budget
  overBudget,  // Projected spend > 100% of budget
  exhausted,   // Already spent >= 100% of budget
}

/// Confidence interval for budget projection
@freezed
abstract class ConfidenceInterval with _$ConfidenceInterval {
  const factory ConfidenceInterval({
    required double bestCase,
    required double worstCase,
    required double confidenceLevel,
  }) = _ConfidenceInterval;
}

/// Budget forecast data with projections and confidence intervals
@freezed
abstract class BudgetForecast with _$BudgetForecast {
  const factory BudgetForecast({
    required int tripId,
    required double totalBudget,
    required double totalSpent,
    required double dailySpendingRate,
    required double projectedTotalSpend,
    required int daysElapsed,
    required int daysRemaining,
    required int? daysUntilExhaustion,
    required ForecastStatus status,
    required List<DataPoint> historicalSpending,
    required List<DataPoint> projectedSpending,
    required List<DataPoint> budgetLine,
    required ConfidenceInterval confidenceInterval,
  }) = _BudgetForecast;
}

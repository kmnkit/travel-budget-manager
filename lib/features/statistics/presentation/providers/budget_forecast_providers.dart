import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_budget_forecast.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';

/// Wrapper for budget forecast data with custom equality
class BudgetForecastData {
  final BudgetForecast forecast;

  const BudgetForecastData({required this.forecast});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetForecastData &&
          runtimeType == other.runtimeType &&
          forecast == other.forecast;

  @override
  int get hashCode => forecast.hashCode;
}

/// Provider that calculates budget forecast for a trip
final budgetForecastProvider =
    FutureProvider.family<BudgetForecastData, int>((ref, tripId) async {
  // Get statistics data (daily spending)
  final stats = await ref.watch(statisticsDataProvider(tripId).future);

  // Get budget summary
  final budgetSummary = await ref.watch(budgetSummaryProvider(tripId).future);

  // Get trip details for start/end dates
  final trip = await ref.watch(tripDetailProvider(tripId).future);

  if (trip == null) {
    throw Exception('Trip not found');
  }

  // Skip if no budget set
  if (budgetSummary.totalBudget <= 0) {
    return BudgetForecastData(
      forecast: BudgetForecast(
        tripId: tripId,
        totalBudget: 0.0,
        totalSpent: 0.0,
        dailySpendingRate: 0.0,
        projectedTotalSpend: 0.0,
        daysElapsed: 0,
        daysRemaining: 0,
        daysUntilExhaustion: null,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: const ConfidenceInterval(
          bestCase: 0.0,
          worstCase: 0.0,
          confidenceLevel: 0.68,
        ),
      ),
    );
  }

  // Calculate forecast
  final calculateForecast = CalculateBudgetForecast();
  final forecast = calculateForecast(
    totalBudget: budgetSummary.totalBudget,
    dailySpending: stats.dailyTotals,
    tripStartDate: trip.startDate,
    tripEndDate: trip.endDate,
  );

  // Override tripId from use case
  return BudgetForecastData(
    forecast: forecast.copyWith(tripId: tripId),
  );
});

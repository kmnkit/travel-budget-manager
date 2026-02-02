import 'package:trip_wallet/core/errors/failures.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Use case for calculating budget summary for a trip.
///
/// Computes budget metrics by combining trip budget data with expense totals.
class GetBudgetSummary {
  final TripRepository tripRepository;
  final ExpenseRepository expenseRepository;

  const GetBudgetSummary(this.tripRepository, this.expenseRepository);

  /// Calculates budget summary for the given trip ID.
  ///
  /// Throws [NotFoundFailure] if trip does not exist.
  Future<BudgetSummary> call(int tripId) async {
    final trip = await tripRepository.getTripById(tripId);
    if (trip == null) {
      throw const NotFoundFailure('Trip not found');
    }

    final totalSpent = await expenseRepository.getTotalByTrip(tripId);
    final categoryTotals = await expenseRepository.getCategoryTotals(tripId);

    final remaining = trip.budget - totalSpent;
    final percentUsed = trip.budget > 0 ? (totalSpent / trip.budget) * 100 : 0.0;

    // Calculate daily metrics
    final now = DateTime.now();
    final daysRemaining = trip.endDate.difference(now).inDays.clamp(0, 999999);
    final totalDays = trip.endDate.difference(trip.startDate).inDays;
    final daysElapsed = now.difference(trip.startDate).inDays.clamp(1, totalDays);
    final dailyAverage = totalSpent / daysElapsed;
    final dailyBudgetRemaining = daysRemaining > 0 ? remaining / daysRemaining : 0.0;

    return BudgetSummary(
      tripId: tripId,
      totalBudget: trip.budget,
      totalSpent: totalSpent,
      remaining: remaining,
      percentUsed: percentUsed,
      status: _getStatus(percentUsed),
      categoryBreakdown: categoryTotals,
      dailyAverage: dailyAverage,
      daysRemaining: daysRemaining,
      dailyBudgetRemaining: dailyBudgetRemaining,
    );
  }

  BudgetStatus _getStatus(double percentUsed) {
    if (percentUsed >= 100) return BudgetStatus.exceeded;
    if (percentUsed >= 75) return BudgetStatus.warning;
    if (percentUsed >= 50) return BudgetStatus.caution;
    return BudgetStatus.comfortable;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/budget/domain/usecases/get_budget_summary.dart';
import 'package:trip_wallet/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:trip_wallet/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/shared/data/database.dart' as db;

// ============================================================================
// Expense Data Layer Providers (needed for budget)
// ============================================================================

/// Provides the local data source for expense operations
final expenseLocalDataSourceProvider = Provider<ExpenseLocalDatasource>((ref) {
  final database = ref.watch(db.databaseProvider);
  return ExpenseLocalDatasource(database);
});

/// Provides the expense repository implementation
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final dataSource = ref.watch(expenseLocalDataSourceProvider);
  return ExpenseRepositoryImpl(dataSource);
});

/// Provides a reactive stream of expenses for a trip
final expenseListProvider = StreamProvider.family<List<Expense>, int>((ref, tripId) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.watchExpensesByTrip(tripId);
});

// ============================================================================
// Budget Use Case Providers
// ============================================================================

/// Provides the GetBudgetSummary use case
final getBudgetSummaryProvider = Provider<GetBudgetSummary>((ref) {
  final tripRepo = ref.watch(tripRepositoryProvider);
  final expenseRepo = ref.watch(expenseRepositoryProvider);
  return GetBudgetSummary(tripRepo, expenseRepo);
});

// ============================================================================
// Budget State Providers
// ============================================================================

/// Provides budget summary for a trip (reactive)
///
/// This provider automatically recalculates when expenses change for the trip.
/// It uses FutureProvider.family to create a provider instance per trip ID.
///
/// The budget summary includes:
/// - Total budget and spending
/// - Remaining budget and percentage used
/// - Budget status (comfortable/caution/warning/exceeded)
/// - Category breakdown
/// - Daily metrics (average spent, days remaining, daily budget)
final budgetSummaryProvider = FutureProvider.family<BudgetSummary, int>((ref, tripId) async {
  // Watch expense list to trigger recalculation when expenses change
  ref.watch(expenseListProvider(tripId));

  final useCase = ref.watch(getBudgetSummaryProvider);
  return useCase(tripId);
});

// ============================================================================
// Total Balance Provider
// ============================================================================

/// Provides total balance across all trips (simple budget sum)
///
/// Uses the first trip's baseCurrency for display. Falls back to 'KRW'.
/// Note: Multi-currency conversion is out of scope; this is a simple sum.
final totalBalanceProvider = FutureProvider<({double total, String currency})>((ref) async {
  final trips = await ref.watch(tripListProvider.future);
  double total = 0;
  for (final trip in trips) {
    total += trip.budget;
  }
  final currency = trips.isNotEmpty ? trips.first.baseCurrency : 'KRW';
  return (total: total, currency: currency);
});

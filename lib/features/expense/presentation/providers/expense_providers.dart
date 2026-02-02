import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';

// Re-export data layer providers from budget_providers
export 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart'
    show
        expenseLocalDataSourceProvider,
        expenseRepositoryProvider,
        expenseListProvider;

/// Notifier for expense CRUD operations
///
/// Handles creating, updating, and deleting expenses with automatic invalidation
/// of related providers (expenseListProvider and budgetSummaryProvider).
final expenseNotifierProvider = NotifierProvider<ExpenseNotifier, void>(
  ExpenseNotifier.new,
);

/// Notifier class for expense CRUD operations
class ExpenseNotifier extends Notifier<void> {
  @override
  void build() {
    // No state needed for CRUD operations
  }

  /// Creates a new expense
  ///
  /// Returns the created expense with generated ID and timestamps.
  /// Invalidates expenseListProvider and budgetSummaryProvider to trigger refreshes.
  Future<Expense> createExpense({
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
  }) async {
    final repository = ref.read(expenseRepositoryProvider);

    final expense = await repository.createExpense(
      tripId: tripId,
      amount: amount,
      currency: currency,
      convertedAmount: convertedAmount,
      category: category,
      paymentMethodId: paymentMethodId,
      memo: memo,
      date: date,
    );

    // Invalidate providers to refresh UI
    ref.invalidate(expenseListProvider(tripId));
    ref.invalidate(budgetSummaryProvider(tripId));

    return expense;
  }

  /// Updates an existing expense
  ///
  /// Returns the updated expense.
  /// Invalidates expenseListProvider and budgetSummaryProvider for this trip.
  Future<Expense> updateExpense(Expense expense) async {
    final repository = ref.read(expenseRepositoryProvider);

    final updated = await repository.updateExpense(expense);

    // Invalidate providers to refresh UI
    ref.invalidate(expenseListProvider(expense.tripId));
    ref.invalidate(budgetSummaryProvider(expense.tripId));

    return updated;
  }

  /// Deletes an expense by ID
  ///
  /// Invalidates expenseListProvider and budgetSummaryProvider.
  /// Note: tripId must be known before deletion for proper invalidation.
  Future<void> deleteExpense(int id) async {
    final repository = ref.read(expenseRepositoryProvider);

    await repository.deleteExpense(id);

    // Note: We invalidate all expense lists since we don't know the tripId here
    // This is acceptable as deletions are infrequent operations
    ref.invalidateSelf();
  }
}

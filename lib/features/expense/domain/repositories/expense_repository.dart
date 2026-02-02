import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// Abstract repository interface for expense operations.
/// Domain layer defines the contract; data layer implements it.
abstract class ExpenseRepository {
  /// Get all expenses for a specific trip
  Future<List<Expense>> getExpensesByTrip(int tripId);

  /// Get a single expense by ID
  Future<Expense?> getExpenseById(int id);

  /// Create a new expense
  Future<Expense> createExpense({
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
  });

  /// Update an existing expense
  Future<Expense> updateExpense(Expense expense);

  /// Delete an expense by ID
  Future<void> deleteExpense(int id);

  /// Watch expenses for a trip (reactive stream)
  Stream<List<Expense>> watchExpensesByTrip(int tripId);

  /// Get total converted amount for a trip
  Future<double> getTotalByTrip(int tripId);

  /// Get totals grouped by category for a trip
  Future<Map<ExpenseCategory, double>> getCategoryTotals(int tripId);
}

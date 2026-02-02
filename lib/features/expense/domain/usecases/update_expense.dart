import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';

/// Use case to update an existing expense with validation
class UpdateExpense {
  final ExpenseRepository _repository;

  UpdateExpense(this._repository);

  Future<Expense> call(Expense expense) async {
    // Validate amount
    if (expense.amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }

    // Validate converted amount
    if (expense.convertedAmount <= 0) {
      throw ArgumentError('Converted amount must be positive');
    }

    // Validate currency
    if (expense.currency.length != 3) {
      throw ArgumentError('Currency must be a 3-letter code');
    }
    if (expense.currency != expense.currency.toUpperCase()) {
      throw ArgumentError('Currency must be uppercase');
    }

    // Validate date (cannot be in the future)
    final now = DateTime.now();
    if (expense.date.isAfter(now)) {
      throw ArgumentError('Date cannot be in the future');
    }

    // Update the expense
    return _repository.updateExpense(expense);
  }
}

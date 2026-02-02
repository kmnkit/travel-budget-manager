import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';

/// Use case to create a new expense with validation
class CreateExpense {
  final ExpenseRepository _repository;

  CreateExpense(this._repository);

  Future<Expense> call({
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
  }) async {
    // Validate amount
    if (amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }

    // Validate converted amount
    if (convertedAmount <= 0) {
      throw ArgumentError('Converted amount must be positive');
    }

    // Validate currency
    if (currency.length != 3) {
      throw ArgumentError('Currency must be a 3-letter code');
    }
    if (currency != currency.toUpperCase()) {
      throw ArgumentError('Currency must be uppercase');
    }

    // Validate date (cannot be in the future)
    final now = DateTime.now();
    if (date.isAfter(now)) {
      throw ArgumentError('Date cannot be in the future');
    }

    // Create the expense
    return _repository.createExpense(
      tripId: tripId,
      amount: amount,
      currency: currency,
      convertedAmount: convertedAmount,
      category: category,
      paymentMethodId: paymentMethodId,
      memo: memo,
      date: date,
    );
  }
}

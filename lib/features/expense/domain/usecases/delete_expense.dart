import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';

/// Use case to delete an expense
class DeleteExpense {
  final ExpenseRepository _repository;

  DeleteExpense(this._repository);

  Future<void> call(int id) {
    return _repository.deleteExpense(id);
  }
}

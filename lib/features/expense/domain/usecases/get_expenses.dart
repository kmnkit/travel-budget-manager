import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';

/// Use case to get all expenses for a trip
class GetExpensesByTrip {
  final ExpenseRepository _repository;

  GetExpensesByTrip(this._repository);

  Future<List<Expense>> call(int tripId) {
    return _repository.getExpensesByTrip(tripId);
  }
}

/// Use case to watch expenses for a trip (reactive)
class WatchExpensesByTrip {
  final ExpenseRepository _repository;

  WatchExpensesByTrip(this._repository);

  Stream<List<Expense>> call(int tripId) {
    return _repository.watchExpensesByTrip(tripId);
  }
}

/// Use case to get a single expense by ID
class GetExpenseById {
  final ExpenseRepository _repository;

  GetExpenseById(this._repository);

  Future<Expense?> call(int id) {
    return _repository.getExpenseById(id);
  }
}

/// Use case to get total converted amount for a trip
class GetTotalByTrip {
  final ExpenseRepository _repository;

  GetTotalByTrip(this._repository);

  Future<double> call(int tripId) {
    return _repository.getTotalByTrip(tripId);
  }
}

/// Use case to get category totals for a trip
class GetCategoryTotals {
  final ExpenseRepository _repository;

  GetCategoryTotals(this._repository);

  Future<Map<ExpenseCategory, double>> call(int tripId) {
    return _repository.getCategoryTotals(tripId);
  }
}

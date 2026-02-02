import 'package:trip_wallet/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart' as domain;
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/shared/data/database.dart' as db;

/// Implementation of ExpenseRepository using local datasource.
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource _datasource;

  ExpenseRepositoryImpl(this._datasource);

  @override
  Future<List<domain.Expense>> getExpensesByTrip(int tripId) async {
    final dataList = await _datasource.getByTripId(tripId);
    return dataList.map(_toEntity).toList();
  }

  @override
  Future<domain.Expense?> getExpenseById(int id) async {
    final data = await _datasource.getById(id);
    return data != null ? _toEntity(data) : null;
  }

  @override
  Future<domain.Expense> createExpense({
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
  }) async {
    final data = await _datasource.insert(
      tripId: tripId,
      amount: amount,
      currency: currency,
      convertedAmount: convertedAmount,
      category: category,
      paymentMethodId: paymentMethodId,
      memo: memo,
      date: date,
    );
    return _toEntity(data);
  }

  @override
  Future<domain.Expense> updateExpense(domain.Expense expense) async {
    final data = await _datasource.update(
      id: expense.id,
      tripId: expense.tripId,
      amount: expense.amount,
      currency: expense.currency,
      convertedAmount: expense.convertedAmount,
      category: expense.category,
      paymentMethodId: expense.paymentMethodId,
      memo: expense.memo,
      date: expense.date,
      createdAt: expense.createdAt,
    );
    return _toEntity(data);
  }

  @override
  Future<void> deleteExpense(int id) {
    return _datasource.delete(id);
  }

  @override
  Stream<List<domain.Expense>> watchExpensesByTrip(int tripId) {
    return _datasource.watchByTripId(tripId).map(
          (dataList) => dataList.map(_toEntity).toList(),
        );
  }

  @override
  Future<double> getTotalByTrip(int tripId) {
    return _datasource.getTotalByTripId(tripId);
  }

  @override
  Future<Map<ExpenseCategory, double>> getCategoryTotals(int tripId) {
    return _datasource.getCategoryTotalsByTripId(tripId);
  }

  /// Convert Drift data model to domain entity
  domain.Expense _toEntity(db.Expense data) {
    return domain.Expense(
      id: data.id,
      tripId: data.tripId,
      amount: data.amount,
      currency: data.currency,
      convertedAmount: data.convertedAmount,
      category: data.category,
      paymentMethodId: data.paymentMethodId,
      memo: data.memo,
      date: data.date,
      createdAt: data.createdAt,
    );
  }
}

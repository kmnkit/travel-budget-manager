import 'package:drift/drift.dart';
import 'package:trip_wallet/shared/data/database.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// Local data source for expense operations using Drift.
class ExpenseLocalDatasource {
  final AppDatabase _db;

  ExpenseLocalDatasource(this._db);

  /// Get all expenses for a trip
  Future<List<Expense>> getByTripId(int tripId) {
    return (_db.select(_db.expenses)..where((e) => e.tripId.equals(tripId))).get();
  }

  /// Get expense by ID
  Future<Expense?> getById(int id) {
    return (_db.select(_db.expenses)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Insert new expense
  Future<Expense> insert({
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
  }) async {
    final id = await _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            tripId: tripId,
            amount: amount,
            currency: currency,
            convertedAmount: convertedAmount,
            category: category,
            paymentMethodId: paymentMethodId,
            memo: Value(memo),
            date: date,
            createdAt: DateTime.now(),
          ),
        );

    final inserted = await getById(id);
    return inserted!;
  }

  /// Update existing expense
  Future<Expense> update({
    required int id,
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
    required DateTime createdAt,
  }) async {
    await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
          ExpensesCompanion(
            tripId: Value(tripId),
            amount: Value(amount),
            currency: Value(currency),
            convertedAmount: Value(convertedAmount),
            category: Value(category),
            paymentMethodId: Value(paymentMethodId),
            memo: Value(memo),
            date: Value(date),
            createdAt: Value(createdAt),
          ),
        );

    final updated = await getById(id);
    return updated!;
  }

  /// Delete expense
  Future<void> delete(int id) {
    return (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
  }

  /// Watch expenses for a trip (reactive stream)
  Stream<List<Expense>> watchByTripId(int tripId) {
    return (_db.select(_db.expenses)..where((e) => e.tripId.equals(tripId))).watch();
  }

  /// Get total converted amount for a trip
  Future<double> getTotalByTripId(int tripId) async {
    final query = _db.selectOnly(_db.expenses)
      ..addColumns([_db.expenses.convertedAmount.sum()])
      ..where(_db.expenses.tripId.equals(tripId));

    final result = await query.getSingleOrNull();
    return result?.read(_db.expenses.convertedAmount.sum()) ?? 0.0;
  }

  /// Get category totals for a trip
  Future<Map<ExpenseCategory, double>> getCategoryTotalsByTripId(int tripId) async {
    final query = _db.selectOnly(_db.expenses)
      ..addColumns([
        _db.expenses.category,
        _db.expenses.convertedAmount.sum(),
      ])
      ..where(_db.expenses.tripId.equals(tripId))
      ..groupBy([_db.expenses.category]);

    final results = await query.get();

    final map = <ExpenseCategory, double>{};
    for (final row in results) {
      final categoryIndex = row.read(_db.expenses.category)!;
      final category = ExpenseCategory.values[categoryIndex];
      final total = row.read(_db.expenses.convertedAmount.sum()) ?? 0.0;
      map[category] = total;
    }

    return map;
  }
}

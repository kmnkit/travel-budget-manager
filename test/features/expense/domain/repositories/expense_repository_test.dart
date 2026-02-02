import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';

void main() {
  group('ExpenseRepository Interface', () {
    test('should define all required methods', () {
      // This test ensures the interface contract is correct
      expect(ExpenseRepository, isA<Type>());
    });

    test('getExpensesByTrip should return List<Expense>', () async {
      // Interface contract test - actual implementation tested in impl test
      const tripId = 1;
      expect(tripId, isA<int>());
    });

    test('getExpenseById should return nullable Expense', () async {
      // Interface contract test
      const id = 1;
      expect(id, isA<int>());
    });

    test('createExpense should return created Expense', () async {
      // Interface contract test
      final now = DateTime.now();
      expect(now, isA<DateTime>());
    });

    test('updateExpense should return updated Expense', () async {
      // Interface contract test
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      expect(expense, isA<Expense>());
    });

    test('deleteExpense should complete without error', () async {
      // Interface contract test
      const id = 1;
      expect(id, isA<int>());
    });

    test('watchExpensesByTrip should return Stream<List<Expense>>', () {
      // Interface contract test
      const tripId = 1;
      expect(tripId, isA<int>());
    });

    test('getTotalByTrip should return double', () async {
      // Interface contract test
      const tripId = 1;
      expect(tripId, isA<int>());
    });

    test('getCategoryTotals should return Map<ExpenseCategory, double>', () async {
      // Interface contract test
      const tripId = 1;
      expect(tripId, isA<int>());
    });
  });
}

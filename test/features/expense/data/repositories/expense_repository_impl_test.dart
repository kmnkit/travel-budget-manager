import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:trip_wallet/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart' as domain;
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/shared/data/database.dart' as db;

class MockExpenseLocalDatasource extends Mock implements ExpenseLocalDatasource {}

void main() {
  late ExpenseRepositoryImpl repository;
  late MockExpenseLocalDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockExpenseLocalDatasource();
    repository = ExpenseRepositoryImpl(mockDatasource);
  });

  group('getExpensesByTrip', () {
    test('should return list of expenses from datasource', () async {
      // Arrange
      const tripId = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expenseData = [
        db.Expense(
          id: 1,
          tripId: tripId,
          amount: 50000.0,
          currency: 'KRW',
          convertedAmount: 50000.0,
          category: ExpenseCategory.food,
          paymentMethodId: 1,
          memo: 'Lunch',
          date: now,
          createdAt: now,
        ),
        db.Expense(
          id: 2,
          tripId: tripId,
          amount: 10000.0,
          currency: 'KRW',
          convertedAmount: 10000.0,
          category: ExpenseCategory.transport,
          paymentMethodId: 1,
          memo: null,
          date: now,
          createdAt: now,
        ),
      ];

      when(() => mockDatasource.getByTripId(tripId))
          .thenAnswer((_) async => expenseData);

      // Act
      final result = await repository.getExpensesByTrip(tripId);

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, 1);
      expect(result[0].amount, 50000.0);
      expect(result[0].category, ExpenseCategory.food);
      expect(result[1].id, 2);
      verify(() => mockDatasource.getByTripId(tripId)).called(1);
    });

    test('should return empty list when no expenses exist', () async {
      // Arrange
      const tripId = 999;
      when(() => mockDatasource.getByTripId(tripId))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getExpensesByTrip(tripId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockDatasource.getByTripId(tripId)).called(1);
    });
  });

  group('getExpenseById', () {
    test('should return expense when found', () async {
      // Arrange
      const id = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expenseData = db.Expense(
        id: id,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        memo: 'Lunch',
        date: now,
        createdAt: now,
      );

      when(() => mockDatasource.getById(id))
          .thenAnswer((_) async => expenseData);

      // Act
      final result = await repository.getExpenseById(id);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, id);
      expect(result.amount, 50000.0);
      verify(() => mockDatasource.getById(id)).called(1);
    });

    test('should return null when expense not found', () async {
      // Arrange
      const id = 999;
      when(() => mockDatasource.getById(id))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getExpenseById(id);

      // Assert
      expect(result, isNull);
      verify(() => mockDatasource.getById(id)).called(1);
    });
  });

  group('createExpense', () {
    test('should create expense and return entity', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRW';
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      const memo = 'Lunch';
      final date = DateTime(2024, 1, 15, 12, 0);
      final now = DateTime.now();

      final expenseData = db.Expense(
        id: 1,
        tripId: tripId,
        amount: amount,
        currency: currency,
        convertedAmount: convertedAmount,
        category: category,
        paymentMethodId: paymentMethodId,
        memo: memo,
        date: date,
        createdAt: now,
      );

      when(() => mockDatasource.insert(
            tripId: tripId,
            amount: amount,
            currency: currency,
            convertedAmount: convertedAmount,
            category: category,
            paymentMethodId: paymentMethodId,
            memo: memo,
            date: date,
          )).thenAnswer((_) async => expenseData);

      // Act
      final result = await repository.createExpense(
        tripId: tripId,
        amount: amount,
        currency: currency,
        convertedAmount: convertedAmount,
        category: category,
        paymentMethodId: paymentMethodId,
        memo: memo,
        date: date,
      );

      // Assert
      expect(result.id, 1);
      expect(result.tripId, tripId);
      expect(result.amount, amount);
      expect(result.category, category);
      expect(result.memo, memo);
      verify(() => mockDatasource.insert(
            tripId: tripId,
            amount: amount,
            currency: currency,
            convertedAmount: convertedAmount,
            category: category,
            paymentMethodId: paymentMethodId,
            memo: memo,
            date: date,
          )).called(1);
    });
  });

  group('updateExpense', () {
    test('should update expense and return entity', () async {
      // Arrange
      final now = DateTime.now();
      final expense = domain.Expense(
        id: 1,
        tripId: 1,
        amount: 60000.0,
        currency: 'KRW',
        convertedAmount: 60000.0,
        category: ExpenseCategory.shopping,
        paymentMethodId: 2,
        memo: 'Updated memo',
        date: now,
        createdAt: now,
      );

      final expenseData = db.Expense(
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

      when(() => mockDatasource.update(
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
          )).thenAnswer((_) async => expenseData);

      // Act
      final result = await repository.updateExpense(expense);

      // Assert
      expect(result.id, expense.id);
      expect(result.amount, 60000.0);
      expect(result.category, ExpenseCategory.shopping);
      verify(() => mockDatasource.update(
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
          )).called(1);
    });
  });

  group('deleteExpense', () {
    test('should delete expense', () async {
      // Arrange
      const id = 1;
      when(() => mockDatasource.delete(id))
          .thenAnswer((_) async => {});

      // Act
      await repository.deleteExpense(id);

      // Assert
      verify(() => mockDatasource.delete(id)).called(1);
    });
  });

  group('watchExpensesByTrip', () {
    test('should return stream of expenses', () async {
      // Arrange
      const tripId = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expenseData = [
        db.Expense(
          id: 1,
          tripId: tripId,
          amount: 50000.0,
          currency: 'KRW',
          convertedAmount: 50000.0,
          category: ExpenseCategory.food,
          paymentMethodId: 1,
          memo: 'Lunch',
          date: now,
          createdAt: now,
        ),
      ];

      when(() => mockDatasource.watchByTripId(tripId))
          .thenAnswer((_) => Stream.value(expenseData));

      // Act
      final stream = repository.watchExpensesByTrip(tripId);

      // Assert
      await expectLater(
        stream,
        emits(predicate<List<domain.Expense>>((list) => list.length == 1 && list[0].id == 1)),
      );
      verify(() => mockDatasource.watchByTripId(tripId)).called(1);
    });
  });

  group('getTotalByTrip', () {
    test('should return total converted amount', () async {
      // Arrange
      const tripId = 1;
      const total = 150000.0;

      when(() => mockDatasource.getTotalByTripId(tripId))
          .thenAnswer((_) async => total);

      // Act
      final result = await repository.getTotalByTrip(tripId);

      // Assert
      expect(result, total);
      verify(() => mockDatasource.getTotalByTripId(tripId)).called(1);
    });

    test('should return 0 when no expenses exist', () async {
      // Arrange
      const tripId = 999;

      when(() => mockDatasource.getTotalByTripId(tripId))
          .thenAnswer((_) async => 0.0);

      // Act
      final result = await repository.getTotalByTrip(tripId);

      // Assert
      expect(result, 0.0);
      verify(() => mockDatasource.getTotalByTripId(tripId)).called(1);
    });
  });

  group('getCategoryTotals', () {
    test('should return map of category totals', () async {
      // Arrange
      const tripId = 1;
      final categoryTotals = {
        ExpenseCategory.food: 100000.0,
        ExpenseCategory.transport: 50000.0,
      };

      when(() => mockDatasource.getCategoryTotalsByTripId(tripId))
          .thenAnswer((_) async => categoryTotals);

      // Act
      final result = await repository.getCategoryTotals(tripId);

      // Assert
      expect(result, categoryTotals);
      expect(result[ExpenseCategory.food], 100000.0);
      expect(result[ExpenseCategory.transport], 50000.0);
      verify(() => mockDatasource.getCategoryTotalsByTripId(tripId)).called(1);
    });

    test('should return empty map when no expenses exist', () async {
      // Arrange
      const tripId = 999;

      when(() => mockDatasource.getCategoryTotalsByTripId(tripId))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getCategoryTotals(tripId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockDatasource.getCategoryTotalsByTripId(tripId)).called(1);
    });
  });
}

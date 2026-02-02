import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/expense/domain/usecases/update_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late UpdateExpense usecase;
  late MockExpenseRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(Expense(
      id: 1,
      tripId: 1,
      amount: 50000.0,
      currency: 'KRW',
      convertedAmount: 50000.0,
      category: ExpenseCategory.food,
      paymentMethodId: 1,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockRepository = MockExpenseRepository();
    usecase = UpdateExpense(mockRepository);
  });

  group('UpdateExpense', () {
    test('should update expense with valid data', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
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

      when(() => mockRepository.updateExpense(expense))
          .thenAnswer((_) async => expense);

      // Act
      final result = await usecase(expense);

      // Assert
      expect(result, expense);
      expect(result.amount, 60000.0);
      expect(result.category, ExpenseCategory.shopping);
      verify(() => mockRepository.updateExpense(expense)).called(1);
    });

    test('should throw ArgumentError when amount is negative', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: -50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      // Act & Assert
      expect(
        () => usecase(expense),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Amount must be positive'),
        )),
      );

      verifyNever(() => mockRepository.updateExpense(any()));
    });

    test('should throw ArgumentError when amount is zero', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 0.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      // Act & Assert
      expect(
        () => usecase(expense),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Amount must be positive'),
        )),
      );
    });

    test('should throw ArgumentError when currency is invalid length', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRWW', // Invalid: 4 characters
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      // Act & Assert
      expect(
        () => usecase(expense),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Currency must be a 3-letter code'),
        )),
      );
    });

    test('should throw ArgumentError when currency is not uppercase', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'krw', // Invalid: lowercase
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      // Act & Assert
      expect(
        () => usecase(expense),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Currency must be uppercase'),
        )),
      );
    });

    test('should throw ArgumentError when convertedAmount is negative', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: -50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      // Act & Assert
      expect(
        () => usecase(expense),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Converted amount must be positive'),
        )),
      );
    });

    test('should throw ArgumentError when date is in the future', () async {
      // Arrange
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: futureDate,
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(
        () => usecase(expense),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Date cannot be in the future'),
        )),
      );
    });

    test('should accept date that is today', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      when(() => mockRepository.updateExpense(expense))
          .thenAnswer((_) async => expense);

      // Act
      final result = await usecase(expense);

      // Assert
      expect(result, expense);
      verify(() => mockRepository.updateExpense(expense)).called(1);
    });

    test('should update expense without memo', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        memo: null,
        date: now,
        createdAt: now,
      );

      when(() => mockRepository.updateExpense(expense))
          .thenAnswer((_) async => expense);

      // Act
      final result = await usecase(expense);

      // Assert
      expect(result.memo, isNull);
      verify(() => mockRepository.updateExpense(expense)).called(1);
    });

    test('should propagate repository errors', () async {
      // Arrange
      final now = DateTime.now();
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );
      final error = Exception('Database error');

      when(() => mockRepository.updateExpense(expense))
          .thenThrow(error);

      // Act & Assert
      expect(() => usecase(expense), throwsA(error));
      verify(() => mockRepository.updateExpense(expense)).called(1);
    });
  });
}

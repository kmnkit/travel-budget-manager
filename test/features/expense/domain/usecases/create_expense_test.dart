import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/expense/domain/usecases/create_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late CreateExpense usecase;
  late MockExpenseRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(ExpenseCategory.food);
    registerFallbackValue(DateTime(2024));
  });

  setUp(() {
    mockRepository = MockExpenseRepository();
    usecase = CreateExpense(mockRepository);
  });

  group('CreateExpense', () {
    test('should create expense with valid parameters', () async {
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

      final expectedExpense = Expense(
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

      when(() => mockRepository.createExpense(
            tripId: tripId,
            amount: amount,
            currency: currency,
            convertedAmount: convertedAmount,
            category: category,
            paymentMethodId: paymentMethodId,
            memo: memo,
            date: date,
          )).thenAnswer((_) async => expectedExpense);

      // Act
      final result = await usecase(
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
      expect(result, expectedExpense);
      expect(result.amount, amount);
      expect(result.category, category);
      verify(() => mockRepository.createExpense(
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

    test('should create expense without memo', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRW';
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);
      final now = DateTime.now();

      final expectedExpense = Expense(
        id: 1,
        tripId: tripId,
        amount: amount,
        currency: currency,
        convertedAmount: convertedAmount,
        category: category,
        paymentMethodId: paymentMethodId,
        memo: null,
        date: date,
        createdAt: now,
      );

      when(() => mockRepository.createExpense(
            tripId: tripId,
            amount: amount,
            currency: currency,
            convertedAmount: convertedAmount,
            category: category,
            paymentMethodId: paymentMethodId,
            memo: null,
            date: date,
          )).thenAnswer((_) async => expectedExpense);

      // Act
      final result = await usecase(
        tripId: tripId,
        amount: amount,
        currency: currency,
        convertedAmount: convertedAmount,
        category: category,
        paymentMethodId: paymentMethodId,
        date: date,
      );

      // Assert
      expect(result.memo, isNull);
      verify(() => mockRepository.createExpense(
            tripId: tripId,
            amount: amount,
            currency: currency,
            convertedAmount: convertedAmount,
            category: category,
            paymentMethodId: paymentMethodId,
            memo: null,
            date: date,
          )).called(1);
    });

    test('should throw ArgumentError when amount is negative', () async {
      // Arrange
      const tripId = 1;
      const amount = -50000.0;
      const currency = 'KRW';
      const convertedAmount = -50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);

      // Act & Assert
      expect(
        () => usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Amount must be positive'),
        )),
      );

      verifyNever(() => mockRepository.createExpense(
            tripId: any(named: 'tripId'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            convertedAmount: any(named: 'convertedAmount'),
            category: any(named: 'category'),
            paymentMethodId: any(named: 'paymentMethodId'),
            date: any(named: 'date'),
          ));
    });

    test('should throw ArgumentError when amount is zero', () async {
      // Arrange
      const tripId = 1;
      const amount = 0.0;
      const currency = 'KRW';
      const convertedAmount = 0.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);

      // Act & Assert
      expect(
        () => usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Amount must be positive'),
        )),
      );
    });

    test('should throw ArgumentError when currency is invalid length', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRWW'; // Invalid: 4 characters
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);

      // Act & Assert
      expect(
        () => usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Currency must be a 3-letter code'),
        )),
      );
    });

    test('should throw ArgumentError when currency is not uppercase', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'krw'; // Invalid: lowercase
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);

      // Act & Assert
      expect(
        () => usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Currency must be uppercase'),
        )),
      );
    });

    test('should throw ArgumentError when convertedAmount is negative', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRW';
      const convertedAmount = -50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);

      // Act & Assert
      expect(
        () => usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Converted amount must be positive'),
        )),
      );
    });

    test('should throw ArgumentError when date is in the future', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRW';
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime.now().add(const Duration(days: 1));

      // Act & Assert
      expect(
        () => usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Date cannot be in the future'),
        )),
      );
    });

    test('should accept date that is today', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRW';
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime.now();
      final now = DateTime.now();

      final expectedExpense = Expense(
        id: 1,
        tripId: tripId,
        amount: amount,
        currency: currency,
        convertedAmount: convertedAmount,
        category: category,
        paymentMethodId: paymentMethodId,
        memo: null,
        date: date,
        createdAt: now,
      );

      when(() => mockRepository.createExpense(
            tripId: any(named: 'tripId'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            convertedAmount: any(named: 'convertedAmount'),
            category: any(named: 'category'),
            paymentMethodId: any(named: 'paymentMethodId'),
            memo: any(named: 'memo'),
            date: any(named: 'date'),
          )).thenAnswer((_) async => expectedExpense);

      // Act
      final result = await usecase(
        tripId: tripId,
        amount: amount,
        currency: currency,
        convertedAmount: convertedAmount,
        category: category,
        paymentMethodId: paymentMethodId,
        date: date,
      );

      // Assert
      expect(result, expectedExpense);
    });

    test('should propagate repository errors', () async {
      // Arrange
      const tripId = 1;
      const amount = 50000.0;
      const currency = 'KRW';
      const convertedAmount = 50000.0;
      const category = ExpenseCategory.food;
      const paymentMethodId = 1;
      final date = DateTime(2024, 1, 15, 12, 0);
      final error = Exception('Database error');

      when(() => mockRepository.createExpense(
            tripId: any(named: 'tripId'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            convertedAmount: any(named: 'convertedAmount'),
            category: any(named: 'category'),
            paymentMethodId: any(named: 'paymentMethodId'),
            memo: any(named: 'memo'),
            date: any(named: 'date'),
          )).thenAnswer((_) async => throw error);

      // Act & Assert
      await expectLater(
        usecase(
          tripId: tripId,
          amount: amount,
          currency: currency,
          convertedAmount: convertedAmount,
          category: category,
          paymentMethodId: paymentMethodId,
          date: date,
        ),
        throwsA(error),
      );
    });
  });
}

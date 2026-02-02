import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/expense/domain/usecases/get_expenses.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late GetExpensesByTrip usecase;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    usecase = GetExpensesByTrip(mockRepository);
  });

  group('GetExpensesByTrip', () {
    test('should get expenses from repository', () async {
      // Arrange
      const tripId = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expenses = [
        Expense(
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
        Expense(
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

      when(() => mockRepository.getExpensesByTrip(tripId))
          .thenAnswer((_) async => expenses);

      // Act
      final result = await usecase(tripId);

      // Assert
      expect(result, expenses);
      expect(result, hasLength(2));
      expect(result[0].category, ExpenseCategory.food);
      verify(() => mockRepository.getExpensesByTrip(tripId)).called(1);
    });

    test('should return empty list when no expenses exist', () async {
      // Arrange
      const tripId = 999;

      when(() => mockRepository.getExpensesByTrip(tripId))
          .thenAnswer((_) async => []);

      // Act
      final result = await usecase(tripId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getExpensesByTrip(tripId)).called(1);
    });

    test('should propagate repository errors', () async {
      // Arrange
      const tripId = 1;
      final error = Exception('Database error');

      when(() => mockRepository.getExpensesByTrip(tripId))
          .thenThrow(error);

      // Act & Assert
      expect(() => usecase(tripId), throwsA(error));
      verify(() => mockRepository.getExpensesByTrip(tripId)).called(1);
    });
  });

  group('WatchExpensesByTrip', () {
    late WatchExpensesByTrip watchUsecase;

    setUp(() {
      watchUsecase = WatchExpensesByTrip(mockRepository);
    });

    test('should watch expenses from repository', () async {
      // Arrange
      const tripId = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expenses = [
        Expense(
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

      when(() => mockRepository.watchExpensesByTrip(tripId))
          .thenAnswer((_) => Stream.value(expenses));

      // Act
      final stream = watchUsecase(tripId);

      // Assert
      await expectLater(
        stream,
        emits(predicate<List<Expense>>((list) => list.length == 1 && list[0].id == 1)),
      );
      verify(() => mockRepository.watchExpensesByTrip(tripId)).called(1);
    });

    test('should emit multiple updates', () async {
      // Arrange
      const tripId = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expense1 = Expense(
        id: 1,
        tripId: tripId,
        amount: 50000.0,
        currency: 'KRW',
        convertedAmount: 50000.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );
      final expense2 = Expense(
        id: 2,
        tripId: tripId,
        amount: 10000.0,
        currency: 'KRW',
        convertedAmount: 10000.0,
        category: ExpenseCategory.transport,
        paymentMethodId: 1,
        date: now,
        createdAt: now,
      );

      when(() => mockRepository.watchExpensesByTrip(tripId)).thenAnswer(
        (_) => Stream.fromIterable([
          [expense1],
          [expense1, expense2],
        ]),
      );

      // Act
      final stream = watchUsecase(tripId);

      // Assert
      await expectLater(
        stream,
        emitsInOrder([
          predicate<List<Expense>>((list) => list.length == 1),
          predicate<List<Expense>>((list) => list.length == 2),
        ]),
      );
    });
  });

  group('GetExpenseById', () {
    late GetExpenseById getByIdUsecase;

    setUp(() {
      getByIdUsecase = GetExpenseById(mockRepository);
    });

    test('should get expense by id from repository', () async {
      // Arrange
      const id = 1;
      final now = DateTime(2024, 1, 15, 10, 0);
      final expense = Expense(
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

      when(() => mockRepository.getExpenseById(id))
          .thenAnswer((_) async => expense);

      // Act
      final result = await getByIdUsecase(id);

      // Assert
      expect(result, expense);
      expect(result?.id, id);
      verify(() => mockRepository.getExpenseById(id)).called(1);
    });

    test('should return null when expense not found', () async {
      // Arrange
      const id = 999;

      when(() => mockRepository.getExpenseById(id))
          .thenAnswer((_) async => null);

      // Act
      final result = await getByIdUsecase(id);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getExpenseById(id)).called(1);
    });
  });

  group('GetTotalByTrip', () {
    late GetTotalByTrip getTotalUsecase;

    setUp(() {
      getTotalUsecase = GetTotalByTrip(mockRepository);
    });

    test('should get total from repository', () async {
      // Arrange
      const tripId = 1;
      const total = 150000.0;

      when(() => mockRepository.getTotalByTrip(tripId))
          .thenAnswer((_) async => total);

      // Act
      final result = await getTotalUsecase(tripId);

      // Assert
      expect(result, total);
      verify(() => mockRepository.getTotalByTrip(tripId)).called(1);
    });

    test('should return 0 when no expenses exist', () async {
      // Arrange
      const tripId = 999;

      when(() => mockRepository.getTotalByTrip(tripId))
          .thenAnswer((_) async => 0.0);

      // Act
      final result = await getTotalUsecase(tripId);

      // Assert
      expect(result, 0.0);
      verify(() => mockRepository.getTotalByTrip(tripId)).called(1);
    });
  });

  group('GetCategoryTotals', () {
    late GetCategoryTotals getCategoryTotalsUsecase;

    setUp(() {
      getCategoryTotalsUsecase = GetCategoryTotals(mockRepository);
    });

    test('should get category totals from repository', () async {
      // Arrange
      const tripId = 1;
      final categoryTotals = {
        ExpenseCategory.food: 100000.0,
        ExpenseCategory.transport: 50000.0,
      };

      when(() => mockRepository.getCategoryTotals(tripId))
          .thenAnswer((_) async => categoryTotals);

      // Act
      final result = await getCategoryTotalsUsecase(tripId);

      // Assert
      expect(result, categoryTotals);
      expect(result[ExpenseCategory.food], 100000.0);
      expect(result[ExpenseCategory.transport], 50000.0);
      verify(() => mockRepository.getCategoryTotals(tripId)).called(1);
    });

    test('should return empty map when no expenses exist', () async {
      // Arrange
      const tripId = 999;

      when(() => mockRepository.getCategoryTotals(tripId))
          .thenAnswer((_) async => {});

      // Act
      final result = await getCategoryTotalsUsecase(tripId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getCategoryTotals(tripId)).called(1);
    });
  });
}

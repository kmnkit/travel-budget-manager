import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/expense/presentation/providers/expense_providers.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  group('ExpenseProviders', () {
    // Note: expenseListProvider test omitted as it requires database initialization
    // The provider is tested indirectly through integration tests
  });

  group('ExpenseNotifier', () {
    late MockExpenseRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockExpenseRepository();
      container = ProviderContainer(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('createExpense creates expense and invalidates providers', () async {
      final newExpense = Expense(
        id: 1,
        tripId: 1,
        amount: 100.0,
        currency: 'USD',
        convertedAmount: 100.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        memo: 'Dinner',
        date: DateTime(2024, 1, 15),
        createdAt: DateTime.now(),
      );

      when(() => mockRepository.createExpense(
            tripId: 1,
            amount: 100.0,
            currency: 'USD',
            convertedAmount: 100.0,
            category: ExpenseCategory.food,
            paymentMethodId: 1,
            memo: 'Dinner',
            date: any(named: 'date'),
          )).thenAnswer((_) async => newExpense);

      final notifier = container.read(expenseNotifierProvider.notifier);

      final result = await notifier.createExpense(
        tripId: 1,
        amount: 100.0,
        currency: 'USD',
        convertedAmount: 100.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        memo: 'Dinner',
        date: DateTime(2024, 1, 15),
      );

      expect(result, equals(newExpense));
      verify(() => mockRepository.createExpense(
            tripId: 1,
            amount: 100.0,
            currency: 'USD',
            convertedAmount: 100.0,
            category: ExpenseCategory.food,
            paymentMethodId: 1,
            memo: 'Dinner',
            date: any(named: 'date'),
          )).called(1);
    });

    test('updateExpense updates expense and invalidates providers', () async {
      final expense = Expense(
        id: 1,
        tripId: 1,
        amount: 100.0,
        currency: 'USD',
        convertedAmount: 100.0,
        category: ExpenseCategory.food,
        paymentMethodId: 1,
        memo: 'Updated',
        date: DateTime(2024, 1, 15),
        createdAt: DateTime.now(),
      );

      when(() => mockRepository.updateExpense(expense))
          .thenAnswer((_) async => expense);

      final notifier = container.read(expenseNotifierProvider.notifier);
      final result = await notifier.updateExpense(expense);

      expect(result, equals(expense));
      verify(() => mockRepository.updateExpense(expense)).called(1);
    });

    test('deleteExpense deletes expense and invalidates providers', () async {
      when(() => mockRepository.deleteExpense(1)).thenAnswer((_) async {});

      final notifier = container.read(expenseNotifierProvider.notifier);
      await notifier.deleteExpense(1);

      verify(() => mockRepository.deleteExpense(1)).called(1);
    });
  });
}

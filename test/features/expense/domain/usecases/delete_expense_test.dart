import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/expense/domain/usecases/delete_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late DeleteExpense usecase;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    usecase = DeleteExpense(mockRepository);
  });

  group('DeleteExpense', () {
    test('should delete expense from repository', () async {
      // Arrange
      const id = 1;

      when(() => mockRepository.deleteExpense(id))
          .thenAnswer((_) async => {});

      // Act
      await usecase(id);

      // Assert
      verify(() => mockRepository.deleteExpense(id)).called(1);
    });

    test('should complete without error for non-existent expense', () async {
      // Arrange
      const id = 999;

      when(() => mockRepository.deleteExpense(id))
          .thenAnswer((_) async => {});

      // Act
      await usecase(id);

      // Assert
      verify(() => mockRepository.deleteExpense(id)).called(1);
    });

    test('should propagate repository errors', () async {
      // Arrange
      const id = 1;
      final error = Exception('Database error');

      when(() => mockRepository.deleteExpense(id))
          .thenThrow(error);

      // Act & Assert
      expect(() => usecase(id), throwsA(error));
      verify(() => mockRepository.deleteExpense(id)).called(1);
    });
  });
}

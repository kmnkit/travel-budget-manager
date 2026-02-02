import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/core/errors/failures.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/budget/domain/usecases/get_budget_summary.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

class MockTripRepository extends Mock implements TripRepository {}
class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late GetBudgetSummary useCase;
  late MockTripRepository mockTripRepo;
  late MockExpenseRepository mockExpenseRepo;

  setUp(() {
    mockTripRepo = MockTripRepository();
    mockExpenseRepo = MockExpenseRepository();
    useCase = GetBudgetSummary(mockTripRepo, mockExpenseRepo);
  });

  group('GetBudgetSummary', () {
    final testTrip = Trip(
      id: 1,
      title: 'Test Trip',
      baseCurrency: 'USD',
      budget: 1000.0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 10),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    test('calculates budget summary with comfortable status (< 50%)', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 400.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {
        ExpenseCategory.food: 200.0,
        ExpenseCategory.transport: 200.0,
      });

      final result = await useCase(1);

      expect(result.tripId, 1);
      expect(result.totalBudget, 1000.0);
      expect(result.totalSpent, 400.0);
      expect(result.remaining, 600.0);
      expect(result.percentUsed, 40.0);
      expect(result.status, BudgetStatus.comfortable);
      expect(result.categoryBreakdown.length, 2);
      expect(result.categoryBreakdown[ExpenseCategory.food], 200.0);
    });

    test('calculates budget summary with caution status (50-75%)', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 600.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {
        ExpenseCategory.food: 600.0,
      });

      final result = await useCase(1);

      expect(result.percentUsed, 60.0);
      expect(result.status, BudgetStatus.caution);
      expect(result.remaining, 400.0);
    });

    test('calculates budget summary with warning status (75-90%)', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 800.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {
        ExpenseCategory.food: 800.0,
      });

      final result = await useCase(1);

      expect(result.percentUsed, 80.0);
      expect(result.status, BudgetStatus.warning);
      expect(result.remaining, 200.0);
    });

    test('calculates budget summary with exceeded status (>= 100%)', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 1100.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {
        ExpenseCategory.food: 1100.0,
      });

      final result = await useCase(1);

      expect(result.percentUsed, closeTo(110.0, 0.0001));
      expect(result.status, BudgetStatus.exceeded);
      expect(result.remaining, -100.0);
    });

    test('handles zero budget correctly', () async {
      final zeroBudgetTrip = testTrip.copyWith(budget: 0.0);
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => zeroBudgetTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 100.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      expect(result.totalBudget, 0.0);
      expect(result.totalSpent, 100.0);
      expect(result.percentUsed, 0.0);
      expect(result.status, BudgetStatus.comfortable);
    });

    test('handles no expenses case', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 0.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      expect(result.totalSpent, 0.0);
      expect(result.remaining, 1000.0);
      expect(result.percentUsed, 0.0);
      expect(result.status, BudgetStatus.comfortable);
      expect(result.categoryBreakdown.isEmpty, true);
    });

    test('throws NotFoundFailure when trip does not exist', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => null);

      expect(
        () => useCase(1),
        throwsA(isA<NotFoundFailure>().having(
          (f) => f.message,
          'message',
          'Trip not found',
        )),
      );

      verifyNever(() => mockExpenseRepo.getTotalByTrip(any()));
    });

    test('calculates daily average correctly', () async {
      // Trip started 4 days ago, spent 400
      final now = DateTime.now();
      final tripWithHistory = testTrip.copyWith(
        startDate: now.subtract(const Duration(days: 4)),
        endDate: now.add(const Duration(days: 6)),
      );

      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => tripWithHistory);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 400.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      // 400 spent over 4 days = 100 per day
      expect(result.dailyAverage, 100.0);
    });

    test('calculates daily budget remaining correctly', () async {
      final now = DateTime.now();
      // Use date-only comparison to avoid hour/minute precision issues
      final today = DateTime(now.year, now.month, now.day);
      final tripWithFuture = testTrip.copyWith(
        startDate: today.subtract(const Duration(days: 2)),
        endDate: today.add(const Duration(days: 5)),
        budget: 1000.0,
      );

      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => tripWithFuture);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 500.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      // Days remaining uses .inDays which counts complete 24-hour periods
      // today + 5 days means 4 complete days remaining (today not included in count)
      expect(result.daysRemaining, 4);
      expect(result.remaining, 500.0);
      // 500 remaining / 4 days = 125 per day
      expect(result.dailyBudgetRemaining, 125.0);
    });

    test('handles trip already ended (0 days remaining)', () async {
      final now = DateTime.now();
      final endedTrip = testTrip.copyWith(
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.subtract(const Duration(days: 1)),
      );

      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => endedTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 400.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      expect(result.daysRemaining, 0);
      expect(result.dailyBudgetRemaining, 0.0);
    });

    test('calculates daily average with minimum 1 day elapsed', () async {
      // Trip started today (same day)
      final now = DateTime.now();
      final todayTrip = testTrip.copyWith(
        startDate: now,
        endDate: now.add(const Duration(days: 5)),
      );

      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => todayTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 100.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      // Should use minimum 1 day for daily average calculation
      expect(result.dailyAverage, 100.0);
    });

    test('handles exactly at 50% threshold', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 500.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      expect(result.percentUsed, 50.0);
      expect(result.status, BudgetStatus.caution);
    });

    test('handles exactly at 75% threshold', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 750.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      expect(result.percentUsed, 75.0);
      expect(result.status, BudgetStatus.warning);
    });

    test('handles exactly at 100% threshold', () async {
      when(() => mockTripRepo.getTripById(1)).thenAnswer((_) async => testTrip);
      when(() => mockExpenseRepo.getTotalByTrip(1)).thenAnswer((_) async => 1000.0);
      when(() => mockExpenseRepo.getCategoryTotals(1)).thenAnswer((_) async => {});

      final result = await useCase(1);

      expect(result.percentUsed, 100.0);
      expect(result.status, BudgetStatus.exceeded);
    });
  });
}

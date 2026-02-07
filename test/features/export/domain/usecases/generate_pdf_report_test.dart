import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/domain/repositories/export_repository.dart';
import 'package:trip_wallet/features/export/domain/usecases/generate_pdf_report.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

class MockExportRepository extends Mock implements ExportRepository {}

void main() {
  late MockExportRepository mockRepository;
  late GeneratePdfReport useCase;

  setUp(() {
    mockRepository = MockExportRepository();
    useCase = GeneratePdfReport(mockRepository);
  });

  setUpAll(() {
    // Register fallback values for any() matcher
    registerFallbackValue(ExportReport(
      trip: Trip(
        id: 0,
        title: '',
        baseCurrency: '',
        budget: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      expenses: const [],
      statistics: const StatisticsData(
        totalAmount: 0,
        categoryTotals: {},
        dailyTotals: {},
        paymentMethodTotals: {},
        categoryDailyTotals: {},
      ),
      budgetSummary: const BudgetSummary(
        tripId: 0,
        totalBudget: 0,
        totalSpent: 0,
        remaining: 0,
        percentUsed: 0,
        status: BudgetStatus.comfortable,
        categoryBreakdown: {},
        dailyAverage: 0,
        daysRemaining: 0,
        dailyBudgetRemaining: 0,
      ),
      insights: const [],
      forecast: null,
    ));
  });

  group('GeneratePdfReport', () {
    const tripId = 1;

    test('should generate PDF report successfully', () async {
      // Arrange
      final now = DateTime.now();
      final mockReport = ExportReport(
        trip: Trip(
          id: tripId,
          title: 'Test Trip',
          baseCurrency: 'KRW',
          budget: 500000,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 7),
          createdAt: now,
          updatedAt: now,
        ),
        expenses: [
          Expense(
            id: 1,
            tripId: tripId,
            memo: 'Lunch',
            amount: 15000,
            currency: 'KRW',
            convertedAmount: 15000,
            category: ExpenseCategory.food,
            date: DateTime(2024, 1, 1),
            paymentMethodId: 1,
            createdAt: now,
          ),
        ],
        statistics: StatisticsData(
          totalAmount: 15000,
          categoryTotals: {ExpenseCategory.food: 15000},
          dailyTotals: {DateTime(2024, 1, 1): 15000},
          paymentMethodTotals: const {'Credit Card': 15000},
          categoryDailyTotals: {
            ExpenseCategory.food: {DateTime(2024, 1, 1): 15000}
          },
        ),
        budgetSummary: BudgetSummary(
          tripId: tripId,
          totalBudget: 500000,
          totalSpent: 15000,
          remaining: 485000,
          percentUsed: 3.0,
          status: BudgetStatus.comfortable,
          categoryBreakdown: const {ExpenseCategory.food: 15000},
          dailyAverage: 15000,
          daysRemaining: 6,
          dailyBudgetRemaining: 80833,
        ),
        insights: const [],
        forecast: null,
      );

      final mockFile = File('/tmp/test_report.pdf');

      when(() => mockRepository.collectReportData(tripId))
          .thenAnswer((_) async => mockReport);
      when(() => mockRepository.generatePdf(any()))
          .thenAnswer((_) async => mockFile);

      // Act
      final result = await useCase.call(tripId);

      // Assert
      expect(result, equals(mockFile));
      expect(result.path, equals('/tmp/test_report.pdf'));
      verify(() => mockRepository.collectReportData(tripId)).called(1);
      verify(() => mockRepository.generatePdf(any())).called(1);
    });

    test('should throw exception when collectReportData fails', () async {
      // Arrange
      when(() => mockRepository.collectReportData(tripId))
          .thenThrow(Exception('Failed to collect data'));

      // Act & Assert
      await expectLater(
        useCase.call(tripId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.collectReportData(tripId)).called(1);
      verifyNever(() => mockRepository.generatePdf(any()));
    });

    test('should throw exception when generatePdf fails', () async {
      // Arrange
      final now = DateTime.now();
      final mockReport = ExportReport(
        trip: Trip(
          id: tripId,
          title: 'Test Trip',
          baseCurrency: 'KRW',
          budget: 500000,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 7),
          createdAt: now,
          updatedAt: now,
        ),
        expenses: const [],
        statistics: const StatisticsData(
          totalAmount: 0,
          categoryTotals: {},
          dailyTotals: {},
          paymentMethodTotals: {},
          categoryDailyTotals: {},
        ),
        budgetSummary: BudgetSummary(
          tripId: tripId,
          totalBudget: 500000,
          totalSpent: 0,
          remaining: 500000,
          percentUsed: 0,
          status: BudgetStatus.comfortable,
          categoryBreakdown: const {},
          dailyAverage: 0,
          daysRemaining: 7,
          dailyBudgetRemaining: 71428,
        ),
        insights: const [],
        forecast: null,
      );

      when(() => mockRepository.collectReportData(tripId))
          .thenAnswer((_) async => mockReport);
      when(() => mockRepository.generatePdf(any()))
          .thenThrow(Exception('PDF generation failed'));

      // Act & Assert
      await expectLater(
        useCase.call(tripId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.collectReportData(tripId)).called(1);
      verify(() => mockRepository.generatePdf(any())).called(1);
    });

    test('should pass correct trip ID to repository', () async {
      // Arrange
      const testTripId = 42;
      final now = DateTime.now();
      final mockReport = ExportReport(
        trip: Trip(
          id: testTripId,
          title: 'Trip 42',
          baseCurrency: 'JPY',
          budget: 100000,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 10),
          createdAt: now,
          updatedAt: now,
        ),
        expenses: const [],
        statistics: const StatisticsData(
          totalAmount: 0,
          categoryTotals: {},
          dailyTotals: {},
          paymentMethodTotals: {},
          categoryDailyTotals: {},
        ),
        budgetSummary: const BudgetSummary(
          tripId: testTripId,
          totalBudget: 100000,
          totalSpent: 0,
          remaining: 100000,
          percentUsed: 0,
          status: BudgetStatus.comfortable,
          categoryBreakdown: {},
          dailyAverage: 0,
          daysRemaining: 10,
          dailyBudgetRemaining: 10000,
        ),
        insights: const [],
        forecast: null,
      );

      final mockFile = File('/tmp/report_42.pdf');

      when(() => mockRepository.collectReportData(testTripId))
          .thenAnswer((_) async => mockReport);
      when(() => mockRepository.generatePdf(any()))
          .thenAnswer((_) async => mockFile);

      // Act
      await useCase.call(testTripId);

      // Assert
      verify(() => mockRepository.collectReportData(testTripId)).called(1);
    });
  });
}

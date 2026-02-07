import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

void main() {
  group('ExportReport', () {
    final now = DateTime.now();
    final trip = Trip(
      id: 1,
      title: 'Test Trip',
      baseCurrency: 'USD',
      budget: 1000.0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 10),
      createdAt: now,
      updatedAt: now,
    );

    final expense = Expense(
      id: 1,
      tripId: 1,
      amount: 50.0,
      currency: 'USD',
      convertedAmount: 50.0,
      category: ExpenseCategory.food,
      memo: 'Lunch',
      date: DateTime(2024, 1, 5),
      paymentMethodId: 1,
      createdAt: now,
    );

    final statistics = StatisticsData(
      categoryTotals: {ExpenseCategory.food: 500.0},
      dailyTotals: {DateTime(2024, 1, 5): 500.0},
      paymentMethodTotals: {'Cash': 500.0},
      totalAmount: 500.0,
      categoryDailyTotals: {
        ExpenseCategory.food: {DateTime(2024, 1, 5): 500.0}
      },
    );

    final budgetSummary = BudgetSummary(
      tripId: 1,
      totalBudget: 1000.0,
      totalSpent: 500.0,
      remaining: 500.0,
      percentUsed: 50.0,
      status: BudgetStatus.comfortable,
      categoryBreakdown: {ExpenseCategory.food: 500.0},
      dailyAverage: 100.0,
      daysRemaining: 5,
      dailyBudgetRemaining: 100.0,
    );

    final insight = AnalyticsInsight(
      id: 'insight-1',
      type: InsightType.spending,
      title: 'Test Insight',
      description: 'Test description',
      priority: InsightPriority.medium,
      generatedAt: now,
    );

    final confidenceInterval = ConfidenceInterval(
      bestCase: 900.0,
      worstCase: 1000.0,
      confidenceLevel: 0.95,
    );

    final forecast = BudgetForecast(
      tripId: 1,
      totalBudget: 1000.0,
      totalSpent: 500.0,
      dailySpendingRate: 50.0,
      projectedTotalSpend: 950.0,
      daysElapsed: 5,
      daysRemaining: 5,
      daysUntilExhaustion: 10,
      status: ForecastStatus.onTrack,
      historicalSpending: [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 500.0),
      ],
      projectedSpending: [
        DataPoint(date: DateTime(2024, 1, 6), value: 550.0),
        DataPoint(date: DateTime(2024, 1, 10), value: 950.0),
      ],
      budgetLine: [
        DataPoint(date: DateTime(2024, 1, 1), value: 0.0),
        DataPoint(date: DateTime(2024, 1, 10), value: 1000.0),
      ],
      confidenceInterval: confidenceInterval,
    );

    test('should create ExportReport with required fields', () {
      final report = ExportReport(
        trip: trip,
        expenses: [expense],
        statistics: statistics,
        budgetSummary: budgetSummary,
        insights: [insight],
        forecast: forecast,
      );

      expect(report.trip, trip);
      expect(report.expenses, [expense]);
      expect(report.statistics, statistics);
      expect(report.budgetSummary, budgetSummary);
      expect(report.insights, [insight]);
      expect(report.forecast, forecast);
    });

    test('should create ExportReport without forecast', () {
      final report = ExportReport(
        trip: trip,
        expenses: [expense],
        statistics: statistics,
        budgetSummary: budgetSummary,
        insights: [insight],
        forecast: null,
      );

      expect(report.forecast, isNull);
    });

    test('should support copyWith', () {
      final report = ExportReport(
        trip: trip,
        expenses: [expense],
        statistics: statistics,
        budgetSummary: budgetSummary,
        insights: [insight],
        forecast: forecast,
      );

      final newTrip = trip.copyWith(title: 'Updated Trip');
      final updated = report.copyWith(trip: newTrip);

      expect(updated.trip.title, 'Updated Trip');
      expect(updated.expenses, report.expenses);
      expect(updated.statistics, report.statistics);
    });

    test('should support equality', () {
      final report1 = ExportReport(
        trip: trip,
        expenses: [expense],
        statistics: statistics,
        budgetSummary: budgetSummary,
        insights: [insight],
        forecast: forecast,
      );

      final report2 = ExportReport(
        trip: trip,
        expenses: [expense],
        statistics: statistics,
        budgetSummary: budgetSummary,
        insights: [insight],
        forecast: forecast,
      );

      expect(report1, report2);
    });
  });

  group('ExportFormat', () {
    test('should have pdf format', () {
      expect(ExportFormat.pdf, isA<ExportFormat>());
    });

    test('should have csv format', () {
      expect(ExportFormat.csv, isA<ExportFormat>());
    });

    test('should have all expected formats', () {
      expect(ExportFormat.values.length, 2);
      expect(ExportFormat.values, containsAll([ExportFormat.pdf, ExportFormat.csv]));
    });
  });

  group('ExportStatus', () {
    test('should have idle status', () {
      expect(ExportStatus.idle, isA<ExportStatus>());
    });

    test('should have generating status', () {
      expect(ExportStatus.generating, isA<ExportStatus>());
    });

    test('should have completed status', () {
      expect(ExportStatus.completed, isA<ExportStatus>());
    });

    test('should have failed status', () {
      expect(ExportStatus.failed, isA<ExportStatus>());
    });

    test('should have all expected statuses', () {
      expect(ExportStatus.values.length, 4);
      expect(
        ExportStatus.values,
        containsAll([
          ExportStatus.idle,
          ExportStatus.generating,
          ExportStatus.completed,
          ExportStatus.failed,
        ]),
      );
    });
  });
}

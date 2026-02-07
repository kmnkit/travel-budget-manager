import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

void main() {
  group('ForecastStatus', () {
    test('should have four status values', () {
      expect(ForecastStatus.values.length, equals(4));
      expect(ForecastStatus.values, contains(ForecastStatus.onTrack));
      expect(ForecastStatus.values, contains(ForecastStatus.atRisk));
      expect(ForecastStatus.values, contains(ForecastStatus.overBudget));
      expect(ForecastStatus.values, contains(ForecastStatus.exhausted));
    });
  });

  group('ConfidenceInterval', () {
    test('should create instance with all fields', () {
      final ci = ConfidenceInterval(
        bestCase: 800.0,
        worstCase: 1200.0,
        confidenceLevel: 0.68,
      );

      expect(ci.bestCase, equals(800.0));
      expect(ci.worstCase, equals(1200.0));
      expect(ci.confidenceLevel, equals(0.68));
    });

    test('should support equality comparison', () {
      final ci1 = ConfidenceInterval(
        bestCase: 800.0,
        worstCase: 1200.0,
        confidenceLevel: 0.68,
      );
      final ci2 = ConfidenceInterval(
        bestCase: 800.0,
        worstCase: 1200.0,
        confidenceLevel: 0.68,
      );
      final ci3 = ConfidenceInterval(
        bestCase: 900.0,
        worstCase: 1200.0,
        confidenceLevel: 0.68,
      );

      expect(ci1, equals(ci2));
      expect(ci1, isNot(equals(ci3)));
    });

    test('should support copyWith', () {
      final original = ConfidenceInterval(
        bestCase: 800.0,
        worstCase: 1200.0,
        confidenceLevel: 0.68,
      );
      final updated = original.copyWith(bestCase: 750.0);

      expect(updated.bestCase, equals(750.0));
      expect(updated.worstCase, equals(1200.0));
      expect(original.bestCase, equals(800.0));
    });
  });

  group('BudgetForecast', () {
    test('should create instance with all required fields', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 8,
        daysRemaining: 6,
        daysUntilExhaustion: 12,
        status: ForecastStatus.onTrack,
        historicalSpending: [
          DataPoint(date: DateTime(2024, 1, 1), value: 50.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
        ],
        projectedSpending: [
          DataPoint(date: DateTime(2024, 1, 9), value: 450.0),
        ],
        budgetLine: [
          DataPoint(date: DateTime(2024, 1, 1), value: 1000.0),
          DataPoint(date: DateTime(2024, 1, 14), value: 1000.0),
        ],
        confidenceInterval: ConfidenceInterval(
          bestCase: 600.0,
          worstCase: 800.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.tripId, equals(1));
      expect(forecast.totalBudget, equals(1000.0));
      expect(forecast.totalSpent, equals(400.0));
      expect(forecast.dailySpendingRate, equals(50.0));
      expect(forecast.projectedTotalSpend, equals(700.0));
      expect(forecast.daysElapsed, equals(8));
      expect(forecast.daysRemaining, equals(6));
      expect(forecast.daysUntilExhaustion, equals(12));
      expect(forecast.status, equals(ForecastStatus.onTrack));
      expect(forecast.historicalSpending.length, equals(2));
      expect(forecast.projectedSpending.length, equals(1));
      expect(forecast.budgetLine.length, equals(2));
      expect(forecast.confidenceInterval.bestCase, equals(600.0));
    });

    test('should allow null daysUntilExhaustion', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 0.0,
        dailySpendingRate: 0.0,
        projectedTotalSpend: 0.0,
        daysElapsed: 0,
        daysRemaining: 14,
        daysUntilExhaustion: null,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 0.0,
          worstCase: 0.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.daysUntilExhaustion, isNull);
    });

    test('should support equality comparison', () {
      final ci = ConfidenceInterval(
        bestCase: 600.0,
        worstCase: 800.0,
        confidenceLevel: 0.68,
      );
      final forecast1 = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 8,
        daysRemaining: 6,
        daysUntilExhaustion: 12,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ci,
      );
      final forecast2 = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 8,
        daysRemaining: 6,
        daysUntilExhaustion: 12,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ci,
      );

      expect(forecast1, equals(forecast2));
    });

    test('should support copyWith for immutability', () {
      final original = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 400.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 8,
        daysRemaining: 6,
        daysUntilExhaustion: 12,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 600.0,
          worstCase: 800.0,
          confidenceLevel: 0.68,
        ),
      );

      final updated = original.copyWith(
        totalSpent: 500.0,
        status: ForecastStatus.atRisk,
      );

      expect(updated.totalSpent, equals(500.0));
      expect(updated.status, equals(ForecastStatus.atRisk));
      expect(updated.tripId, equals(1));
      expect(original.totalSpent, equals(400.0));
    });

    test('should handle onTrack status', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 300.0,
        dailySpendingRate: 40.0,
        projectedTotalSpend: 560.0,
        daysElapsed: 8,
        daysRemaining: 6,
        daysUntilExhaustion: null,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 480.0,
          worstCase: 640.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.status, equals(ForecastStatus.onTrack));
      expect(forecast.projectedTotalSpend, lessThan(forecast.totalBudget));
    });

    test('should handle atRisk status', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 700.0,
        dailySpendingRate: 100.0,
        projectedTotalSpend: 950.0,
        daysElapsed: 7,
        daysRemaining: 3,
        daysUntilExhaustion: 3,
        status: ForecastStatus.atRisk,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 850.0,
          worstCase: 1050.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.status, equals(ForecastStatus.atRisk));
    });

    test('should handle overBudget status', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 800.0,
        dailySpendingRate: 120.0,
        projectedTotalSpend: 1160.0,
        daysElapsed: 7,
        daysRemaining: 3,
        daysUntilExhaustion: 2,
        status: ForecastStatus.overBudget,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 1000.0,
          worstCase: 1320.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.status, equals(ForecastStatus.overBudget));
      expect(forecast.projectedTotalSpend, greaterThan(forecast.totalBudget));
    });

    test('should handle exhausted status', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 1050.0,
        dailySpendingRate: 100.0,
        projectedTotalSpend: 1350.0,
        daysElapsed: 10,
        daysRemaining: 3,
        daysUntilExhaustion: 0,
        status: ForecastStatus.exhausted,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 1200.0,
          worstCase: 1500.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.status, equals(ForecastStatus.exhausted));
      expect(forecast.totalSpent, greaterThan(forecast.totalBudget));
    });

    test('should handle empty data lists', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 0.0,
        dailySpendingRate: 0.0,
        projectedTotalSpend: 0.0,
        daysElapsed: 0,
        daysRemaining: 14,
        daysUntilExhaustion: null,
        status: ForecastStatus.onTrack,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 0.0,
          worstCase: 0.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.historicalSpending, isEmpty);
      expect(forecast.projectedSpending, isEmpty);
      expect(forecast.budgetLine, isEmpty);
    });

    test('should handle zero budget', () {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 0.0,
        totalSpent: 100.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 2,
        daysRemaining: 12,
        daysUntilExhaustion: 0,
        status: ForecastStatus.exhausted,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 600.0,
          worstCase: 800.0,
          confidenceLevel: 0.68,
        ),
      );

      expect(forecast.totalBudget, equals(0.0));
      expect(forecast.status, equals(ForecastStatus.exhausted));
    });
  });
}

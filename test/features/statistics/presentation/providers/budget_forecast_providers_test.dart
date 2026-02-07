import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_budget_forecast.dart';

void main() {
  group('CalculateBudgetForecast integration with provider data', () {
    late CalculateBudgetForecast useCase;

    setUp(() {
      useCase = CalculateBudgetForecast();
    });

    test('should produce onTrack forecast for moderate spending', () {
      // Simulate what the provider would assemble
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 30.0,
        DateTime(2024, 1, 2): 40.0,
        DateTime(2024, 1, 3): 35.0,
      };

      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      expect(result.status, equals(ForecastStatus.onTrack));
      expect(result.totalSpent, equals(105.0));
      expect(result.daysElapsed, equals(3));
      expect(result.daysRemaining, equals(7));
    });

    test('should produce exhausted forecast when budget is already exceeded', () {
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 400.0,
        DateTime(2024, 1, 2): 350.0,
        DateTime(2024, 1, 3): 300.0,
      };

      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      expect(result.status, equals(ForecastStatus.exhausted));
      expect(result.totalSpent, greaterThanOrEqualTo(1000.0));
    });

    test('should handle trip with zero budget', () {
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
      };

      final result = useCase.call(
        totalBudget: 0.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      expect(result.status, equals(ForecastStatus.exhausted));
    });

    test('should handle trip with no spending data', () {
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: {},
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      expect(result.status, equals(ForecastStatus.onTrack));
      expect(result.totalSpent, equals(0.0));
      expect(result.dailySpendingRate, equals(0.0));
      expect(result.daysUntilExhaustion, isNull);
    });

    test('should correctly set tripId to 0 (provider will override)', () {
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: {DateTime(2024, 1, 1): 50.0},
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      expect(result.tripId, equals(0));
    });

    test('should compute correct projected and historical data lengths', () {
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 60.0,
        DateTime(2024, 1, 3): 40.0,
      };

      final result = useCase.call(
        totalBudget: 2000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 7),
      );

      // 3 historical days, 4 remaining days projected
      expect(result.historicalSpending.length, equals(3));
      expect(result.projectedSpending.length, equals(4));
      expect(result.budgetLine.length, equals(2));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_budget_forecast.dart';

void main() {
  late CalculateBudgetForecast useCase;

  setUp(() {
    useCase = CalculateBudgetForecast();
  });

  group('CalculateBudgetForecast', () {
    test('should calculate basic forecast with on-track status', () {
      // Arrange - 10-day trip, 5 days elapsed, spent 200 of 1000 budget
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 30.0,
        DateTime(2024, 1, 2): 50.0,
        DateTime(2024, 1, 3): 40.0,
        DateTime(2024, 1, 4): 45.0,
        DateTime(2024, 1, 5): 35.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert
      expect(result.totalBudget, equals(1000.0));
      expect(result.totalSpent, equals(200.0));
      expect(result.daysElapsed, equals(5));
      expect(result.daysRemaining, equals(5));
      expect(result.dailySpendingRate, closeTo(40.0, 0.1));
      expect(result.projectedTotalSpend, closeTo(400.0, 1.0));
      expect(result.status, equals(ForecastStatus.onTrack));
    });

    test('should calculate at-risk status when projected > 90% of budget', () {
      // Arrange - High spending rate approaching budget
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 90.0,
        DateTime(2024, 1, 2): 95.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 85.0,
        DateTime(2024, 1, 5): 90.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - totalSpent=460, rate=92/day, projected=920 (92% of 1000)
      expect(result.status, equals(ForecastStatus.atRisk));
    });

    test('should calculate over-budget status when projected > 100% of budget', () {
      // Arrange - Very high spending rate
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 150.0,
        DateTime(2024, 1, 2): 140.0,
        DateTime(2024, 1, 3): 160.0,
        DateTime(2024, 1, 4): 130.0,
        DateTime(2024, 1, 5): 145.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - totalSpent=725, rate=145/day, projected=1450 (>100%)
      expect(result.status, equals(ForecastStatus.overBudget));
      expect(result.projectedTotalSpend, greaterThan(result.totalBudget));
    });

    test('should calculate exhausted status when already over budget', () {
      // Arrange - Already spent more than budget
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 300.0,
        DateTime(2024, 1, 2): 400.0,
        DateTime(2024, 1, 3): 350.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - totalSpent=1050, already over budget
      expect(result.status, equals(ForecastStatus.exhausted));
      expect(result.totalSpent, greaterThanOrEqualTo(result.totalBudget));
    });

    test('should calculate days until exhaustion', () {
      // Arrange - spending at 100/day with 500 remaining
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 100.0,
        DateTime(2024, 1, 5): 100.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 14),
      );

      // Assert - totalSpent=500, rate=100/day, remaining=500, exhaustion in 5 days
      expect(result.daysUntilExhaustion, equals(5));
    });

    test('should return null daysUntilExhaustion when rate is zero', () {
      // Arrange - No spending
      final dailySpending = <DateTime, double>{};

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert
      expect(result.daysUntilExhaustion, isNull);
      expect(result.dailySpendingRate, equals(0.0));
    });

    test('should generate cumulative historical spending data points', () {
      // Arrange
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 150.0,
        DateTime(2024, 1, 3): 200.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 2000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - Cumulative: 100, 250, 450
      expect(result.historicalSpending.length, equals(3));
      expect(result.historicalSpending[0].value, equals(100.0));
      expect(result.historicalSpending[1].value, equals(250.0));
      expect(result.historicalSpending[2].value, equals(450.0));
    });

    test('should generate projected spending data points', () {
      // Arrange
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 50.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 5),
      );

      // Assert - Should project from day 3 to day 5
      expect(result.projectedSpending.isNotEmpty, isTrue);
      // Each projected point should increase by daily rate
      for (int i = 1; i < result.projectedSpending.length; i++) {
        expect(
          result.projectedSpending[i].value,
          greaterThan(result.projectedSpending[i - 1].value),
        );
      }
    });

    test('should generate budget line', () {
      // Arrange
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - Budget line should be flat at budget level
      expect(result.budgetLine.length, equals(2));
      expect(result.budgetLine.first.value, equals(1000.0));
      expect(result.budgetLine.last.value, equals(1000.0));
    });

    test('should calculate confidence interval based on stddev', () {
      // Arrange - Variable spending
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 30.0,
        DateTime(2024, 1, 4): 80.0,
        DateTime(2024, 1, 5): 60.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 2000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert
      expect(result.confidenceInterval.confidenceLevel, equals(0.68));
      expect(result.confidenceInterval.bestCase, lessThan(result.projectedTotalSpend));
      expect(result.confidenceInterval.worstCase, greaterThan(result.projectedTotalSpend));
    });

    test('should have zero stddev confidence interval for uniform spending', () {
      // Arrange - Identical daily spending
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 100.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 2000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - best and worst should equal projected (no variance)
      expect(result.confidenceInterval.bestCase, equals(result.projectedTotalSpend));
      expect(result.confidenceInterval.worstCase, equals(result.projectedTotalSpend));
    });

    test('should handle single day of spending', () {
      // Arrange
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert
      expect(result.daysElapsed, equals(1));
      expect(result.dailySpendingRate, equals(100.0));
      expect(result.totalSpent, equals(100.0));
      // Single day has stdDev=0
      expect(result.confidenceInterval.bestCase, equals(result.projectedTotalSpend));
    });

    test('should handle zero budget gracefully', () {
      // Arrange
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 50.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 0.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert
      expect(result.status, equals(ForecastStatus.exhausted));
      expect(result.daysUntilExhaustion, equals(0));
    });

    test('should handle trip not started yet (no spending data)', () {
      // Arrange - Future trip
      final dailySpending = <DateTime, double>{};

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 2, 1),
        tripEndDate: DateTime(2024, 2, 10),
      );

      // Assert
      expect(result.totalSpent, equals(0.0));
      expect(result.dailySpendingRate, equals(0.0));
      expect(result.projectedTotalSpend, equals(0.0));
      expect(result.status, equals(ForecastStatus.onTrack));
      expect(result.historicalSpending, isEmpty);
    });

    test('should sort historical data chronologically', () {
      // Arrange - Out of order dates
      final dailySpending = <DateTime, double>{
        DateTime(2024, 1, 3): 30.0,
        DateTime(2024, 1, 1): 10.0,
        DateTime(2024, 1, 2): 20.0,
      };

      // Act
      final result = useCase.call(
        totalBudget: 1000.0,
        dailySpending: dailySpending,
        tripStartDate: DateTime(2024, 1, 1),
        tripEndDate: DateTime(2024, 1, 10),
      );

      // Assert - Historical should be in chronological order
      for (int i = 1; i < result.historicalSpending.length; i++) {
        expect(
          result.historicalSpending[i].date.isAfter(result.historicalSpending[i - 1].date),
          isTrue,
        );
      }
      // Cumulative values: 10, 30, 60
      expect(result.historicalSpending[0].value, equals(10.0));
      expect(result.historicalSpending[1].value, equals(30.0));
      expect(result.historicalSpending[2].value, equals(60.0));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_spending_velocity.dart';

void main() {
  late CalculateSpendingVelocity useCase;

  setUp(() {
    useCase = CalculateSpendingVelocity();
  });

  group('CalculateSpendingVelocity', () {
    test('should calculate velocity from daily spending data', () {
      // Arrange - 7 days of consistent spending
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 100.0,
        DateTime(2024, 1, 5): 100.0,
        DateTime(2024, 1, 6): 100.0,
        DateTime(2024, 1, 7): 100.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(100.0));
      expect(result.weeklyAverage, equals(700.0)); // 7 * 100
      expect(result.acceleration, equals(0.0)); // Consistent spending = no acceleration
      expect(result.periodStart, equals(DateTime(2024, 1, 1)));
      expect(result.periodEnd, equals(DateTime(2024, 1, 7)));
    });

    test('should calculate positive acceleration for increasing spending', () {
      // Arrange - Spending increases over time
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 110.0,
        DateTime(2024, 1, 3): 120.0,
        DateTime(2024, 1, 4): 130.0,
        DateTime(2024, 1, 5): 140.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(120.0)); // Average of all days
      expect(result.acceleration, greaterThan(0)); // Increasing = positive acceleration
      expect(result.periodStart, equals(DateTime(2024, 1, 1)));
      expect(result.periodEnd, equals(DateTime(2024, 1, 5)));
    });

    test('should calculate negative acceleration for decreasing spending', () {
      // Arrange - Spending decreases over time
      final dailyData = {
        DateTime(2024, 1, 1): 150.0,
        DateTime(2024, 1, 2): 130.0,
        DateTime(2024, 1, 3): 110.0,
        DateTime(2024, 1, 4): 90.0,
        DateTime(2024, 1, 5): 70.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(110.0)); // Average of all days
      expect(result.acceleration, lessThan(0)); // Decreasing = negative acceleration
      expect(result.periodStart, equals(DateTime(2024, 1, 1)));
      expect(result.periodEnd, equals(DateTime(2024, 1, 5)));
    });

    test('should handle single day of data', () {
      // Arrange - Only one day
      final dailyData = {
        DateTime(2024, 1, 15): 250.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(250.0));
      expect(result.weeklyAverage, equals(1750.0)); // 7 * 250
      expect(result.acceleration, equals(0.0)); // No acceleration for single day
      expect(result.periodStart, equals(DateTime(2024, 1, 15)));
      expect(result.periodEnd, equals(DateTime(2024, 1, 15)));
    });

    test('should handle days with zero spending', () {
      // Arrange - Some days with no spending
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 0.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 0.0,
        DateTime(2024, 1, 5): 100.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(60.0)); // 300 / 5 = 60
      expect(result.weeklyAverage, equals(420.0)); // 60 * 7
    });

    test('should calculate correct daily average', () {
      // Arrange - Varying amounts
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 150.0,
        DateTime(2024, 1, 3): 200.0,
        DateTime(2024, 1, 4): 50.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      // Total = 500, Days = 4, Average = 125
      expect(result.dailyAverage, equals(125.0));
      expect(result.weeklyAverage, equals(875.0)); // 125 * 7
    });

    test('should handle large daily amounts', () {
      // Arrange - Large spending values
      final dailyData = {
        DateTime(2024, 1, 1): 10000.0,
        DateTime(2024, 1, 2): 15000.0,
        DateTime(2024, 1, 3): 20000.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(15000.0));
      expect(result.weeklyAverage, equals(105000.0));
    });

    test('should handle decimal amounts', () {
      // Arrange - Decimal values
      final dailyData = {
        DateTime(2024, 1, 1): 123.45,
        DateTime(2024, 1, 2): 234.56,
        DateTime(2024, 1, 3): 345.67,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      // Total = 703.68, Days = 3, Average = 234.56
      expect(result.dailyAverage, closeTo(234.56, 0.01));
      expect(result.weeklyAverage, closeTo(1641.92, 0.1));
    });

    test('should sort dates chronologically', () {
      // Arrange - Dates out of order
      final dailyData = {
        DateTime(2024, 1, 5): 100.0,
        DateTime(2024, 1, 1): 150.0,
        DateTime(2024, 1, 3): 200.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert - Should use sorted dates for period
      expect(result.periodStart, equals(DateTime(2024, 1, 1))); // Earliest
      expect(result.periodEnd, equals(DateTime(2024, 1, 5))); // Latest
    });

    test('should handle periods across different months', () {
      // Arrange - Cross-month period
      final dailyData = {
        DateTime(2024, 1, 28): 100.0,
        DateTime(2024, 1, 29): 110.0,
        DateTime(2024, 1, 30): 120.0,
        DateTime(2024, 1, 31): 130.0,
        DateTime(2024, 2, 1): 140.0,
        DateTime(2024, 2, 2): 150.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.periodStart.month, equals(1));
      expect(result.periodEnd.month, equals(2));
      expect(result.dailyAverage, equals(125.0));
    });

    test('should handle periods across different years', () {
      // Arrange - Cross-year period
      final dailyData = {
        DateTime(2023, 12, 29): 100.0,
        DateTime(2023, 12, 30): 110.0,
        DateTime(2023, 12, 31): 120.0,
        DateTime(2024, 1, 1): 130.0,
        DateTime(2024, 1, 2): 140.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.periodStart.year, equals(2023));
      expect(result.periodEnd.year, equals(2024));
      expect(result.dailyAverage, equals(120.0));
    });

    test('should calculate acceleration from slope of spending over time', () {
      // Arrange - Linear increase: +10 per day
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 110.0,
        DateTime(2024, 1, 3): 120.0,
        DateTime(2024, 1, 4): 130.0,
        DateTime(2024, 1, 5): 140.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      // Slope should be ~10 (spending increases by 10 per day)
      expect(result.acceleration, closeTo(10.0, 0.5));
    });

    test('should calculate negative acceleration for decreasing trend', () {
      // Arrange - Linear decrease: -10 per day
      final dailyData = {
        DateTime(2024, 1, 1): 140.0,
        DateTime(2024, 1, 2): 130.0,
        DateTime(2024, 1, 3): 120.0,
        DateTime(2024, 1, 4): 110.0,
        DateTime(2024, 1, 5): 100.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      // Slope should be ~-10 (spending decreases by 10 per day)
      expect(result.acceleration, closeTo(-10.0, 0.5));
    });

    test('should handle week-long period correctly', () {
      // Arrange - Exactly 7 days
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 110.0,
        DateTime(2024, 1, 3): 120.0,
        DateTime(2024, 1, 4): 130.0,
        DateTime(2024, 1, 5): 140.0,
        DateTime(2024, 1, 6): 150.0,
        DateTime(2024, 1, 7): 160.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      final duration = result.periodEnd.difference(result.periodStart).inDays;
      expect(duration, equals(6)); // 7 days = 6 day difference
      expect(result.dailyAverage, equals(130.0)); // 910 / 7
      expect(result.weeklyAverage, equals(910.0)); // 130 * 7
    });

    test('should handle all zero spending', () {
      // Arrange - No spending at all
      final dailyData = {
        DateTime(2024, 1, 1): 0.0,
        DateTime(2024, 1, 2): 0.0,
        DateTime(2024, 1, 3): 0.0,
      };

      // Act
      final result = useCase.call(dailyData);

      // Assert
      expect(result.dailyAverage, equals(0.0));
      expect(result.weeklyAverage, equals(0.0));
      expect(result.acceleration, equals(0.0));
    });
  });
}

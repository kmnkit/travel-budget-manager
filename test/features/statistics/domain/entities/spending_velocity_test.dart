import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/spending_velocity.dart';

void main() {
  group('SpendingVelocity', () {
    test('should create instance with all required fields', () {
      // Arrange
      const dailyAverage = 150.0;
      const weeklyAverage = 1050.0;
      const acceleration = 5.5;
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 14);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: dailyAverage,
        weeklyAverage: weeklyAverage,
        acceleration: acceleration,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.dailyAverage, equals(dailyAverage));
      expect(velocity.weeklyAverage, equals(weeklyAverage));
      expect(velocity.acceleration, equals(acceleration));
      expect(velocity.periodStart, equals(periodStart));
      expect(velocity.periodEnd, equals(periodEnd));
    });

    test('should support equality comparison', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 14);
      final velocity1 = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.5,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
      final velocity2 = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.5,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
      final velocity3 = SpendingVelocity(
        dailyAverage: 200.0,
        weeklyAverage: 1400.0,
        acceleration: 10.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity1, equals(velocity2)); // Same values
      expect(velocity1, isNot(equals(velocity3))); // Different values
    });

    test('should handle zero velocity', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 7);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 0.0,
        weeklyAverage: 0.0,
        acceleration: 0.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.dailyAverage, equals(0.0));
      expect(velocity.weeklyAverage, equals(0.0));
      expect(velocity.acceleration, equals(0.0));
    });

    test('should handle positive acceleration (increasing spending)', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 14);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 15.5, // Positive = increasing
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.acceleration, greaterThan(0));
      expect(velocity.acceleration, equals(15.5));
    });

    test('should handle negative acceleration (decreasing spending)', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 14);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: -10.5, // Negative = decreasing
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.acceleration, lessThan(0));
      expect(velocity.acceleration, equals(-10.5));
    });

    test('should handle decimal values for averages', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 10);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 123.45,
        weeklyAverage: 864.15,
        acceleration: 2.34,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.dailyAverage, equals(123.45));
      expect(velocity.weeklyAverage, equals(864.15));
      expect(velocity.acceleration, equals(2.34));
    });

    test('should handle large values', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 30);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 50000.0,
        weeklyAverage: 350000.0,
        acceleration: 1000.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.dailyAverage, equals(50000.0));
      expect(velocity.weeklyAverage, equals(350000.0));
      expect(velocity.acceleration, equals(1000.0));
    });

    test('should handle periods across different months', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 25);
      final periodEnd = DateTime(2024, 2, 5);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.periodStart.month, equals(1));
      expect(velocity.periodEnd.month, equals(2));
      expect(velocity.periodStart.isBefore(velocity.periodEnd), isTrue);
    });

    test('should handle periods across different years', () {
      // Arrange
      final periodStart = DateTime(2023, 12, 25);
      final periodEnd = DateTime(2024, 1, 5);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 200.0,
        weeklyAverage: 1400.0,
        acceleration: 8.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.periodStart.year, equals(2023));
      expect(velocity.periodEnd.year, equals(2024));
      expect(velocity.periodStart.isBefore(velocity.periodEnd), isTrue);
    });

    test('should support copyWith for immutability', () {
      // Arrange
      final original = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 14),
      );

      // Act
      final updated = original.copyWith(
        dailyAverage: 200.0,
        acceleration: 10.0,
      );

      // Assert
      expect(updated.dailyAverage, equals(200.0));
      expect(updated.weeklyAverage, equals(1050.0)); // Unchanged
      expect(updated.acceleration, equals(10.0));
      expect(updated.periodStart, equals(original.periodStart)); // Unchanged
      expect(updated.periodEnd, equals(original.periodEnd)); // Unchanged
      expect(original.dailyAverage, equals(150.0)); // Original unchanged
    });

    test('should handle same-day period (single day)', () {
      // Arrange
      final singleDay = DateTime(2024, 1, 15);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 250.0,
        weeklyAverage: 250.0, // Same as daily for single day
        acceleration: 0.0, // No acceleration for single day
        periodStart: singleDay,
        periodEnd: singleDay,
      );

      // Assert
      expect(velocity.periodStart, equals(velocity.periodEnd));
      expect(velocity.dailyAverage, equals(velocity.weeklyAverage));
    });

    test('should calculate duration in days correctly', () {
      // Arrange
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 8); // 7 days

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: 100.0,
        weeklyAverage: 700.0,
        acceleration: 0.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Calculate duration
      final duration = velocity.periodEnd.difference(velocity.periodStart).inDays;

      // Assert
      expect(duration, equals(7));
    });

    test('should maintain relationship between daily and weekly averages', () {
      // Arrange
      const dailyAverage = 150.0;
      const weeklyAverage = 1050.0; // 7 * dailyAverage
      final periodStart = DateTime(2024, 1, 1);
      final periodEnd = DateTime(2024, 1, 14);

      // Act
      final velocity = SpendingVelocity(
        dailyAverage: dailyAverage,
        weeklyAverage: weeklyAverage,
        acceleration: 0.0,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      // Assert
      expect(velocity.weeklyAverage, equals(velocity.dailyAverage * 7));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/calculate_trend_analysis.dart';

void main() {
  late CalculateTrendAnalysis useCase;

  setUp(() {
    useCase = CalculateTrendAnalysis();
  });

  group('CalculateTrendAnalysis', () {
    test('should calculate upward trend from increasing data', () {
      // Arrange - Clearly increasing data
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 140.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 160.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 180.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.up));
      expect(result.changePercentage, greaterThan(0));
      expect(result.historicalData, equals(dataPoints));
      expect(result.confidence, greaterThan(0.5)); // High confidence for clear trend
    });

    test('should calculate downward trend from decreasing data', () {
      // Arrange - Clearly decreasing data
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 180.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 160.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 140.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 100.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.down));
      expect(result.changePercentage, lessThan(0));
      expect(result.historicalData, equals(dataPoints));
      expect(result.confidence, greaterThan(0.5)); // High confidence for clear trend
    });

    test('should calculate stable trend from flat data', () {
      // Arrange - Mostly flat data with small variations
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 101.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 99.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 100.5),
        DataPoint(date: DateTime(2024, 1, 5), value: 100.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.stable));
      expect(result.changePercentage.abs(), lessThan(5.0)); // Near zero
      expect(result.historicalData, equals(dataPoints));
    });

    test('should calculate correct change percentage', () {
      // Arrange - 50% increase (100 -> 150)
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 115.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 130.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 145.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 150.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      // Change from 100 to 150 = 50% increase
      expect(result.changePercentage, closeTo(50.0, 1.0));
    });

    test('should calculate confidence score between 0 and 1', () {
      // Arrange
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 140.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.confidence, greaterThanOrEqualTo(0.0));
      expect(result.confidence, lessThanOrEqualTo(1.0));
    });

    test('should handle minimum data points (2 points)', () {
      // Arrange - Minimum viable data
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 150.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.up));
      expect(result.changePercentage, equals(50.0)); // 100 -> 150 = 50% increase
      expect(result.historicalData, equals(dataPoints));
    });

    test('should handle noisy data with overall upward trend', () {
      // Arrange - Upward trend with noise
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 90.0),  // Dip
        DataPoint(date: DateTime(2024, 1, 3), value: 130.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 120.0), // Dip
        DataPoint(date: DateTime(2024, 1, 5), value: 160.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.up)); // Overall trend is up
      expect(result.changePercentage, greaterThan(0)); // Net positive change
    });

    test('should generate projected data when requested', () {
      // Arrange
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 140.0),
      ];

      // Act
      final result = useCase.call(dataPoints, projectDays: 3);

      // Assert
      expect(result.projectedData, isNotNull);
      expect(result.projectedData!.length, equals(3));
      expect(result.projectedData!.first.date.isAfter(dataPoints.last.date), isTrue);
    });

    test('should not generate projected data when not requested', () {
      // Arrange
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
      ];

      // Act
      final result = useCase.call(dataPoints); // No projectDays parameter

      // Assert
      expect(result.projectedData, isNull);
    });

    test('should handle all identical values as stable', () {
      // Arrange - No variation
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 100.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.stable));
      expect(result.changePercentage, equals(0.0));
    });

    test('should handle large values without overflow', () {
      // Arrange - Large numbers
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 1000000.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 1200000.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 1400000.0),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.up));
      expect(result.changePercentage, closeTo(40.0, 1.0)); // 1M -> 1.4M = 40%
    });

    test('should handle decimal values with precision', () {
      // Arrange - Decimal values
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 123.45),
        DataPoint(date: DateTime(2024, 1, 2), value: 156.78),
        DataPoint(date: DateTime(2024, 1, 3), value: 189.12),
      ];

      // Act
      final result = useCase.call(dataPoints);

      // Assert
      expect(result.direction, equals(TrendDirection.up));
      expect(result.changePercentage, greaterThan(0));
    });

    test('should have higher confidence for clear trends', () {
      // Arrange - Perfect linear trend
      final perfectTrend = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 110.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 130.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 140.0),
      ];

      // Noisy trend
      final noisyTrend = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 90.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 130.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 115.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 140.0),
      ];

      // Act
      final perfectResult = useCase.call(perfectTrend);
      final noisyResult = useCase.call(noisyTrend);

      // Assert
      expect(perfectResult.confidence, greaterThan(noisyResult.confidence));
    });

    test('should project future values along the trend line', () {
      // Arrange - Linear upward trend
      final dataPoints = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 110.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 120.0),
      ];

      // Act
      final result = useCase.call(dataPoints, projectDays: 2);

      // Assert
      expect(result.projectedData, isNotNull);
      expect(result.projectedData!.length, equals(2));
      // Next day should be ~130, day after ~140
      expect(result.projectedData![0].value, closeTo(130.0, 5.0));
      expect(result.projectedData![1].value, closeTo(140.0, 5.0));
    });
  });
}

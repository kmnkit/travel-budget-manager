import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

void main() {
  group('DataPoint', () {
    test('should create instance with date and value', () {
      // Arrange
      final date = DateTime(2024, 1, 15);
      const value = 100.0;

      // Act
      final dataPoint = DataPoint(date: date, value: value);

      // Assert
      expect(dataPoint.date, equals(date));
      expect(dataPoint.value, equals(value));
    });

    test('should support equality comparison', () {
      // Arrange
      final date = DateTime(2024, 1, 15);
      final point1 = DataPoint(date: date, value: 100.0);
      final point2 = DataPoint(date: date, value: 100.0);
      final point3 = DataPoint(date: date, value: 200.0);

      // Assert
      expect(point1, equals(point2)); // Same values
      expect(point1, isNot(equals(point3))); // Different value
    });
  });

  group('TrendDirection', () {
    test('should have three directions', () {
      // Assert
      expect(TrendDirection.values.length, equals(3));
      expect(TrendDirection.values, contains(TrendDirection.up));
      expect(TrendDirection.values, contains(TrendDirection.down));
      expect(TrendDirection.values, contains(TrendDirection.stable));
    });
  });

  group('TrendData', () {
    test('should create instance with all required fields', () {
      // Arrange
      final historicalData = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 150.0),
      ];
      final projectedData = [
        DataPoint(date: DateTime(2024, 1, 3), value: 200.0),
      ];
      const direction = TrendDirection.up;
      const changePercentage = 15.5;
      const confidence = 0.85;

      // Act
      final trendData = TrendData(
        historicalData: historicalData,
        projectedData: projectedData,
        direction: direction,
        changePercentage: changePercentage,
        confidence: confidence,
      );

      // Assert
      expect(trendData.historicalData, equals(historicalData));
      expect(trendData.projectedData, equals(projectedData));
      expect(trendData.direction, equals(direction));
      expect(trendData.changePercentage, equals(changePercentage));
      expect(trendData.confidence, equals(confidence));
    });

    test('should allow null projectedData', () {
      // Arrange
      final historicalData = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
      ];

      // Act
      final trendData = TrendData(
        historicalData: historicalData,
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.0,
        confidence: 1.0,
      );

      // Assert
      expect(trendData.projectedData, isNull);
    });

    test('should handle upward trend', () {
      // Arrange
      final historicalData = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 150.0),
      ];

      // Act
      final trendData = TrendData(
        historicalData: historicalData,
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 50.0, // 50% increase
        confidence: 0.9,
      );

      // Assert
      expect(trendData.direction, equals(TrendDirection.up));
      expect(trendData.changePercentage, equals(50.0));
      expect(trendData.changePercentage, greaterThan(0));
    });

    test('should handle downward trend', () {
      // Arrange
      final historicalData = [
        DataPoint(date: DateTime(2024, 1, 1), value: 150.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 100.0),
      ];

      // Act
      final trendData = TrendData(
        historicalData: historicalData,
        projectedData: null,
        direction: TrendDirection.down,
        changePercentage: -33.3, // 33.3% decrease
        confidence: 0.85,
      );

      // Assert
      expect(trendData.direction, equals(TrendDirection.down));
      expect(trendData.changePercentage, equals(-33.3));
      expect(trendData.changePercentage, lessThan(0));
    });

    test('should handle stable trend', () {
      // Arrange
      final historicalData = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 101.0),
        DataPoint(date: DateTime(2024, 1, 3), value: 99.0),
      ];

      // Act
      final trendData = TrendData(
        historicalData: historicalData,
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.5, // Very small change
        confidence: 0.95,
      );

      // Assert
      expect(trendData.direction, equals(TrendDirection.stable));
      expect(trendData.changePercentage.abs(), lessThan(5.0)); // Near zero
    });

    test('should handle confidence values between 0 and 1', () {
      // Arrange & Act
      final lowConfidence = TrendData(
        historicalData: [DataPoint(date: DateTime(2024, 1, 1), value: 100.0)],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.0,
        confidence: 0.3,
      );

      final highConfidence = TrendData(
        historicalData: [DataPoint(date: DateTime(2024, 1, 1), value: 100.0)],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 25.0,
        confidence: 0.95,
      );

      // Assert
      expect(lowConfidence.confidence, equals(0.3));
      expect(lowConfidence.confidence, greaterThanOrEqualTo(0.0));
      expect(lowConfidence.confidence, lessThanOrEqualTo(1.0));

      expect(highConfidence.confidence, equals(0.95));
      expect(highConfidence.confidence, greaterThanOrEqualTo(0.0));
      expect(highConfidence.confidence, lessThanOrEqualTo(1.0));
    });

    test('should handle empty historical data', () {
      // Act
      final trendData = TrendData(
        historicalData: [],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.0,
        confidence: 0.0,
      );

      // Assert
      expect(trendData.historicalData, isEmpty);
    });

    test('should support copyWith for immutability', () {
      // Arrange
      final original = TrendData(
        historicalData: [DataPoint(date: DateTime(2024, 1, 1), value: 100.0)],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 10.0,
        confidence: 0.8,
      );

      // Act
      final updated = original.copyWith(
        changePercentage: 15.0,
        confidence: 0.9,
      );

      // Assert
      expect(updated.historicalData, equals(original.historicalData));
      expect(updated.direction, equals(original.direction));
      expect(updated.changePercentage, equals(15.0));
      expect(updated.confidence, equals(0.9));
      expect(original.changePercentage, equals(10.0)); // Original unchanged
    });

    test('should handle projected data with future dates', () {
      // Arrange
      final historicalData = [
        DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
      ];
      final projectedData = [
        DataPoint(date: DateTime(2024, 1, 3), value: 140.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 160.0),
        DataPoint(date: DateTime(2024, 1, 5), value: 180.0),
      ];

      // Act
      final trendData = TrendData(
        historicalData: historicalData,
        projectedData: projectedData,
        direction: TrendDirection.up,
        changePercentage: 80.0,
        confidence: 0.7,
      );

      // Assert
      expect(trendData.projectedData, isNotNull);
      expect(trendData.projectedData!.length, equals(3));
      expect(trendData.projectedData!.first.value, equals(140.0));
      expect(trendData.projectedData!.last.value, equals(180.0));
    });
  });
}

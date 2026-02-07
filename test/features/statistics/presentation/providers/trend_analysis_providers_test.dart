import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/domain/entities/spending_velocity.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/trend_analysis_providers.dart';

void main() {
  group('TrendAnalysisData', () {
    test('should create instance with all required fields', () {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.85,
      );

      // Act
      final analysisData = TrendAnalysisData(
        categoryTrends: {'food': trendData},
        overallTrend: trendData,
      );

      // Assert
      expect(analysisData.categoryTrends, equals({'food': trendData}));
      expect(analysisData.overallTrend, equals(trendData));
    });

    test('should handle empty category trends', () {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        ],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.0,
        confidence: 1.0,
      );

      // Act
      final analysisData = TrendAnalysisData(
        categoryTrends: {},
        overallTrend: trendData,
      );

      // Assert
      expect(analysisData.categoryTrends, isEmpty);
      expect(analysisData.overallTrend, equals(trendData));
    });

    test('should handle multiple category trends', () {
      // Arrange
      final foodTrend = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.85,
      );

      final transportTrend = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 50.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 45.0),
        ],
        projectedData: null,
        direction: TrendDirection.down,
        changePercentage: -10.0,
        confidence: 0.75,
      );

      final overallTrend = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 150.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 165.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 10.0,
        confidence: 0.90,
      );

      // Act
      final analysisData = TrendAnalysisData(
        categoryTrends: {
          'food': foodTrend,
          'transport': transportTrend,
        },
        overallTrend: overallTrend,
      );

      // Assert
      expect(analysisData.categoryTrends.length, equals(2));
      expect(analysisData.categoryTrends['food'], equals(foodTrend));
      expect(analysisData.categoryTrends['transport'], equals(transportTrend));
      expect(analysisData.overallTrend, equals(overallTrend));
    });

    test('should handle trends with projected data', () {
      // Arrange
      final projectedData = [
        DataPoint(date: DateTime(2024, 1, 3), value: 140.0),
        DataPoint(date: DateTime(2024, 1, 4), value: 160.0),
      ];

      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: projectedData,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.85,
      );

      // Act
      final analysisData = TrendAnalysisData(
        categoryTrends: {'food': trendData},
        overallTrend: trendData,
      );

      // Assert
      expect(analysisData.categoryTrends['food']?.projectedData, isNotNull);
      expect(analysisData.categoryTrends['food']?.projectedData?.length, equals(2));
      expect(analysisData.overallTrend.projectedData, equals(projectedData));
    });

    test('should support equality comparison', () {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 10.0,
        confidence: 0.8,
      );

      final data1 = TrendAnalysisData(
        categoryTrends: {'food': trendData},
        overallTrend: trendData,
      );

      final data2 = TrendAnalysisData(
        categoryTrends: {'food': trendData},
        overallTrend: trendData,
      );

      final data3 = TrendAnalysisData(
        categoryTrends: {},
        overallTrend: trendData,
      );

      // Assert
      expect(data1, equals(data2)); // Same values
      expect(data1, isNot(equals(data3))); // Different values
    });
  });

  group('SpendingVelocityData', () {
    test('should create instance with velocity and period', () {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.5,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 14),
      );

      // Act
      final velocityData = SpendingVelocityData(
        velocity: velocity,
      );

      // Assert
      expect(velocityData.velocity, equals(velocity));
    });

    test('should support equality comparison', () {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.5,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 14),
      );

      final data1 = SpendingVelocityData(velocity: velocity);
      final data2 = SpendingVelocityData(velocity: velocity);

      // Assert
      expect(data1, equals(data2));
    });
  });
}

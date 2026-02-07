import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';

void main() {
  group('AnalyticsInsight', () {
    test('should create instance with all required fields', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'insight-1',
        type: InsightType.spending,
        title: '높은 식비 지출',
        description: '식비가 전체 지출의 40%를 차지합니다',
        priority: InsightPriority.medium,
        generatedAt: DateTime(2024, 1, 15),
      );

      // Assert
      expect(insight.id, 'insight-1');
      expect(insight.type, InsightType.spending);
      expect(insight.title, '높은 식비 지출');
      expect(insight.description, '식비가 전체 지출의 40%를 차지합니다');
      expect(insight.priority, InsightPriority.medium);
      expect(insight.generatedAt, DateTime(2024, 1, 15));
      expect(insight.metadata, isNull);
    });

    test('should support equality comparison', () {
      // Arrange
      final insight1 = AnalyticsInsight(
        id: 'insight-1',
        type: InsightType.spending,
        title: 'Test',
        description: 'Description',
        priority: InsightPriority.high,
        generatedAt: DateTime(2024, 1, 15),
      );

      final insight2 = AnalyticsInsight(
        id: 'insight-1',
        type: InsightType.spending,
        title: 'Test',
        description: 'Description',
        priority: InsightPriority.high,
        generatedAt: DateTime(2024, 1, 15),
      );

      final insight3 = AnalyticsInsight(
        id: 'insight-2',
        type: InsightType.budget,
        title: 'Different',
        description: 'Different',
        priority: InsightPriority.low,
        generatedAt: DateTime(2024, 1, 16),
      );

      // Assert
      expect(insight1, equals(insight2));
      expect(insight1, isNot(equals(insight3)));
    });

    test('should handle optional metadata field', () {
      // Arrange & Act
      final insightWithoutMetadata = AnalyticsInsight(
        id: 'insight-1',
        type: InsightType.spending,
        title: 'Test',
        description: 'Description',
        priority: InsightPriority.medium,
        generatedAt: DateTime(2024, 1, 15),
      );

      final insightWithMetadata = AnalyticsInsight(
        id: 'insight-2',
        type: InsightType.budget,
        title: 'Test',
        description: 'Description',
        priority: InsightPriority.high,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {'percentage': 40.5, 'category': 'Food'},
      );

      // Assert
      expect(insightWithoutMetadata.metadata, isNull);
      expect(insightWithMetadata.metadata, isNotNull);
      expect(insightWithMetadata.metadata!['percentage'], 40.5);
      expect(insightWithMetadata.metadata!['category'], 'Food');
    });

    test('should handle all InsightType values', () {
      // Test each InsightType
      final types = [
        InsightType.spending,
        InsightType.budget,
        InsightType.trend,
        InsightType.anomaly,
        InsightType.recommendation,
      ];

      for (final type in types) {
        final insight = AnalyticsInsight(
          id: 'insight-$type',
          type: type,
          title: 'Test $type',
          description: 'Test description',
          priority: InsightPriority.medium,
          generatedAt: DateTime(2024, 1, 15),
        );

        expect(insight.type, type);
      }
    });

    test('should handle all InsightPriority values', () {
      // Test each InsightPriority
      final priorities = [
        InsightPriority.high,
        InsightPriority.medium,
        InsightPriority.low,
      ];

      for (final priority in priorities) {
        final insight = AnalyticsInsight(
          id: 'insight-$priority',
          type: InsightType.spending,
          title: 'Test',
          description: 'Test description',
          priority: priority,
          generatedAt: DateTime(2024, 1, 15),
        );

        expect(insight.priority, priority);
      }
    });

    test('should support copyWith for immutability', () {
      // Arrange
      final original = AnalyticsInsight(
        id: 'insight-1',
        type: InsightType.spending,
        title: 'Original Title',
        description: 'Original Description',
        priority: InsightPriority.medium,
        generatedAt: DateTime(2024, 1, 15),
      );

      // Act
      final copied = original.copyWith(
        title: 'Updated Title',
        priority: InsightPriority.high,
      );

      // Assert
      expect(copied.id, original.id);
      expect(copied.type, original.type);
      expect(copied.title, 'Updated Title');
      expect(copied.description, original.description);
      expect(copied.priority, InsightPriority.high);
      expect(copied.generatedAt, original.generatedAt);
    });

    test('should handle spending type insight', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'spending-1',
        type: InsightType.spending,
        title: '식비 지출 증가',
        description: '이번 달 식비가 지난달 대비 25% 증가했습니다',
        priority: InsightPriority.medium,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {
          'category': 'Food',
          'increasePercentage': 25.0,
          'currentAmount': 500000,
          'previousAmount': 400000,
        },
      );

      // Assert
      expect(insight.type, InsightType.spending);
      expect(insight.metadata!['category'], 'Food');
      expect(insight.metadata!['increasePercentage'], 25.0);
    });

    test('should handle budget type insight', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'budget-1',
        type: InsightType.budget,
        title: '예산 초과 경고',
        description: '현재 지출이 예산의 95%에 도달했습니다',
        priority: InsightPriority.high,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {
          'budgetAmount': 1000000,
          'spentAmount': 950000,
          'percentage': 95.0,
        },
      );

      // Assert
      expect(insight.type, InsightType.budget);
      expect(insight.priority, InsightPriority.high);
      expect(insight.metadata!['percentage'], 95.0);
    });

    test('should handle anomaly type insight', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'anomaly-1',
        type: InsightType.anomaly,
        title: '비정상적인 지출 감지',
        description: '평소보다 3배 높은 쇼핑 지출이 발생했습니다',
        priority: InsightPriority.high,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {
          'category': 'Shopping',
          'normalAmount': 100000,
          'currentAmount': 300000,
          'multiplier': 3.0,
        },
      );

      // Assert
      expect(insight.type, InsightType.anomaly);
      expect(insight.priority, InsightPriority.high);
      expect(insight.metadata!['multiplier'], 3.0);
    });

    test('should handle recommendation type insight', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'recommendation-1',
        type: InsightType.recommendation,
        title: '지출 절감 제안',
        description: '교통비를 월 50,000원 절감할 수 있습니다',
        priority: InsightPriority.medium,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {
          'category': 'Transportation',
          'potentialSavings': 50000,
          'suggestion': 'Use public transport instead of taxi',
        },
      );

      // Assert
      expect(insight.type, InsightType.recommendation);
      expect(insight.metadata!['potentialSavings'], 50000);
      expect(insight.metadata!['suggestion'], isA<String>());
    });

    test('should handle trend type insight', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'trend-1',
        type: InsightType.trend,
        title: '지출 감소 추세',
        description: '최근 3개월간 지출이 지속적으로 감소하고 있습니다',
        priority: InsightPriority.low,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {
          'trendDirection': 'decreasing',
          'months': 3,
          'averageDecrease': 5.5,
        },
      );

      // Assert
      expect(insight.type, InsightType.trend);
      expect(insight.metadata!['trendDirection'], 'decreasing');
      expect(insight.metadata!['months'], 3);
    });

    test('should handle metadata with various types', () {
      // Arrange & Act
      final insight = AnalyticsInsight(
        id: 'metadata-test',
        type: InsightType.spending,
        title: 'Metadata Test',
        description: 'Testing various metadata types',
        priority: InsightPriority.low,
        generatedAt: DateTime(2024, 1, 15),
        metadata: {
          'stringValue': 'test',
          'intValue': 42,
          'doubleValue': 3.14,
          'boolValue': true,
          'listValue': [1, 2, 3],
          'mapValue': {'nested': 'data'},
          'nullValue': null,
        },
      );

      // Assert
      expect(insight.metadata!['stringValue'], 'test');
      expect(insight.metadata!['intValue'], 42);
      expect(insight.metadata!['doubleValue'], 3.14);
      expect(insight.metadata!['boolValue'], true);
      expect(insight.metadata!['listValue'], [1, 2, 3]);
      expect(insight.metadata!['mapValue'], {'nested': 'data'});
      expect(insight.metadata!['nullValue'], null);
    });
  });
}

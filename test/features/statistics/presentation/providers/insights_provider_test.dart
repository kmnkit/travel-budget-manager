import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/insights_provider.dart';

void main() {
  group('InsightsData', () {
    test('should create instance with insights list', () {
      final insights = [
        AnalyticsInsight(
          id: 'test_1',
          type: InsightType.spending,
          title: '식비 지출 비중 높음',
          description: '식비가 전체 지출의 45.0%를 차지합니다',
          priority: InsightPriority.high,
          generatedAt: DateTime(2024, 1, 1),
        ),
      ];
      final data = InsightsData(insights: insights);
      expect(data.insights, hasLength(1));
      expect(data.insights.first.type, equals(InsightType.spending));
    });

    test('should support equality comparison', () {
      final insights = [
        AnalyticsInsight(
          id: 'test_1',
          type: InsightType.spending,
          title: '테스트',
          description: '테스트 설명',
          priority: InsightPriority.high,
          generatedAt: DateTime(2024, 1, 1),
        ),
      ];
      final data1 = InsightsData(insights: insights);
      final data2 = InsightsData(insights: insights);
      expect(data1, equals(data2));
    });

    test('should handle empty insights', () {
      final data = InsightsData(insights: []);
      expect(data.insights, isEmpty);
    });

    test('should have correct equality with different lists', () {
      final data1 = InsightsData(insights: [
        AnalyticsInsight(id: 'a', type: InsightType.spending, title: 't', description: 'd', priority: InsightPriority.high, generatedAt: DateTime(2024, 1, 1)),
      ]);
      final data2 = InsightsData(insights: [
        AnalyticsInsight(id: 'b', type: InsightType.budget, title: 't2', description: 'd2', priority: InsightPriority.low, generatedAt: DateTime(2024, 1, 1)),
      ]);
      expect(data1, isNot(equals(data2)));
    });

    test('should handle multiple insights of different types', () {
      final data = InsightsData(insights: [
        AnalyticsInsight(id: '1', type: InsightType.spending, title: '지출', description: '설명', priority: InsightPriority.high, generatedAt: DateTime(2024, 1, 1)),
        AnalyticsInsight(id: '2', type: InsightType.budget, title: '예산', description: '설명', priority: InsightPriority.medium, generatedAt: DateTime(2024, 1, 1)),
        AnalyticsInsight(id: '3', type: InsightType.anomaly, title: '이상', description: '설명', priority: InsightPriority.high, generatedAt: DateTime(2024, 1, 1)),
        AnalyticsInsight(id: '4', type: InsightType.recommendation, title: '추천', description: '설명', priority: InsightPriority.low, generatedAt: DateTime(2024, 1, 1)),
      ]);
      expect(data.insights, hasLength(4));
    });

    test('should have consistent hashCode with equality', () {
      final insights = [
        AnalyticsInsight(id: '1', type: InsightType.spending, title: 't', description: 'd', priority: InsightPriority.high, generatedAt: DateTime(2024, 1, 1)),
      ];
      final data1 = InsightsData(insights: insights);
      final data2 = InsightsData(insights: insights);
      expect(data1.hashCode, equals(data2.hashCode));
    });

    test('should handle insights sorted by priority', () {
      final data = InsightsData(insights: [
        AnalyticsInsight(id: '1', type: InsightType.spending, title: '높음', description: 'd', priority: InsightPriority.high, generatedAt: DateTime(2024, 1, 1)),
        AnalyticsInsight(id: '2', type: InsightType.budget, title: '중간', description: 'd', priority: InsightPriority.medium, generatedAt: DateTime(2024, 1, 1)),
        AnalyticsInsight(id: '3', type: InsightType.recommendation, title: '낮음', description: 'd', priority: InsightPriority.low, generatedAt: DateTime(2024, 1, 1)),
      ]);
      expect(data.insights[0].priority, equals(InsightPriority.high));
      expect(data.insights[1].priority, equals(InsightPriority.medium));
      expect(data.insights[2].priority, equals(InsightPriority.low));
    });

    test('should handle insights with metadata', () {
      final data = InsightsData(insights: [
        AnalyticsInsight(
          id: '1',
          type: InsightType.spending,
          title: '메타데이터 테스트',
          description: '설명',
          priority: InsightPriority.high,
          generatedAt: DateTime(2024, 1, 1),
          metadata: {'category': '식비', 'percentage': 45.0},
        ),
      ]);
      expect(data.insights.first.metadata, isNotNull);
      expect(data.insights.first.metadata!['category'], equals('식비'));
    });
  });
}

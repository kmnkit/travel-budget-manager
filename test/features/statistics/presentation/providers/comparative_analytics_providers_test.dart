import 'package:flutter_test/flutter_test.dart' hide ComparisonResult;
import 'package:trip_wallet/features/statistics/domain/entities/comparison_result.dart';
import 'package:trip_wallet/features/statistics/domain/entities/category_insight.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/comparative_analytics_providers.dart';

void main() {
  group('PeriodComparisonData', () {
    test('should create instance with all fields', () {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 150000.0,
          comparisonValue: 120000.0,
          difference: 30000.0,
          percentageChange: 25.0,
          direction: TrendDirection.up,
        ),
      ];

      final data = PeriodComparisonData(
        comparisons: comparisons,
        periodLabel: '이번 주 vs 지난 주',
      );

      expect(data.comparisons, hasLength(1));
      expect(data.periodLabel, equals('이번 주 vs 지난 주'));
    });

    test('should support equality comparison', () {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 100.0,
          comparisonValue: 80.0,
          difference: 20.0,
          percentageChange: 25.0,
          direction: TrendDirection.up,
        ),
      ];

      final data1 = PeriodComparisonData(
        comparisons: comparisons,
        periodLabel: '비교',
      );
      final data2 = PeriodComparisonData(
        comparisons: comparisons,
        periodLabel: '비교',
      );

      expect(data1, equals(data2));
    });

    test('should handle empty comparisons', () {
      final data = PeriodComparisonData(
        comparisons: [],
        periodLabel: '비교',
      );

      expect(data.comparisons, isEmpty);
    });

    test('should handle multiple comparisons', () {
      final comparisons = [
        ComparisonResult(
          label: '식비',
          currentValue: 50000.0,
          comparisonValue: 40000.0,
          difference: 10000.0,
          percentageChange: 25.0,
          direction: TrendDirection.up,
        ),
        ComparisonResult(
          label: '교통비',
          currentValue: 20000.0,
          comparisonValue: 30000.0,
          difference: -10000.0,
          percentageChange: -33.3,
          direction: TrendDirection.down,
        ),
      ];

      final data = PeriodComparisonData(
        comparisons: comparisons,
        periodLabel: '카테고리 비교',
      );

      expect(data.comparisons, hasLength(2));
    });
  });

  group('CategoryInsightsData', () {
    test('should create instance with insights list', () {
      final insights = [
        CategoryInsight(
          category: '식비',
          amount: 150000.0,
          percentage: 50.0,
          rank: 1,
          topExpenseDescriptions: ['점심', '저녁'],
        ),
      ];

      final data = CategoryInsightsData(insights: insights);

      expect(data.insights, hasLength(1));
      expect(data.insights.first.category, equals('식비'));
    });

    test('should support equality comparison', () {
      final insights = [
        CategoryInsight(
          category: '식비',
          amount: 100.0,
          percentage: 100.0,
          rank: 1,
          topExpenseDescriptions: [],
        ),
      ];

      final data1 = CategoryInsightsData(insights: insights);
      final data2 = CategoryInsightsData(insights: insights);

      expect(data1, equals(data2));
    });

    test('should handle empty insights', () {
      final data = CategoryInsightsData(insights: []);

      expect(data.insights, isEmpty);
    });

    test('should handle multiple insights', () {
      final insights = [
        CategoryInsight(
          category: '식비',
          amount: 50000.0,
          percentage: 50.0,
          rank: 1,
          topExpenseDescriptions: [],
        ),
        CategoryInsight(
          category: '교통비',
          amount: 30000.0,
          percentage: 30.0,
          rank: 2,
          topExpenseDescriptions: [],
        ),
        CategoryInsight(
          category: '숙박',
          amount: 20000.0,
          percentage: 20.0,
          rank: 3,
          topExpenseDescriptions: [],
        ),
      ];

      final data = CategoryInsightsData(insights: insights);

      expect(data.insights, hasLength(3));
      expect(data.insights.first.rank, equals(1));
      expect(data.insights.last.rank, equals(3));
    });
  });
}

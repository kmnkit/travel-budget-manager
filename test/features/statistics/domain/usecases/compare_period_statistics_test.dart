import 'package:flutter_test/flutter_test.dart';

import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/compare_period_statistics.dart';

void main() {
  late ComparePeriodStatistics useCase;

  setUp(() {
    useCase = ComparePeriodStatistics();
  });

  group('ComparePeriodStatistics', () {
    test('should compare total spending between two periods', () {
      final currentPeriod = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 150.0,
        DateTime(2024, 1, 3): 200.0,
      };
      final previousPeriod = {
        DateTime(2023, 12, 25): 80.0,
        DateTime(2023, 12, 26): 120.0,
        DateTime(2023, 12, 27): 100.0,
      };

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '이번 주 vs 지난 주',
      );

      expect(result.label, equals('이번 주 vs 지난 주'));
      expect(result.currentValue, equals(450.0));
      expect(result.comparisonValue, equals(300.0));
      expect(result.difference, equals(150.0));
      expect(result.percentageChange, equals(50.0));
      expect(result.direction, equals(TrendDirection.up));
    });

    test('should detect decreased spending', () {
      final currentPeriod = {
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 30.0,
      };
      final previousPeriod = {
        DateTime(2023, 12, 25): 100.0,
        DateTime(2023, 12, 26): 100.0,
      };

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.direction, equals(TrendDirection.down));
      expect(result.percentageChange, lessThan(0));
      expect(result.difference, lessThan(0));
    });

    test('should detect stable spending within 5% threshold', () {
      final currentPeriod = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 102.0,
      };
      final previousPeriod = {
        DateTime(2023, 12, 25): 100.0,
        DateTime(2023, 12, 26): 100.0,
      };

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.direction, equals(TrendDirection.stable));
      expect(result.percentageChange.abs(), lessThan(5.0));
    });

    test('should handle empty current period', () {
      final currentPeriod = <DateTime, double>{};
      final previousPeriod = {
        DateTime(2023, 12, 25): 100.0,
      };

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.currentValue, equals(0.0));
      expect(result.direction, equals(TrendDirection.down));
    });

    test('should handle empty previous period', () {
      final currentPeriod = {
        DateTime(2024, 1, 1): 100.0,
      };
      final previousPeriod = <DateTime, double>{};

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.comparisonValue, equals(0.0));
      expect(result.direction, equals(TrendDirection.up));
    });

    test('should handle both periods empty', () {
      final result = useCase.call(
        currentDailyTotals: {},
        previousDailyTotals: {},
        label: '비교',
      );

      expect(result.currentValue, equals(0.0));
      expect(result.comparisonValue, equals(0.0));
      expect(result.difference, equals(0.0));
      expect(result.percentageChange, equals(0.0));
      expect(result.direction, equals(TrendDirection.stable));
    });

    test('should handle single day periods', () {
      final currentPeriod = {DateTime(2024, 1, 1): 500.0};
      final previousPeriod = {DateTime(2023, 12, 31): 300.0};

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.currentValue, equals(500.0));
      expect(result.comparisonValue, equals(300.0));
    });

    test('should handle zero spending in previous period', () {
      final currentPeriod = {DateTime(2024, 1, 1): 100.0};
      final previousPeriod = {DateTime(2023, 12, 31): 0.0};

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.comparisonValue, equals(0.0));
      expect(result.percentageChange, equals(100.0));
      expect(result.direction, equals(TrendDirection.up));
    });

    test('should handle large values without overflow', () {
      final currentPeriod = {
        DateTime(2024, 1, 1): 50000000.0,
        DateTime(2024, 1, 2): 49999999.99,
      };
      final previousPeriod = {
        DateTime(2023, 12, 31): 40000000.0,
        DateTime(2023, 12, 30): 39999999.99,
      };

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.currentValue, closeTo(99999999.99, 0.01));
      expect(result.comparisonValue, closeTo(79999999.99, 0.01));
    });

    test('should handle decimal precision', () {
      final currentPeriod = {
        DateTime(2024, 1, 1): 33.33,
        DateTime(2024, 1, 2): 33.33,
        DateTime(2024, 1, 3): 33.34,
      };
      final previousPeriod = {
        DateTime(2023, 12, 29): 25.0,
        DateTime(2023, 12, 30): 25.0,
        DateTime(2023, 12, 31): 25.0,
      };

      final result = useCase.call(
        currentDailyTotals: currentPeriod,
        previousDailyTotals: previousPeriod,
        label: '비교',
      );

      expect(result.currentValue, closeTo(100.0, 0.01));
      expect(result.comparisonValue, equals(75.0));
    });

    test('should compare categories between periods', () {
      final currentCategories = {'식비': 50000.0, '교통비': 30000.0, '숙박': 20000.0};
      final previousCategories = {'식비': 40000.0, '교통비': 35000.0, '숙박': 25000.0};

      final results = useCase.compareCategories(
        currentCategoryTotals: currentCategories,
        previousCategoryTotals: previousCategories,
      );

      expect(results, hasLength(3));

      // Find food category result
      final foodResult = results.firstWhere((r) => r.label == '식비');
      expect(foodResult.currentValue, equals(50000.0));
      expect(foodResult.comparisonValue, equals(40000.0));
      expect(foodResult.direction, equals(TrendDirection.up));

      // Find transport category - decreased
      final transportResult = results.firstWhere((r) => r.label == '교통비');
      expect(transportResult.direction, equals(TrendDirection.down));
    });

    test('should handle category only in current period', () {
      final currentCategories = {'식비': 50000.0, '오락': 10000.0};
      final previousCategories = {'식비': 40000.0};

      final results = useCase.compareCategories(
        currentCategoryTotals: currentCategories,
        previousCategoryTotals: previousCategories,
      );

      final entertainmentResult = results.firstWhere((r) => r.label == '오락');
      expect(entertainmentResult.comparisonValue, equals(0.0));
      expect(entertainmentResult.direction, equals(TrendDirection.up));
    });

    test('should handle category only in previous period', () {
      final currentCategories = {'식비': 50000.0};
      final previousCategories = {'식비': 40000.0, '오락': 15000.0};

      final results = useCase.compareCategories(
        currentCategoryTotals: currentCategories,
        previousCategoryTotals: previousCategories,
      );

      final entertainmentResult = results.firstWhere((r) => r.label == '오락');
      expect(entertainmentResult.currentValue, equals(0.0));
      expect(entertainmentResult.direction, equals(TrendDirection.down));
    });

    test('should handle percentage change when previous is zero for categories', () {
      final currentCategories = {'식비': 50000.0};
      final previousCategories = {'식비': 0.0};

      final results = useCase.compareCategories(
        currentCategoryTotals: currentCategories,
        previousCategoryTotals: previousCategories,
      );

      expect(results.first.percentageChange, equals(100.0));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/detect_anomalies.dart';

void main() {
  late DetectAnomalies detectAnomalies;

  setUp(() {
    detectAnomalies = DetectAnomalies();
  });

  group('DetectAnomalies', () {
    test('should detect daily spending spike above 2 std deviations', () {
      // Create daily totals where one day is a clear outlier
      // Mean ≈ 114.29, StdDev ≈ 141.5, Threshold ≈ 397.3
      // Day 6 (500.0) is clearly above the threshold
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 110.0,
        DateTime(2024, 1, 3): 90.0,
        DateTime(2024, 1, 4): 105.0,
        DateTime(2024, 1, 5): 95.0,
        DateTime(2024, 1, 6): 500.0, // Spike!
        DateTime(2024, 1, 7): 100.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 500.0, '교통': 600.0},
      );

      expect(result.any((i) => i.type == InsightType.anomaly), isTrue);
      final spike = result.firstWhere(
        (i) => i.type == InsightType.anomaly && i.title.contains('비정상 지출'),
      );
      expect(spike.priority, equals(InsightPriority.high));
      expect(spike.description, contains('1월 6일'));
    });

    test('should detect recent spending increase trend', () {
      // Overall mean = 100, recent 3 days mean = 200
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 60.0,
        DateTime(2024, 1, 3): 70.0,
        DateTime(2024, 1, 4): 80.0,
        DateTime(2024, 1, 5): 200.0,
        DateTime(2024, 1, 6): 200.0,
        DateTime(2024, 1, 7): 200.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 500.0},
      );

      expect(result.any((i) => i.type == InsightType.trend), isTrue);
      final trend = result.firstWhere((i) => i.type == InsightType.trend);
      expect(trend.title, equals('최근 지출 증가'));
      expect(trend.priority, equals(InsightPriority.medium));
    });

    test('should detect budget threshold breach for single day', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 250.0, // 25% of budget
        DateTime(2024, 1, 3): 50.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 400.0},
        totalBudget: 1000.0,
      );

      expect(
        result.any((i) =>
            i.type == InsightType.anomaly && i.title.contains('일일 예산')),
        isTrue,
      );
      final budget = result.firstWhere((i) => i.title.contains('일일 예산'));
      expect(budget.priority, equals(InsightPriority.high));
      expect(budget.description, contains('25.0%'));
    });

    test('should detect category concentration above 50%', () {
      final categoryTotals = {
        '식비': 600.0,
        '교통': 200.0,
        '숙박': 200.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: {DateTime(2024, 1, 1): 1000.0},
        categoryTotals: categoryTotals,
      );

      expect(
        result.any((i) =>
            i.type == InsightType.anomaly && i.title.contains('지출 편중')),
        isTrue,
      );
      final concentration = result.firstWhere((i) => i.title.contains('지출 편중'));
      expect(concentration.description, contains('식비'));
      expect(concentration.priority, equals(InsightPriority.medium));
    });

    test('should return empty list when no anomalies', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 100.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 200.0, '교통': 200.0},
      );

      expect(result, isEmpty);
    });

    test('should return empty list for empty daily data', () {
      final result = detectAnomalies.call(
        dailyTotals: {},
        categoryTotals: {'식비': 100.0},
      );

      expect(result, isEmpty);
    });

    test('should handle single day data', () {
      final dailyTotals = {DateTime(2024, 1, 1): 100.0};

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 100.0},
      );

      // Cannot detect spike with only 1 day (need >= 3)
      expect(result.where((i) => i.title.contains('비정상 지출')), isEmpty);
    });

    test('should handle all zero spending', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 0.0,
        DateTime(2024, 1, 2): 0.0,
        DateTime(2024, 1, 3): 0.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 0.0},
      );

      // Zero stddev means no spike detection
      expect(result, isEmpty);
    });

    test('should handle uniform spending (no anomalies)', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 100.0,
        DateTime(2024, 1, 5): 100.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 250.0, '교통': 250.0},
      );

      // Stddev = 0, no spike; no trend increase; no budget; balanced categories
      expect(result, isEmpty);
    });

    test('should generate unique IDs', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 500.0, // Spike
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 600.0, // Another spike
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 1300.0},
      );

      final ids = result.map((i) => i.id).toSet();
      expect(ids.length, equals(result.length));
    });

    test('should not detect spike when all values are similar', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 99.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 101.0,
        DateTime(2024, 1, 4): 100.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 400.0},
      );

      expect(result.where((i) => i.title.contains('비정상 지출')), isEmpty);
    });

    test('should handle no budget data gracefully', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 1000.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 1000.0},
        totalBudget: null,
      );

      // No budget threshold checks
      expect(result.where((i) => i.title.contains('일일 예산')), isEmpty);
    });

    test('should handle zero budget gracefully', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 100.0},
        totalBudget: 0.0,
      );

      // Zero budget means no threshold checks
      expect(result.where((i) => i.title.contains('일일 예산')), isEmpty);
    });

    test('should include metadata in insights', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 100.0,
        DateTime(2024, 1, 4): 100.0,
        DateTime(2024, 1, 5): 100.0,
        DateTime(2024, 1, 6): 800.0, // Clear spike
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 1300.0},
      );

      final spike = result.firstWhere((i) => i.title.contains('비정상 지출'));
      expect(spike.metadata, isNotNull);
      expect(spike.metadata!['amount'], equals(800.0));
      expect(spike.metadata!.containsKey('mean'), isTrue);
      expect(spike.metadata!.containsKey('threshold'), isTrue);
    });

    test('should detect multiple budget breaches on different days', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 250.0, // 25% of budget
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 300.0, // 30% of budget
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {'식비': 650.0},
        totalBudget: 1000.0,
      );

      final budgetBreaches = result.where((i) => i.title.contains('일일 예산'));
      expect(budgetBreaches.length, equals(2));
    });

    test('should handle empty category totals', () {
      final dailyTotals = <DateTime, double>{
        DateTime(2024, 1, 1): 100.0,
      };

      final result = detectAnomalies.call(
        dailyTotals: dailyTotals,
        categoryTotals: {},
      );

      // No category concentration checks
      expect(result.where((i) => i.title.contains('지출 편중')), isEmpty);
    });
  });
}

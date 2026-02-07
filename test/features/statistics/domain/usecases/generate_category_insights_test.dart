import 'package:flutter_test/flutter_test.dart';

import 'package:trip_wallet/features/statistics/domain/usecases/generate_category_insights.dart';

void main() {
  late GenerateCategoryInsights useCase;

  setUp(() {
    useCase = GenerateCategoryInsights();
  });

  group('GenerateCategoryInsights', () {
    test('should generate insight for single category', () {
      final categoryTotals = {'식비': 100000.0};

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results, hasLength(1));
      expect(results.first.category, equals('식비'));
      expect(results.first.amount, equals(100000.0));
      expect(results.first.percentage, equals(100.0));
      expect(results.first.rank, equals(1));
    });

    test('should rank categories by amount descending', () {
      final categoryTotals = {
        '교통비': 30000.0,
        '식비': 50000.0,
        '숙박': 20000.0,
      };

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results, hasLength(3));
      expect(results[0].category, equals('식비'));
      expect(results[0].rank, equals(1));
      expect(results[1].category, equals('교통비'));
      expect(results[1].rank, equals(2));
      expect(results[2].category, equals('숙박'));
      expect(results[2].rank, equals(3));
    });

    test('should calculate percentage of total correctly', () {
      final categoryTotals = {
        '식비': 50.0,
        '교통비': 30.0,
        '숙박': 20.0,
      };

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results[0].percentage, equals(50.0));
      expect(results[1].percentage, equals(30.0));
      expect(results[2].percentage, equals(20.0));

      final totalPercentage = results.fold(0.0, (sum, r) => sum + r.percentage);
      expect(totalPercentage, closeTo(100.0, 0.01));
    });

    test('should include previous period comparison when provided', () {
      final categoryTotals = {'식비': 50000.0, '교통비': 30000.0};
      final previousTotals = {'식비': 40000.0, '교통비': 35000.0};

      final results = useCase.call(
        categoryTotals: categoryTotals,
        previousCategoryTotals: previousTotals,
      );

      final food = results.firstWhere((r) => r.category == '식비');
      expect(food.previousAmount, equals(40000.0));
      expect(food.changePercentage, equals(25.0));

      final transport = results.firstWhere((r) => r.category == '교통비');
      expect(transport.previousAmount, equals(35000.0));
      expect(transport.changePercentage, closeTo(-14.29, 0.01));
    });

    test('should have null changePercentage when no previous data', () {
      final categoryTotals = {'식비': 50000.0};

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results.first.previousAmount, isNull);
      expect(results.first.changePercentage, isNull);
    });

    test('should return empty list for empty category map', () {
      final results = useCase.call(categoryTotals: {});

      expect(results, isEmpty);
    });

    test('should handle all-zero amounts', () {
      final categoryTotals = {'식비': 0.0, '교통비': 0.0};

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results, hasLength(2));
      for (final result in results) {
        expect(result.percentage, equals(0.0));
      }
    });

    test('should handle 8 expense categories', () {
      final categoryTotals = {
        '식비': 80000.0,
        '교통': 70000.0,
        '숙박': 60000.0,
        '오락': 50000.0,
        '쇼핑': 40000.0,
        '활동': 30000.0,
        '통신': 20000.0,
        '기타': 10000.0,
      };

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results, hasLength(8));
      expect(results.first.category, equals('식비'));
      expect(results.first.rank, equals(1));
      expect(results.last.category, equals('기타'));
      expect(results.last.rank, equals(8));
    });

    test('should handle decimal precision', () {
      final categoryTotals = {
        '식비': 33.33,
        '교통비': 33.33,
        '숙박': 33.34,
      };

      final results = useCase.call(categoryTotals: categoryTotals);

      final totalPercentage = results.fold(0.0, (sum, r) => sum + r.percentage);
      expect(totalPercentage, closeTo(100.0, 0.1));
    });

    test('should handle large values', () {
      final categoryTotals = {
        '숙박': 99999999.99,
        '식비': 88888888.88,
      };

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results.first.category, equals('숙박'));
      expect(results.first.amount, equals(99999999.99));
    });

    test('should handle category in previous but not current', () {
      final categoryTotals = {'식비': 50000.0};
      final previousTotals = {'식비': 40000.0, '오락': 15000.0};

      final results = useCase.call(
        categoryTotals: categoryTotals,
        previousCategoryTotals: previousTotals,
      );

      // Should only contain categories from current period
      expect(results, hasLength(1));
      expect(results.first.category, equals('식비'));
    });

    test('should handle zero previous amount for change calculation', () {
      final categoryTotals = {'식비': 50000.0};
      final previousTotals = {'식비': 0.0};

      final results = useCase.call(
        categoryTotals: categoryTotals,
        previousCategoryTotals: previousTotals,
      );

      expect(results.first.previousAmount, equals(0.0));
      expect(results.first.changePercentage, equals(100.0));
    });

    test('should provide empty topExpenseDescriptions', () {
      final categoryTotals = {'식비': 50000.0};

      final results = useCase.call(categoryTotals: categoryTotals);

      expect(results.first.topExpenseDescriptions, isEmpty);
    });

    test('should include topExpenseDescriptions when provided', () {
      final categoryTotals = {'식비': 50000.0};
      final topExpenses = {
        '식비': ['고급 레스토랑 - 25,000원', '브런치 카페 - 15,000원'],
      };

      final results = useCase.call(
        categoryTotals: categoryTotals,
        topExpenseDescriptions: topExpenses,
      );

      expect(results.first.topExpenseDescriptions, hasLength(2));
      expect(results.first.topExpenseDescriptions.first, contains('고급 레스토랑'));
    });
  });
}

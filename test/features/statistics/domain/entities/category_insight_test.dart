import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/category_insight.dart';

void main() {
  group('CategoryInsight', () {
    test('should create instance with all required fields', () {
      final insight = CategoryInsight(
        category: '식비',
        amount: 150000.0,
        percentage: 35.0,
        rank: 1,
        topExpenseDescriptions: ['점심 식사', '저녁 식사', '카페'],
      );

      expect(insight.category, equals('식비'));
      expect(insight.amount, equals(150000.0));
      expect(insight.percentage, equals(35.0));
      expect(insight.rank, equals(1));
      expect(insight.topExpenseDescriptions, hasLength(3));
    });

    test('should support equality comparison', () {
      final insight1 = CategoryInsight(
        category: '식비',
        amount: 100.0,
        percentage: 50.0,
        rank: 1,
        topExpenseDescriptions: ['항목1'],
      );
      final insight2 = CategoryInsight(
        category: '식비',
        amount: 100.0,
        percentage: 50.0,
        rank: 1,
        topExpenseDescriptions: ['항목1'],
      );
      final insight3 = CategoryInsight(
        category: '교통비',
        amount: 200.0,
        percentage: 30.0,
        rank: 2,
        topExpenseDescriptions: ['택시'],
      );

      expect(insight1, equals(insight2));
      expect(insight1, isNot(equals(insight3)));
    });

    test('should handle optional previousAmount field', () {
      final withPrevious = CategoryInsight(
        category: '식비',
        amount: 150000.0,
        percentage: 35.0,
        rank: 1,
        topExpenseDescriptions: [],
        previousAmount: 120000.0,
      );

      final withoutPrevious = CategoryInsight(
        category: '식비',
        amount: 150000.0,
        percentage: 35.0,
        rank: 1,
        topExpenseDescriptions: [],
      );

      expect(withPrevious.previousAmount, equals(120000.0));
      expect(withoutPrevious.previousAmount, isNull);
    });

    test('should handle optional changePercentage field', () {
      final withChange = CategoryInsight(
        category: '교통비',
        amount: 80000.0,
        percentage: 20.0,
        rank: 2,
        topExpenseDescriptions: [],
        changePercentage: 15.5,
      );

      final withoutChange = CategoryInsight(
        category: '교통비',
        amount: 80000.0,
        percentage: 20.0,
        rank: 2,
        topExpenseDescriptions: [],
      );

      expect(withChange.changePercentage, equals(15.5));
      expect(withoutChange.changePercentage, isNull);
    });

    test('should handle empty topExpenseDescriptions', () {
      final insight = CategoryInsight(
        category: '오락',
        amount: 0.0,
        percentage: 0.0,
        rank: 8,
        topExpenseDescriptions: [],
      );

      expect(insight.topExpenseDescriptions, isEmpty);
    });

    test('should handle rank ordering', () {
      final first = CategoryInsight(
        category: '식비',
        amount: 200.0,
        percentage: 40.0,
        rank: 1,
        topExpenseDescriptions: [],
      );
      final second = CategoryInsight(
        category: '교통비',
        amount: 150.0,
        percentage: 30.0,
        rank: 2,
        topExpenseDescriptions: [],
      );
      final third = CategoryInsight(
        category: '숙박',
        amount: 100.0,
        percentage: 20.0,
        rank: 3,
        topExpenseDescriptions: [],
      );

      expect(first.rank, lessThan(second.rank));
      expect(second.rank, lessThan(third.rank));
      expect(first.amount, greaterThan(second.amount));
    });

    test('should handle all 8 expense categories', () {
      final categories = ['식비', '교통', '숙박', '오락', '쇼핑', '활동', '통신', '기타'];
      final insights = categories.asMap().entries.map((entry) {
        return CategoryInsight(
          category: entry.value,
          amount: (8 - entry.key) * 10000.0,
          percentage: 12.5,
          rank: entry.key + 1,
          topExpenseDescriptions: [],
        );
      }).toList();

      expect(insights, hasLength(8));
      expect(insights.first.rank, equals(1));
      expect(insights.last.rank, equals(8));
    });

    test('should handle percentage summing to 100', () {
      final insights = [
        CategoryInsight(category: '식비', amount: 50.0, percentage: 50.0, rank: 1, topExpenseDescriptions: []),
        CategoryInsight(category: '교통', amount: 30.0, percentage: 30.0, rank: 2, topExpenseDescriptions: []),
        CategoryInsight(category: '숙박', amount: 20.0, percentage: 20.0, rank: 3, topExpenseDescriptions: []),
      ];

      final totalPercentage = insights.fold(0.0, (sum, i) => sum + i.percentage);
      expect(totalPercentage, equals(100.0));
    });

    test('should handle large amounts', () {
      final insight = CategoryInsight(
        category: '숙박',
        amount: 99999999.99,
        percentage: 85.5,
        rank: 1,
        topExpenseDescriptions: ['호텔 10박'],
      );

      expect(insight.amount, equals(99999999.99));
    });

    test('should handle decimal precision', () {
      final insight = CategoryInsight(
        category: '식비',
        amount: 123456.78,
        percentage: 33.33,
        rank: 1,
        topExpenseDescriptions: [],
        previousAmount: 111111.11,
        changePercentage: 11.11,
      );

      expect(insight.amount, equals(123456.78));
      expect(insight.percentage, equals(33.33));
      expect(insight.changePercentage, equals(11.11));
    });

    test('should support copyWith for immutability', () {
      final original = CategoryInsight(
        category: '식비',
        amount: 100.0,
        percentage: 50.0,
        rank: 1,
        topExpenseDescriptions: ['항목1'],
      );

      final updated = original.copyWith(
        amount: 200.0,
        rank: 2,
      );

      expect(updated.amount, equals(200.0));
      expect(updated.rank, equals(2));
      expect(updated.category, equals('식비')); // unchanged
      expect(original.amount, equals(100.0)); // original unchanged
    });

    test('should handle negative changePercentage', () {
      final insight = CategoryInsight(
        category: '쇼핑',
        amount: 30000.0,
        percentage: 15.0,
        rank: 3,
        topExpenseDescriptions: [],
        previousAmount: 50000.0,
        changePercentage: -40.0,
      );

      expect(insight.changePercentage, lessThan(0));
      expect(insight.amount, lessThan(insight.previousAmount!));
    });

    test('should handle multiple topExpenseDescriptions', () {
      final insight = CategoryInsight(
        category: '식비',
        amount: 150000.0,
        percentage: 35.0,
        rank: 1,
        topExpenseDescriptions: [
          '고급 레스토랑 - 45,000원',
          '스시 오마카세 - 38,000원',
          '브런치 카페 - 25,000원',
          '현지 시장 - 22,000원',
          '편의점 - 15,000원',
        ],
      );

      expect(insight.topExpenseDescriptions, hasLength(5));
      expect(insight.topExpenseDescriptions.first, contains('고급 레스토랑'));
    });
  });
}

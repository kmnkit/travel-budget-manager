import 'package:flutter_test/flutter_test.dart' hide ComparisonResult;
import 'package:trip_wallet/features/statistics/domain/entities/comparison_result.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

void main() {
  group('ComparisonResult', () {
    test('should create instance with all required fields', () {
      final result = ComparisonResult(
        label: '이번 주 vs 지난 주',
        currentValue: 150000.0,
        comparisonValue: 120000.0,
        difference: 30000.0,
        percentageChange: 25.0,
        direction: TrendDirection.up,
      );

      expect(result.label, equals('이번 주 vs 지난 주'));
      expect(result.currentValue, equals(150000.0));
      expect(result.comparisonValue, equals(120000.0));
      expect(result.difference, equals(30000.0));
      expect(result.percentageChange, equals(25.0));
      expect(result.direction, equals(TrendDirection.up));
    });

    test('should support equality comparison', () {
      final result1 = ComparisonResult(
        label: '총 지출',
        currentValue: 100.0,
        comparisonValue: 80.0,
        difference: 20.0,
        percentageChange: 25.0,
        direction: TrendDirection.up,
      );
      final result2 = ComparisonResult(
        label: '총 지출',
        currentValue: 100.0,
        comparisonValue: 80.0,
        difference: 20.0,
        percentageChange: 25.0,
        direction: TrendDirection.up,
      );
      final result3 = ComparisonResult(
        label: '총 지출',
        currentValue: 200.0,
        comparisonValue: 80.0,
        difference: 120.0,
        percentageChange: 150.0,
        direction: TrendDirection.up,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('should handle upward direction (spending increased)', () {
      final result = ComparisonResult(
        label: '식비',
        currentValue: 50000.0,
        comparisonValue: 30000.0,
        difference: 20000.0,
        percentageChange: 66.7,
        direction: TrendDirection.up,
      );

      expect(result.direction, equals(TrendDirection.up));
      expect(result.percentageChange, greaterThan(0));
      expect(result.difference, greaterThan(0));
    });

    test('should handle downward direction (spending decreased)', () {
      final result = ComparisonResult(
        label: '교통비',
        currentValue: 20000.0,
        comparisonValue: 40000.0,
        difference: -20000.0,
        percentageChange: -50.0,
        direction: TrendDirection.down,
      );

      expect(result.direction, equals(TrendDirection.down));
      expect(result.percentageChange, lessThan(0));
      expect(result.difference, lessThan(0));
    });

    test('should handle stable direction (minimal change)', () {
      final result = ComparisonResult(
        label: '숙박비',
        currentValue: 100000.0,
        comparisonValue: 98000.0,
        difference: 2000.0,
        percentageChange: 2.04,
        direction: TrendDirection.stable,
      );

      expect(result.direction, equals(TrendDirection.stable));
      expect(result.percentageChange.abs(), lessThan(5.0));
    });

    test('should handle zero values', () {
      final result = ComparisonResult(
        label: '오락비',
        currentValue: 0.0,
        comparisonValue: 0.0,
        difference: 0.0,
        percentageChange: 0.0,
        direction: TrendDirection.stable,
      );

      expect(result.currentValue, equals(0.0));
      expect(result.comparisonValue, equals(0.0));
      expect(result.difference, equals(0.0));
    });

    test('should handle negative difference when current is less', () {
      final result = ComparisonResult(
        label: '쇼핑',
        currentValue: 30000.0,
        comparisonValue: 50000.0,
        difference: -20000.0,
        percentageChange: -40.0,
        direction: TrendDirection.down,
      );

      expect(result.difference, lessThan(0));
      expect(result.currentValue, lessThan(result.comparisonValue));
    });

    test('should handle large values without overflow', () {
      final result = ComparisonResult(
        label: '총 지출',
        currentValue: 99999999.99,
        comparisonValue: 88888888.88,
        difference: 11111111.11,
        percentageChange: 12.5,
        direction: TrendDirection.up,
      );

      expect(result.currentValue, equals(99999999.99));
      expect(result.comparisonValue, equals(88888888.88));
    });

    test('should handle decimal precision', () {
      final result = ComparisonResult(
        label: '식비',
        currentValue: 123.45,
        comparisonValue: 67.89,
        difference: 55.56,
        percentageChange: 81.84,
        direction: TrendDirection.up,
      );

      expect(result.currentValue, equals(123.45));
      expect(result.comparisonValue, equals(67.89));
    });

    test('should support copyWith for immutability', () {
      final original = ComparisonResult(
        label: '원본',
        currentValue: 100.0,
        comparisonValue: 80.0,
        difference: 20.0,
        percentageChange: 25.0,
        direction: TrendDirection.up,
      );

      final updated = original.copyWith(
        label: '수정됨',
        percentageChange: 30.0,
      );

      expect(updated.label, equals('수정됨'));
      expect(updated.percentageChange, equals(30.0));
      expect(updated.currentValue, equals(100.0)); // unchanged
      expect(original.label, equals('원본')); // original unchanged
    });

    test('should handle comparison where previous period had zero spending',
        () {
      final result = ComparisonResult(
        label: '통신비',
        currentValue: 15000.0,
        comparisonValue: 0.0,
        difference: 15000.0,
        percentageChange: 100.0,
        direction: TrendDirection.up,
      );

      expect(result.comparisonValue, equals(0.0));
      expect(result.currentValue, greaterThan(0));
    });

    test('should handle comparison where current period has zero spending', () {
      final result = ComparisonResult(
        label: '활동비',
        currentValue: 0.0,
        comparisonValue: 25000.0,
        difference: -25000.0,
        percentageChange: -100.0,
        direction: TrendDirection.down,
      );

      expect(result.currentValue, equals(0.0));
      expect(result.comparisonValue, greaterThan(0));
    });
  });
}

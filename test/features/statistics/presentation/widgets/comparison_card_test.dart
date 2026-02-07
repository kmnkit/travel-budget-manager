import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide ComparisonResult;
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/comparison_result.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/comparison_card.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  group('ComparisonCard', () {
    testWidgets('should render with valid comparison data',
        (WidgetTester tester) async {
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

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      expect(find.text('기간 비교'), findsOneWidget);
      expect(find.text('총 지출'), findsOneWidget);
    });

    testWidgets(
        'should show percentage change with up arrow for increased spending',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 200000.0,
          comparisonValue: 100000.0,
          difference: 100000.0,
          percentageChange: 100.0,
          direction: TrendDirection.up,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.textContaining('100.0%'), findsOneWidget);
    });

    testWidgets('should show down arrow for decreased spending',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 80000.0,
          comparisonValue: 120000.0,
          difference: -40000.0,
          percentageChange: -33.3,
          direction: TrendDirection.down,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });

    testWidgets('should show flat icon for stable spending',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 100000.0,
          comparisonValue: 98000.0,
          difference: 2000.0,
          percentageChange: 2.0,
          direction: TrendDirection.stable,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      expect(find.byIcon(Icons.trending_flat), findsOneWidget);
    });

    testWidgets('should use green color for decreased spending (savings)',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 50000.0,
          comparisonValue: 100000.0,
          difference: -50000.0,
          percentageChange: -50.0,
          direction: TrendDirection.down,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_down));
      expect(icon.color, equals(Colors.green));
    });

    testWidgets('should use red color for increased spending',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
          label: '총 지출',
          currentValue: 200000.0,
          comparisonValue: 100000.0,
          difference: 100000.0,
          percentageChange: 100.0,
          direction: TrendDirection.up,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_up));
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('should display multiple comparison rows',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
            label: '식비',
            currentValue: 50000.0,
            comparisonValue: 40000.0,
            difference: 10000.0,
            percentageChange: 25.0,
            direction: TrendDirection.up),
        ComparisonResult(
            label: '교통비',
            currentValue: 20000.0,
            comparisonValue: 30000.0,
            difference: -10000.0,
            percentageChange: -33.3,
            direction: TrendDirection.down),
        ComparisonResult(
            label: '숙박',
            currentValue: 80000.0,
            comparisonValue: 78000.0,
            difference: 2000.0,
            percentageChange: 2.6,
            direction: TrendDirection.stable),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      expect(find.text('식비'), findsOneWidget);
      expect(find.text('교통비'), findsOneWidget);
      expect(find.text('숙박'), findsOneWidget);
    });

    testWidgets('should handle empty comparisons list',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: [],
          currencyCode: 'KRW',
        ),
      ));

      expect(find.text('기간 비교'), findsOneWidget);
      expect(find.text('비교할 데이터가 없습니다'), findsOneWidget);
    });

    testWidgets('should display period label when provided',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
            label: '총 지출',
            currentValue: 100.0,
            comparisonValue: 80.0,
            difference: 20.0,
            percentageChange: 25.0,
            direction: TrendDirection.up),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'USD',
          periodLabel: '이번 주 vs 지난 주',
        ),
      ));

      expect(find.text('이번 주 vs 지난 주'), findsOneWidget);
    });

    testWidgets(
        'should format currency correctly for different currency codes',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
            label: '총 지출',
            currentValue: 1234.56,
            comparisonValue: 1000.0,
            difference: 234.56,
            percentageChange: 23.5,
            direction: TrendDirection.up),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'USD',
        ),
      ));

      // Should render without error
      expect(find.text('총 지출'), findsOneWidget);
    });

    testWidgets('should have proper card styling',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
            label: '총 지출',
            currentValue: 100.0,
            comparisonValue: 80.0,
            difference: 20.0,
            percentageChange: 25.0,
            direction: TrendDirection.up),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(2.0));
      expect(card.margin, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should handle zero current and comparison values',
        (WidgetTester tester) async {
      final comparisons = [
        ComparisonResult(
            label: '총 지출',
            currentValue: 0.0,
            comparisonValue: 0.0,
            difference: 0.0,
            percentageChange: 0.0,
            direction: TrendDirection.stable),
      ];

      await tester.pumpWidget(buildTestWidget(
        ComparisonCard(
          comparisons: comparisons,
          currencyCode: 'KRW',
        ),
      ));

      expect(find.byIcon(Icons.trending_flat), findsOneWidget);
    });
  });
}

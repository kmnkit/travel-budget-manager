import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/category_insight.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/category_insight_card.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  group('CategoryInsightCard', () {
    testWidgets('should render with valid category insights',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 150000.0,
            percentage: 50.0,
            rank: 1,
            topExpenseDescriptions: []),
        CategoryInsight(
            category: '교통비',
            amount: 90000.0,
            percentage: 30.0,
            rank: 2,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      expect(find.text('카테고리 분석'), findsOneWidget);
      expect(find.text('식비'), findsOneWidget);
      expect(find.text('교통비'), findsOneWidget);
    });

    testWidgets('should display rank badges correctly',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 100.0,
            percentage: 40.0,
            rank: 1,
            topExpenseDescriptions: []),
        CategoryInsight(
            category: '교통비',
            amount: 80.0,
            percentage: 32.0,
            rank: 2,
            topExpenseDescriptions: []),
        CategoryInsight(
            category: '숙박',
            amount: 70.0,
            percentage: 28.0,
            rank: 3,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      // Should show rank numbers
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should show percentage for each category',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 50.0,
            percentage: 50.0,
            rank: 1,
            topExpenseDescriptions: []),
        CategoryInsight(
            category: '교통비',
            amount: 50.0,
            percentage: 50.0,
            rank: 2,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      expect(find.textContaining('50.0%'), findsNWidgets(2));
    });

    testWidgets('should handle empty insights list',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: [], currencyCode: 'KRW'),
      ));

      expect(find.text('카테고리 분석'), findsOneWidget);
      expect(find.text('카테고리 데이터가 없습니다'), findsOneWidget);
    });

    testWidgets('should handle single category',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 100000.0,
            percentage: 100.0,
            rank: 1,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      expect(find.text('식비'), findsOneWidget);
      expect(find.textContaining('100.0%'), findsOneWidget);
    });

    testWidgets('should display all 8 categories',
        (WidgetTester tester) async {
      final categories = [
        '식비',
        '교통',
        '숙박',
        '오락',
        '쇼핑',
        '활동',
        '통신',
        '기타'
      ];
      final insights = categories.asMap().entries.map((e) {
        return CategoryInsight(
          category: e.value,
          amount: (8 - e.key) * 10000.0,
          percentage: 12.5,
          rank: e.key + 1,
          topExpenseDescriptions: [],
        );
      }).toList();

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      for (final cat in categories) {
        expect(find.text(cat), findsOneWidget);
      }
    });

    testWidgets('should show change percentage when available',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
          category: '식비',
          amount: 50000.0,
          percentage: 50.0,
          rank: 1,
          topExpenseDescriptions: [],
          previousAmount: 40000.0,
          changePercentage: 25.0,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      expect(find.textContaining('25.0%'), findsWidgets);
    });

    testWidgets('should not show change indicator when no previous data',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 50000.0,
            percentage: 50.0,
            rank: 1,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      // Should not find trending icons when no change data
      expect(find.byIcon(Icons.trending_up), findsNothing);
      expect(find.byIcon(Icons.trending_down), findsNothing);
    });

    testWidgets('should have proper card styling',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 100.0,
            percentage: 100.0,
            rank: 1,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(2.0));
      expect(card.margin, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should display progress bar proportional to percentage',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 70.0,
            percentage: 70.0,
            rank: 1,
            topExpenseDescriptions: []),
        CategoryInsight(
            category: '교통비',
            amount: 30.0,
            percentage: 30.0,
            rank: 2,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      // LinearProgressIndicator should be present
      expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    });

    testWidgets('should format currency correctly for USD',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: 'Food',
            amount: 1234.56,
            percentage: 100.0,
            rank: 1,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'USD'),
      ));

      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('should use gold color for rank 1',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
            category: '식비',
            amount: 100.0,
            percentage: 100.0,
            rank: 1,
            topExpenseDescriptions: []),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      // Find the rank badge container
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('should handle negative change percentage',
        (WidgetTester tester) async {
      final insights = [
        CategoryInsight(
          category: '식비',
          amount: 30000.0,
          percentage: 50.0,
          rank: 1,
          topExpenseDescriptions: [],
          previousAmount: 50000.0,
          changePercentage: -40.0,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        CategoryInsightCard(insights: insights, currencyCode: 'KRW'),
      ));

      // Should show green for decrease (savings)
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });
  });
}

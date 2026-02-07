import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/domain/usecases/generate_insights.dart';

void main() {
  late GenerateInsights generateInsights;

  setUp(() {
    generateInsights = GenerateInsights();
  });

  group('GenerateInsights', () {
    test('should generate category dominance insight when category > 40%', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 500.0, '교통': 200.0, '숙박': 100.0, '오락': 200.0},
        totalAmount: 1000.0,
      );

      final spendingInsights = insights.where((i) => i.type == InsightType.spending).toList();
      expect(spendingInsights.any((i) => i.priority == InsightPriority.high), isTrue);

      final highPriorityInsight = spendingInsights.firstWhere((i) => i.priority == InsightPriority.high);
      expect(highPriorityInsight.title, contains('식비'));
      expect(highPriorityInsight.title, contains('비중 높음'));
      expect(highPriorityInsight.metadata?['category'], equals('식비'));
      expect(highPriorityInsight.metadata?['percentage'], equals(50.0));
    });

    test('should generate medium priority insight when category 25-40%', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 300.0, '교통': 200.0, '숙박': 500.0},
        totalAmount: 1000.0,
      );

      final spendingInsights = insights.where((i) => i.type == InsightType.spending).toList();
      final mediumInsight = spendingInsights.firstWhere(
        (i) => i.priority == InsightPriority.medium && i.metadata?['category'] == '식비',
      );

      expect(mediumInsight.title, contains('식비'));
      expect(mediumInsight.title, contains('주의'));
      expect(mediumInsight.metadata?['percentage'], equals(30.0));
    });

    test('should generate budget on track insight', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 300.0},
        totalAmount: 300.0,
        totalBudget: 1000.0,
        budgetRemaining: 700.0,
        dailyAverage: 50.0,
        dailyBudgetRemaining: 100.0,
      );

      final budgetInsights = insights.where((i) => i.type == InsightType.budget).toList();
      expect(budgetInsights.any((i) => i.title.contains('관리 양호')), isTrue);

      final onTrackInsight = budgetInsights.firstWhere((i) => i.title.contains('관리 양호'));
      expect(onTrackInsight.priority, equals(InsightPriority.low));
    });

    test('should generate budget warning when > 75% used', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 800.0},
        totalAmount: 800.0,
        totalBudget: 1000.0,
        budgetRemaining: 200.0,
      );

      final budgetInsights = insights.where((i) => i.type == InsightType.budget).toList();
      final warningInsight = budgetInsights.firstWhere((i) => i.title.contains('주의'));

      expect(warningInsight.priority, equals(InsightPriority.high));
      expect(warningInsight.description, contains('80.0%'));
      expect(warningInsight.metadata?['percentUsed'], equals(80.0));
    });

    test('should generate budget exceeded insight', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 1200.0},
        totalAmount: 1200.0,
        totalBudget: 1000.0,
        budgetRemaining: -200.0,
      );

      final budgetInsights = insights.where((i) => i.type == InsightType.budget).toList();
      final exceededInsight = budgetInsights.firstWhere((i) => i.title.contains('초과'));

      expect(exceededInsight.priority, equals(InsightPriority.high));
      expect(exceededInsight.description, contains('200원'));
      expect(exceededInsight.metadata?['budgetRemaining'], equals(-200.0));
    });

    test('should generate daily budget recommendation', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 300.0},
        totalAmount: 300.0,
        totalBudget: 1000.0,
        budgetRemaining: 700.0,
        daysRemaining: 7,
      );

      final recommendations = insights.where((i) => i.type == InsightType.recommendation).toList();
      final dailyBudgetRec = recommendations.firstWhere((i) => i.title.contains('일일 예산'));

      expect(dailyBudgetRec.priority, equals(InsightPriority.medium));
      expect(dailyBudgetRec.description, contains('7일'));
      expect(dailyBudgetRec.description, contains('100원'));
      expect(dailyBudgetRec.metadata?['daysRemaining'], equals(7));
      expect(dailyBudgetRec.metadata?['dailyBudget'], equals(100.0));
    });

    test('should generate top category recommendation when > 30%', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 400.0, '교통': 300.0, '숙박': 300.0},
        totalAmount: 1000.0,
      );

      final recommendations = insights.where((i) => i.type == InsightType.recommendation).toList();
      final categoryRec = recommendations.firstWhere((i) => i.title.contains('절약'));

      expect(categoryRec.title, contains('식비'));
      expect(categoryRec.description, contains('줄이는 것'));
      expect(categoryRec.metadata?['category'], equals('식비'));
      expect(categoryRec.metadata?['percentage'], equals(40.0));
    });

    test('should return empty list for empty category data', () {
      final insights = generateInsights.call(
        categoryTotals: {},
        totalAmount: 0.0,
      );

      expect(insights, isEmpty);
    });

    test('should handle no budget data gracefully', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 500.0},
        totalAmount: 500.0,
      );

      final budgetInsights = insights.where((i) => i.type == InsightType.budget).toList();
      expect(budgetInsights, isEmpty);
    });

    test('should order insights by priority', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 500.0, '교통': 300.0, '숙박': 200.0},
        totalAmount: 1000.0,
        totalBudget: 1000.0,
        budgetRemaining: 0.0,
        daysRemaining: 5,
      );

      expect(insights.isNotEmpty, isTrue);

      // High priority should come before medium and low
      for (int i = 0; i < insights.length - 1; i++) {
        expect(
          insights[i].priority.index <= insights[i + 1].priority.index,
          isTrue,
          reason: 'Insights should be sorted by priority (high first)',
        );
      }
    });

    test('should generate unique IDs for each insight', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 500.0, '교통': 300.0},
        totalAmount: 800.0,
        totalBudget: 1000.0,
        budgetRemaining: 200.0,
        daysRemaining: 5,
      );

      final ids = insights.map((i) => i.id).toSet();
      expect(ids.length, equals(insights.length), reason: 'All IDs should be unique');

      for (final insight in insights) {
        expect(insight.id, startsWith('insight_'));
      }
    });

    test('should set generatedAt to current time', () {
      final beforeCall = DateTime.now();

      final insights = generateInsights.call(
        categoryTotals: {'식비': 500.0},
        totalAmount: 500.0,
      );

      final afterCall = DateTime.now();

      expect(insights.isNotEmpty, isTrue);
      for (final insight in insights) {
        expect(insight.generatedAt.isAfter(beforeCall.subtract(const Duration(seconds: 1))), isTrue);
        expect(insight.generatedAt.isBefore(afterCall.add(const Duration(seconds: 1))), isTrue);
      }
    });

    test('should handle single category', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 1000.0},
        totalAmount: 1000.0,
      );

      final spendingInsights = insights.where((i) => i.type == InsightType.spending).toList();
      expect(spendingInsights.isNotEmpty, isTrue);

      final insight = spendingInsights.first;
      expect(insight.metadata?['percentage'], equals(100.0));
    });

    test('should handle all equal categories', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 250.0, '교통': 250.0, '숙박': 250.0, '오락': 250.0},
        totalAmount: 1000.0,
      );

      final spendingInsights = insights.where((i) => i.type == InsightType.spending).toList();

      // No category should have >40%, so no high priority
      expect(spendingInsights.any((i) => i.priority == InsightPriority.high), isFalse);

      // All should be 25%, so all should have medium priority
      expect(spendingInsights.where((i) => i.priority == InsightPriority.medium).length, equals(4));
    });

    test('should not generate daily budget when no days remaining', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 300.0},
        totalAmount: 300.0,
        totalBudget: 1000.0,
        budgetRemaining: 700.0,
        daysRemaining: 0,
      );

      final recommendations = insights.where((i) => i.type == InsightType.recommendation).toList();
      expect(recommendations.any((i) => i.title.contains('일일 예산')), isFalse);
    });

    test('should not generate daily budget when budget is exhausted', () {
      final insights = generateInsights.call(
        categoryTotals: {'식비': 1000.0},
        totalAmount: 1000.0,
        totalBudget: 1000.0,
        budgetRemaining: 0.0,
        daysRemaining: 5,
      );

      final recommendations = insights.where((i) => i.type == InsightType.recommendation).toList();
      expect(recommendations.any((i) => i.title.contains('일일 예산')), isFalse);
    });
  });
}

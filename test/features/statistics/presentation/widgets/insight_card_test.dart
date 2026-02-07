import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/insight_card.dart';

void main() {
  group('InsightCard', () {
    // Helper to wrap widget in MaterialApp
    Widget buildTestWidget(List<AnalyticsInsight> insights) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: InsightCard(insights: insights),
          ),
        ),
      );
    }

    // Helper to create test insight
    AnalyticsInsight createInsight({
      InsightType type = InsightType.spending,
      InsightPriority priority = InsightPriority.medium,
      String title = '테스트 인사이트',
      String description = '테스트 설명입니다',
    }) {
      return AnalyticsInsight(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        title: title,
        description: description,
        priority: priority,
        generatedAt: DateTime.now(),
      );
    }

    testWidgets('should display title "스마트 인사이트"', (tester) async {
      // Arrange
      final insights = [createInsight()];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.text('스마트 인사이트'), findsOneWidget);
    });

    testWidgets('should display single insight', (tester) async {
      // Arrange
      final insights = [
        createInsight(
          title: '높은 지출 패턴',
          description: '이번 주 지출이 평소보다 높습니다',
        ),
      ];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.text('높은 지출 패턴'), findsOneWidget);
      expect(find.text('이번 주 지출이 평소보다 높습니다'), findsOneWidget);
    });

    testWidgets('should display multiple insights', (tester) async {
      // Arrange
      final insights = [
        createInsight(
          title: '첫 번째 인사이트',
          description: '첫 번째 설명',
        ),
        createInsight(
          title: '두 번째 인사이트',
          description: '두 번째 설명',
        ),
        createInsight(
          title: '세 번째 인사이트',
          description: '세 번째 설명',
        ),
      ];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.text('첫 번째 인사이트'), findsOneWidget);
      expect(find.text('두 번째 인사이트'), findsOneWidget);
      expect(find.text('세 번째 인사이트'), findsOneWidget);
    });

    testWidgets('should show correct icon for spending type', (tester) async {
      // Arrange
      final insights = [createInsight(type: InsightType.spending)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('should show correct icon for budget type', (tester) async {
      // Arrange
      final insights = [createInsight(type: InsightType.budget)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('should show correct icon for trend type', (tester) async {
      // Arrange
      final insights = [createInsight(type: InsightType.trend)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('should show correct icon for anomaly type', (tester) async {
      // Arrange
      final insights = [createInsight(type: InsightType.anomaly)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('should show correct icon for recommendation type',
        (tester) async {
      // Arrange
      final insights = [createInsight(type: InsightType.recommendation)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });

    testWidgets('should show red color for high priority', (tester) async {
      // Arrange
      final insights = [createInsight(priority: InsightPriority.high)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      final iconFinder = find.byIcon(Icons.attach_money);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('should show amber color for medium priority', (tester) async {
      // Arrange
      final insights = [createInsight(priority: InsightPriority.medium)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      final iconFinder = find.byIcon(Icons.attach_money);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, equals(Colors.amber.shade700));
    });

    testWidgets('should show teal color for low priority', (tester) async {
      // Arrange
      final insights = [createInsight(priority: InsightPriority.low)];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      final iconFinder = find.byIcon(Icons.attach_money);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, equals(Colors.teal));
    });

    testWidgets('should return SizedBox.shrink for empty insights',
        (tester) async {
      // Arrange
      final insights = <AnalyticsInsight>[];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.text('스마트 인사이트'), findsNothing);
    });

    testWidgets('should have proper card styling', (tester) async {
      // Arrange
      final insights = [createInsight()];

      // Act
      await tester.pumpWidget(buildTestWidget(insights));

      // Assert
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.margin, equals(const EdgeInsets.all(16)));
      expect(card.elevation, equals(2));
      expect(card.shape, isA<RoundedRectangleBorder>());

      final shape = card.shape as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        equals(BorderRadius.circular(12)),
      );
    });
  });
}

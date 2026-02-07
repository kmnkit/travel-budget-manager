import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/budget_burndown_chart.dart';

void main() {
  group('BudgetBurndownChart Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      );
    }

    BudgetForecast createForecast({
      List<DataPoint>? historical,
      List<DataPoint>? projected,
      List<DataPoint>? budgetLine,
    }) {
      return BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 300.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 6,
        daysRemaining: 8,
        daysUntilExhaustion: 14,
        status: ForecastStatus.onTrack,
        historicalSpending: historical ?? [
          DataPoint(date: DateTime(2024, 1, 1), value: 50.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 3), value: 150.0),
          DataPoint(date: DateTime(2024, 1, 4), value: 200.0),
          DataPoint(date: DateTime(2024, 1, 5), value: 250.0),
          DataPoint(date: DateTime(2024, 1, 6), value: 300.0),
        ],
        projectedSpending: projected ?? [
          DataPoint(date: DateTime(2024, 1, 7), value: 350.0),
          DataPoint(date: DateTime(2024, 1, 8), value: 400.0),
          DataPoint(date: DateTime(2024, 1, 9), value: 450.0),
          DataPoint(date: DateTime(2024, 1, 10), value: 500.0),
        ],
        budgetLine: budgetLine ?? [
          DataPoint(date: DateTime(2024, 1, 1), value: 1000.0),
          DataPoint(date: DateTime(2024, 1, 14), value: 1000.0),
        ],
        confidenceInterval: ConfidenceInterval(
          bestCase: 600.0,
          worstCase: 800.0,
          confidenceLevel: 0.68,
        ),
      );
    }

    testWidgets('should display chart card with title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('예산 소진 차트'), findsOneWidget);
    });

    testWidgets('should render LineChart widget', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('should return SizedBox.shrink when no historical data', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(historical: []),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should have proper card styling', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(),
            currencyCode: 'USD',
          ),
        ),
      );

      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.margin, equals(const EdgeInsets.all(16)));
      expect(card.shape, isA<RoundedRectangleBorder>());
      expect(card.elevation, equals(2));
    });

    testWidgets('should handle forecast with no projected data', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(projected: []),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('should display with KRW currency', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(),
            currencyCode: 'KRW',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('예산 소진 차트'), findsOneWidget);
    });

    testWidgets('should handle large dataset without overflow', (tester) async {
      final largeHistorical = List.generate(
        30,
        (i) => DataPoint(
          date: DateTime(2024, 1, 1).add(Duration(days: i)),
          value: (i + 1) * 50.0,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(historical: largeHistorical),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('should display legend items', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: createForecast(),
            currencyCode: 'USD',
          ),
        ),
      );

      // Should show legend for historical, projected, and budget lines
      expect(find.text('실제 지출'), findsOneWidget);
      expect(find.text('예측'), findsOneWidget);
      expect(find.text('예산 한도'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/budget_forecast_card.dart';

void main() {
  group('BudgetForecastCard Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      );
    }

    BudgetForecast createForecast({
      ForecastStatus status = ForecastStatus.onTrack,
      double totalBudget = 1000.0,
      double totalSpent = 400.0,
      double dailySpendingRate = 50.0,
      double projectedTotalSpend = 700.0,
      int daysUntilExhaustion = 12,
      bool nullExhaustion = false,
    }) {
      return BudgetForecast(
        tripId: 1,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        dailySpendingRate: dailySpendingRate,
        projectedTotalSpend: projectedTotalSpend,
        daysElapsed: 8,
        daysRemaining: 6,
        daysUntilExhaustion: nullExhaustion ? null : daysUntilExhaustion,
        status: status,
        historicalSpending: [],
        projectedSpending: [],
        budgetLine: [],
        confidenceInterval: ConfidenceInterval(
          bestCase: 600.0,
          worstCase: 800.0,
          confidenceLevel: 0.68,
        ),
      );
    }

    testWidgets('should display card with title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('예산 예측'), findsOneWidget);
    });

    testWidgets('should display projected total spend', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(projectedTotalSpend: 700.0),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.textContaining('\$'), findsWidgets);
    });

    testWidgets('should display daily spending rate', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(dailySpendingRate: 50.0),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.textContaining('일일 지출'), findsOneWidget);
    });

    testWidgets('should display days until exhaustion', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(daysUntilExhaustion: 12),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.textContaining('12'), findsWidgets);
    });

    testWidgets('should display budget sufficient when exhaustion is null', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(nullExhaustion: true),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.text('예산 충분'), findsOneWidget);
    });

    testWidgets('should show green indicator for onTrack status', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(status: ForecastStatus.onTrack),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should show amber indicator for atRisk status', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(status: ForecastStatus.atRisk),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('should show red indicator for overBudget status', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(status: ForecastStatus.overBudget),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should show dark red indicator for exhausted status', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(status: ForecastStatus.exhausted),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byIcon(Icons.dangerous), findsOneWidget);
    });

    testWidgets('should display with KRW currency', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(
              totalBudget: 1000000.0,
              dailySpendingRate: 100000.0,
              projectedTotalSpend: 700000.0,
            ),
            currencyCode: 'KRW',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('예산 예측'), findsOneWidget);
    });

    testWidgets('should have proper card styling', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
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

    testWidgets('should handle zero values gracefully', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          BudgetForecastCard(
            forecast: createForecast(
              totalBudget: 0.0,
              totalSpent: 0.0,
              dailySpendingRate: 0.0,
              projectedTotalSpend: 0.0,
              nullExhaustion: true,
            ),
            currencyCode: 'USD',
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });
  });
}

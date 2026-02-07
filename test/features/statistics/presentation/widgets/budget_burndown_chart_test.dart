import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
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

    testWidgets('should render confidence band when interval differs', (tester) async {
      final forecast = createForecast();

      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: forecast,
            currencyCode: 'USD',
          ),
        ),
      );

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      final lineData = lineChart.data;

      // Should have 5 line bars: historical, projected, budget, best-case, worst-case
      expect(lineData.lineBarsData.length, equals(5));

      // Should have one BetweenBarsData for confidence band
      expect(lineData.betweenBarsData.length, equals(1));

      final bandData = lineData.betweenBarsData.first;
      expect(bandData.fromIndex, equals(3)); // best-case line
      expect(bandData.toIndex, equals(4)); // worst-case line
    });

    testWidgets('should not render confidence band when bestCase equals worstCase', (tester) async {
      final forecast = BudgetForecast(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 300.0,
        dailySpendingRate: 50.0,
        projectedTotalSpend: 700.0,
        daysElapsed: 6,
        daysRemaining: 8,
        daysUntilExhaustion: 14,
        status: ForecastStatus.onTrack,
        historicalSpending: [
          DataPoint(date: DateTime(2024, 1, 1), value: 50.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 3), value: 150.0),
        ],
        projectedSpending: [
          DataPoint(date: DateTime(2024, 1, 4), value: 200.0),
          DataPoint(date: DateTime(2024, 1, 5), value: 250.0),
        ],
        budgetLine: [
          DataPoint(date: DateTime(2024, 1, 1), value: 1000.0),
          DataPoint(date: DateTime(2024, 1, 14), value: 1000.0),
        ],
        confidenceInterval: const ConfidenceInterval(
          bestCase: 700.0,
          worstCase: 700.0, // Same as best case
          confidenceLevel: 0.68,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: forecast,
            currencyCode: 'USD',
          ),
        ),
      );

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      final lineData = lineChart.data;

      // Should only have 3 line bars (no confidence lines)
      expect(lineData.lineBarsData.length, equals(3));

      // Should have empty betweenBarsData
      expect(lineData.betweenBarsData, isEmpty);
    });

    testWidgets('should render confidence band with correct color', (tester) async {
      final forecast = createForecast();

      await tester.pumpWidget(
        createTestWidget(
          BudgetBurndownChart(
            forecast: forecast,
            currencyCode: 'USD',
          ),
        ),
      );

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      final lineData = lineChart.data;

      expect(lineData.betweenBarsData.length, equals(1));

      final bandData = lineData.betweenBarsData.first;
      final bandColor = bandData.color;

      // Should be semi-transparent blue
      expect(bandColor, isNotNull);
      expect((bandColor!.a * 255.0).round(), lessThan(100)); // Semi-transparent
      expect((bandColor.b * 255.0).round(), greaterThan(200)); // Predominantly blue
    });
  });
}

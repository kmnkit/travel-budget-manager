import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/trend_indicator.dart';

void main() {
  group('TrendIndicator Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('should display upward trend indicator', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 150.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 50.0,
        confidence: 0.85,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.textContaining('50.0%'), findsOneWidget);
    });

    testWidgets('should display downward trend indicator', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 150.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
        ],
        projectedData: null,
        direction: TrendDirection.down,
        changePercentage: -33.3,
        confidence: 0.80,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
      expect(find.textContaining('33.3%'), findsOneWidget); // Shows absolute value
    });

    testWidgets('should display stable trend indicator', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 101.0),
        ],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 1.0,
        confidence: 0.95,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.byIcon(Icons.trending_flat), findsOneWidget);
      expect(find.textContaining('1.0%'), findsOneWidget);
    });

    testWidgets('should display confidence level', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.85,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      // Confidence should be displayed as percentage (85%)
      expect(find.textContaining('85%'), findsOneWidget);
    });

    testWidgets('should use green color for upward trend', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.80,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_up));
      expect(icon.color, equals(Colors.green));
    });

    testWidgets('should use red color for downward trend', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 120.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
        ],
        projectedData: null,
        direction: TrendDirection.down,
        changePercentage: -16.7,
        confidence: 0.75,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_down));
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('should use grey color for stable trend', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
        ],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.0,
        confidence: 1.0,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_flat));
      expect(icon.color, equals(Colors.grey));
    });

    testWidgets('should handle high confidence (>0.8)', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.95,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.textContaining('95%'), findsOneWidget);
    });

    testWidgets('should handle low confidence (<0.5)', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 110.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 10.0,
        confidence: 0.35,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.textContaining('35%'), findsOneWidget);
    });

    testWidgets('should display large percentage changes', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 250.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 150.0,
        confidence: 0.80,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.textContaining('150.0%'), findsOneWidget);
    });

    testWidgets('should display small percentage changes', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.5),
        ],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.5,
        confidence: 0.90,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.textContaining('0.5%'), findsOneWidget);
    });

    testWidgets('should be compact and fit in a row', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 120.0),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 20.0,
        confidence: 0.85,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          Row(
            children: [
              const Text('Trend:'),
              TrendIndicator(trendData: trendData),
            ],
          ),
        ),
      );

      // Assert - Should render without overflow
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.text('Trend:'), findsOneWidget);
    });

    testWidgets('should handle zero change percentage', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 100.0),
        ],
        projectedData: null,
        direction: TrendDirection.stable,
        changePercentage: 0.0,
        confidence: 1.0,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      expect(find.textContaining('0.0%'), findsOneWidget);
    });

    testWidgets('should format decimal percentages correctly', (tester) async {
      // Arrange
      final trendData = TrendData(
        historicalData: [
          DataPoint(date: DateTime(2024, 1, 1), value: 100.0),
          DataPoint(date: DateTime(2024, 1, 2), value: 123.45),
        ],
        projectedData: null,
        direction: TrendDirection.up,
        changePercentage: 23.45,
        confidence: 0.87,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TrendIndicator(trendData: trendData),
        ),
      );

      // Assert
      expect(find.byType(TrendIndicator), findsOneWidget);
      // Should display with 1 decimal place (Dart uses banker's rounding: 23.45 → 23.4)
      expect(find.textContaining('23.4%'), findsOneWidget);
    });
  });
}

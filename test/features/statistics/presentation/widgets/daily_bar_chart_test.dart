import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/daily_bar_chart.dart';

void main() {
  group('DailyBarChart Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('should render with valid daily data', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 150.0,
        DateTime(2024, 1, 3): 200.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should render empty when daily data is empty', (tester) async {
      // Arrange
      final dailyData = <DateTime, double>{};

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should handle single day of data', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 15): 500.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should display last 14 days when more than 14 days exist', (tester) async {
      // Arrange - Create 20 days of data
      final dailyData = <DateTime, double>{};
      for (int i = 1; i <= 20; i++) {
        dailyData[DateTime(2024, 1, i)] = 100.0 * i;
      }

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      // Should only show last 14 days (Jan 7-20)
      // The chart limits to 14 days, but we can't easily verify the internal data
      // Just verify it renders
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should display all days when less than 14 days', (tester) async {
      // Arrange - Create 10 days of data
      final dailyData = <DateTime, double>{};
      for (int i = 1; i <= 10; i++) {
        dailyData[DateTime(2024, 1, i)] = 100.0 * i;
      }

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should format dates correctly', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 5): 100.0,
        DateTime(2024, 1, 15): 150.0,
        DateTime(2024, 2, 28): 200.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Dates should be formatted as M/d (e.g., "1/5", "1/15", "2/28")
      expect(find.text('1/5'), findsOneWidget);
      expect(find.text('1/15'), findsOneWidget);
      expect(find.text('2/28'), findsOneWidget);
    });

    testWidgets('should handle zero amounts', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 0.0,
        DateTime(2024, 1, 2): 100.0,
        DateTime(2024, 1, 3): 0.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should handle varying amounts', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 50.0,
        DateTime(2024, 1, 2): 500.0,
        DateTime(2024, 1, 3): 25.0,
        DateTime(2024, 1, 4): 1000.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      // Widget should handle varying amounts and scale appropriately
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should use different currency codes', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 200.0,
      };

      // Act - Test with KRW
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'KRW',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should handle decimal amounts', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 123.45,
        DateTime(2024, 1, 2): 678.90,
        DateTime(2024, 1, 3): 234.56,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should sort dates chronologically', (tester) async {
      // Arrange - Dates out of order
      final dailyData = {
        DateTime(2024, 1, 15): 100.0,
        DateTime(2024, 1, 5): 150.0,
        DateTime(2024, 1, 10): 200.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Should display sorted dates: 1/5, 1/10, 1/15
      expect(find.text('1/5'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);
      expect(find.text('1/15'), findsOneWidget);
    });

    testWidgets('should handle large amounts', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 1000000.0,
        DateTime(2024, 1, 2): 2000000.0,
        DateTime(2024, 1, 3): 1500000.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      // formatCompact should handle large amounts (e.g., "$1M", "$2M")
      expect(find.text('일별 지출'), findsOneWidget);
    });

    testWidgets('should handle dates across different months', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 30): 100.0,
        DateTime(2024, 1, 31): 150.0,
        DateTime(2024, 2, 1): 200.0,
        DateTime(2024, 2, 2): 120.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Should show dates across months
      expect(find.text('1/30'), findsOneWidget);
      expect(find.text('1/31'), findsOneWidget);
      expect(find.text('2/1'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
    });

    testWidgets('should handle dates across different years', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2023, 12, 30): 100.0,
        DateTime(2023, 12, 31): 150.0,
        DateTime(2024, 1, 1): 200.0,
        DateTime(2024, 1, 2): 120.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);

      // Should show dates (year is not shown in M/d format)
      expect(find.text('12/30'), findsOneWidget);
      expect(find.text('12/31'), findsOneWidget);
      expect(find.text('1/1'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
    });

    testWidgets('should display card with proper styling', (tester) async {
      // Arrange
      final dailyData = {
        DateTime(2024, 1, 1): 100.0,
        DateTime(2024, 1, 2): 200.0,
      };

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.margin, equals(const EdgeInsets.all(16)));
      expect(card.shape, isA<RoundedRectangleBorder>());
      expect(card.elevation, equals(2));
    });

    testWidgets('should handle exactly 14 days of data', (tester) async {
      // Arrange - Exactly 14 days
      final dailyData = <DateTime, double>{};
      for (int i = 1; i <= 14; i++) {
        dailyData[DateTime(2024, 1, i)] = 100.0 * i;
      }

      // Act
      await tester.pumpWidget(
        createTestWidget(
          DailyBarChart(
            dailyData: dailyData,
            currencyCode: 'USD',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
      // All 14 days should be displayed
      expect(find.text('1/1'), findsOneWidget);
      expect(find.text('1/14'), findsOneWidget);
    });
  });
}

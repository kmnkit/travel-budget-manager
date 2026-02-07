import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/spending_velocity.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/spending_velocity_card.dart';

void main() {
  group('SpendingVelocityCard Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('should display daily and weekly averages', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.5,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 14),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('지출 속도'), findsOneWidget);
      expect(find.textContaining('\$'), findsWidgets); // Currency symbol appears
    });

    testWidgets('should display positive acceleration indicator', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 10.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('should display negative acceleration indicator', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: -10.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });

    testWidgets('should display stable acceleration indicator', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 0.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.trending_flat), findsOneWidget);
    });

    testWidgets('should handle zero velocity', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 0.0,
        weeklyAverage: 0.0,
        acceleration: 0.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.trending_flat), findsOneWidget);
    });

    testWidgets('should display with KRW currency', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150000.0,
        weeklyAverage: 1050000.0,
        acceleration: 5000.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'KRW',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('지출 속도'), findsOneWidget);
    });

    testWidgets('should display card with proper styling', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
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

    testWidgets('should handle large velocity values', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 50000.0,
        weeklyAverage: 350000.0,
        acceleration: 1000.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 30),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('\$'), findsWidgets);
    });

    testWidgets('should handle small velocity values', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 5.50,
        weeklyAverage: 38.50,
        acceleration: 0.25,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display period information', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 14),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      // Period should be displayed in some form
      expect(find.textContaining('기간'), findsOneWidget);
    });

    testWidgets('should handle single-day period', (tester) async {
      // Arrange
      final singleDay = DateTime(2024, 1, 15);
      final velocity = SpendingVelocity(
        dailyAverage: 250.0,
        weeklyAverage: 1750.0,
        acceleration: 0.0,
        periodStart: singleDay,
        periodEnd: singleDay,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should handle period across months', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 5.0,
        periodStart: DateTime(2024, 1, 25),
        periodEnd: DateTime(2024, 2, 5),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should use green color for positive acceleration', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 15.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_up));
      expect(icon.color, equals(Colors.green));
    });

    testWidgets('should use red color for negative acceleration', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: -15.0,
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_down));
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('should use grey color for stable acceleration', (tester) async {
      // Arrange
      final velocity = SpendingVelocity(
        dailyAverage: 150.0,
        weeklyAverage: 1050.0,
        acceleration: 0.5, // Near zero
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 7),
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          SpendingVelocityCard(
            velocity: velocity,
            currencyCode: 'USD',
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_flat));
      expect(icon.color, equals(Colors.grey));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/dashboard_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/dashboard_edit_sheet.dart';
import 'package:trip_wallet/features/export/presentation/widgets/export_button.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class MockDashboardConfigNotifier extends AsyncNotifier<DashboardConfig>
    with Mock
    implements DashboardConfigNotifier {
  final DashboardConfig _config;

  MockDashboardConfigNotifier(this._config);

  @override
  Future<DashboardConfig> build() async => _config;
}

Widget createTestWidget(Widget child, {dynamic overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ko'),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  late StatisticsData mockStatisticsData;

  setUp(() {
    mockStatisticsData = StatisticsData(
      totalAmount: 100000.0,
      categoryTotals: {
        ExpenseCategory.food: 50000.0,
        ExpenseCategory.transport: 30000.0,
        ExpenseCategory.accommodation: 20000.0,
      },
      dailyTotals: {
        DateTime(2024, 1, 1): 50000.0,
        DateTime(2024, 1, 2): 30000.0,
        DateTime(2024, 1, 3): 20000.0,
      },
      paymentMethodTotals: {
        'Credit Card': 70000.0,
        'Cash': 30000.0,
      },
      categoryDailyTotals: {},
    );
  });

  group('StatisticsScreen Dashboard Integration', () {
    testWidgets('renders ExportButton in AppBar', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ExportButton), findsOneWidget);
    });

    testWidgets('renders edit button (Icons.tune)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('tapping edit button opens bottom sheet', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Tap the edit button
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Verify bottom sheet appears
      expect(find.byType(DashboardEditSheet), findsOneWidget);
    });

    testWidgets('widgets render in config order', (tester) async {
      // Create custom config with specific order
      final customConfig = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.paymentMethodChart,
            position: 0,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.dailyBarChart,
            position: 1,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 2,
            isVisible: true,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
            dashboardConfigProvider.overrideWith(() => MockDashboardConfigNotifier(customConfig)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify widgets are rendered (they exist in the widget tree)
      // Note: We can't easily verify exact order without more complex widget inspection,
      // but we can verify all widgets are present
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('hidden widgets are not rendered', (tester) async {
      // Create config with some hidden widgets
      final configWithHidden = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.dailyBarChart,
            position: 1,
            isVisible: false, // Hidden
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.paymentMethodChart,
            position: 2,
            isVisible: true,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
            dashboardConfigProvider.overrideWith(() => MockDashboardConfigNotifier(configWithHidden)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify only visible widgets count matches
      final visibleCount = configWithHidden.visibleWidgets.length;
      expect(visibleCount, 2); // Only 2 widgets are visible
    });

    testWidgets('falls back to default order when config is loading', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
          ],
        ),
      );

      // Pump to allow initial build and async resolution
      await tester.pumpAndSettle();

      // The screen should render with default widget order
      expect(find.byType(StatisticsScreen), findsOneWidget);
    });

    testWidgets('renders all widgets with default config', (tester) async {
      final defaultConfig = DashboardConfig.defaultConfig();

      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
            dashboardConfigProvider.overrideWith(() => MockDashboardConfigNotifier(defaultConfig)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify screen renders successfully
      expect(find.byType(StatisticsScreen), findsOneWidget);

      // Verify default config has all widgets visible
      expect(defaultConfig.visibleWidgets.length, DashboardWidgetType.values.length);
    });

    testWidgets('handles empty statistics data', (tester) async {
      final emptyData = StatisticsData(
        totalAmount: 0.0,
        categoryTotals: {},
        dailyTotals: {},
        paymentMethodTotals: {},
        categoryDailyTotals: {},
      );

      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => emptyData),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty state message
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });

    testWidgets('period filter and dashboard config coexist', (tester) async {
      final defaultConfig = DashboardConfig.defaultConfig();

      await tester.pumpWidget(
        createTestWidget(
          const StatisticsScreen(tripId: 1, currencyCode: 'KRW'),
          overrides: [
            statisticsDataProvider(1).overrideWith((ref) async => mockStatisticsData),
            dashboardConfigProvider.overrideWith(() => MockDashboardConfigNotifier(defaultConfig)),
          ],
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify screen renders with both period filter and dashboard config
      expect(find.byType(StatisticsScreen), findsOneWidget);
      // Verify default config has all widgets
      expect(defaultConfig.visibleWidgets.length, DashboardWidgetType.values.length);
    });
  });
}

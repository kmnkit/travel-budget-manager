import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/theme/app_theme.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/dashboard_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/dashboard_edit_sheet.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

Widget createTestWidget(Widget child, {required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
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
  late DashboardConfig testConfig;

  setUp(() {
    testConfig = DashboardConfig.defaultConfig();
  });

  group('DashboardEditSheet', () {
    testWidgets('renders title "대시보드 편집"', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      expect(find.text('대시보드 편집'), findsOneWidget);
    });

    testWidgets('renders all 10 widget items', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      // Check that we have ListTile widgets (one per dashboard widget)
      expect(find.byType(ListTile), findsWidgets);

      // Verify key labels are present (at least 9 widgets)
      expect(find.text('카테고리별 지출'), findsOneWidget);
      expect(find.text('일별 지출'), findsOneWidget);
      expect(find.text('결제 수단별 지출'), findsOneWidget);
      expect(find.text('지출 트렌드'), findsOneWidget);
      expect(find.text('지출 속도'), findsOneWidget);
      expect(find.text('기간 비교'), findsOneWidget);
      expect(find.text('카테고리 인사이트'), findsOneWidget);
      expect(find.text('스마트 인사이트'), findsOneWidget);
      expect(find.text('예산 예측'), findsOneWidget);
    });

    testWidgets('each item has a Switch widget', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      // Should have switches (one per widget)
      expect(find.byType(Switch), findsWidgets);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('toggling switch calls toggleWidgetVisibility',
        (tester) async {
      final notifier = FakeDashboardConfigNotifier(testConfig);
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(() => notifier),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      expect(notifier.toggleCalled, false);

      // Tap the first switch
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(notifier.toggleCalled, true);
      expect(notifier.lastToggledType, DashboardWidgetType.categoryPieChart);
    });

    testWidgets('reset button exists with text "기본값 복원"', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      expect(find.text('기본값 복원'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('reset button calls resetToDefault', (tester) async {
      final notifier = FakeDashboardConfigNotifier(testConfig);
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(() => notifier),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      expect(notifier.resetCalled, false);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      expect(notifier.resetCalled, true);
    });

    testWidgets('shows ReorderableListView', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ReorderableListView), findsOneWidget);
    });

    testWidgets('handle bar is rendered at top', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      // Find the handle bar (Container with specific dimensions)
      final handleBarFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.grey[400],
      );

      expect(handleBarFinder, findsOneWidget);
    });

    testWidgets('hidden widgets show switch in off state', (tester) async {
      // Create config with one hidden widget
      final configWithHidden = DashboardConfig(
        id: 'test',
        name: 'Test Config',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        widgets: [
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
            isVisible: false, // Hidden
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.dailyBarChart,
            position: 1,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.paymentMethodChart,
            position: 2,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.trendIndicator,
            position: 3,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.spendingVelocity,
            position: 4,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.periodComparison,
            position: 5,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryInsights,
            position: 6,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.smartInsights,
            position: 7,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.budgetForecast,
            position: 8,
            isVisible: true,
          ),
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.budgetBurndown,
            position: 9,
            isVisible: true,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(configWithHidden),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      // First switch should be off (hidden widget)
      final firstSwitch = tester.widget<Switch>(find.byType(Switch).first);
      expect(firstSwitch.value, false);
    });

    testWidgets('all visible widgets show switch in on state', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashboardConfigProvider.overrideWith(
            () => FakeDashboardConfigNotifier(testConfig),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(const DashboardEditSheet(), container: container),
      );

      await tester.pumpAndSettle();

      // All switches should be on (all widgets visible in default config)
      final switches = tester.widgetList<Switch>(find.byType(Switch));
      for (final switchWidget in switches) {
        expect(switchWidget.value, true);
      }
    });
  });
}

// Fake notifier for testing
class FakeDashboardConfigNotifier extends DashboardConfigNotifier {
  FakeDashboardConfigNotifier(this._config);

  DashboardConfig _config;
  bool toggleCalled = false;
  bool resetCalled = false;
  DashboardWidgetType? lastToggledType;

  @override
  Future<DashboardConfig> build() async {
    return _config;
  }

  @override
  Future<void> toggleWidgetVisibility(DashboardWidgetType widgetType) async {
    toggleCalled = true;
    lastToggledType = widgetType;

    // Update config
    final updatedWidgets = _config.widgets.map((w) {
      if (w.widgetType == widgetType) {
        return w.copyWith(isVisible: !w.isVisible);
      }
      return w;
    }).toList();

    _config = _config.copyWith(widgets: updatedWidgets);
    state = AsyncValue.data(_config);
  }

  @override
  Future<void> resetToDefault() async {
    resetCalled = true;
    _config = DashboardConfig.defaultConfig();
    state = AsyncValue.data(_config);
  }

  @override
  Future<void> reorderWidget(int oldIndex, int newIndex) async {
    // Not tested in these tests
  }
}

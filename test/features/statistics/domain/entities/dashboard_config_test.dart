import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';

void main() {
  group('DashboardWidgetType', () {
    test('should have 10 widget types', () {
      expect(DashboardWidgetType.values.length, 10);
    });

    test('should contain all expected types', () {
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.categoryPieChart));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.dailyBarChart));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.paymentMethodChart));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.trendIndicator));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.spendingVelocity));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.periodComparison));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.categoryInsights));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.smartInsights));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.budgetForecast));
      expect(DashboardWidgetType.values,
          contains(DashboardWidgetType.budgetBurndown));
    });
  });

  group('DashboardWidgetConfig', () {
    test('should create with required fields', () {
      final config = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.categoryPieChart,
        position: 0,
      );
      expect(config.widgetType, DashboardWidgetType.categoryPieChart);
      expect(config.position, 0);
      expect(config.isVisible, true); // default
    });

    test('should support isVisible override', () {
      final config = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.dailyBarChart,
        position: 1,
        isVisible: false,
      );
      expect(config.isVisible, false);
    });

    test('should support copyWith', () {
      final original = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.categoryPieChart,
        position: 0,
      );
      final copied = original.copyWith(isVisible: false);
      expect(copied.isVisible, false);
      expect(copied.position, 0);
      expect(copied.widgetType, DashboardWidgetType.categoryPieChart);
    });

    test('should support JSON serialization', () {
      final config = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.categoryPieChart,
        position: 0,
      );
      final json = config.toJson();
      final restored = DashboardWidgetConfig.fromJson(json);
      expect(restored, config);
    });

    test('should implement equality', () {
      final a = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.categoryPieChart,
        position: 0,
      );
      final b = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.categoryPieChart,
        position: 0,
      );
      expect(a, b);
    });

    test('should not equal different configs', () {
      final a = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.categoryPieChart,
        position: 0,
      );
      final b = DashboardWidgetConfig(
        widgetType: DashboardWidgetType.dailyBarChart,
        position: 0,
      );
      expect(a, isNot(b));
    });
  });

  group('DashboardConfig', () {
    test('should create with required fields', () {
      final now = DateTime.now();
      final config = DashboardConfig(
        id: 'test',
        name: 'Test Config',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
      expect(config.id, 'test');
      expect(config.name, 'Test Config');
      expect(config.widgets.length, 1);
      expect(config.createdAt, now);
      expect(config.updatedAt, now);
    });

    test('defaultConfig should have all widget types', () {
      final config = DashboardConfig.defaultConfig();
      expect(config.widgets.length, DashboardWidgetType.values.length);

      for (final widgetType in DashboardWidgetType.values) {
        expect(
          config.widgets.any((w) => w.widgetType == widgetType),
          true,
          reason: 'Should contain $widgetType',
        );
      }
    });

    test('defaultConfig should have all widgets visible', () {
      final config = DashboardConfig.defaultConfig();
      expect(config.widgets.every((w) => w.isVisible), true);
    });

    test('defaultConfig should have correct positions', () {
      final config = DashboardConfig.defaultConfig();

      for (int i = 0; i < config.widgets.length; i++) {
        expect(config.widgets[i].position, i);
      }
    });

    test('defaultConfig should have default id and name', () {
      final config = DashboardConfig.defaultConfig();
      expect(config.id, 'default');
      expect(config.name, 'Default');
    });

    test('visibleWidgets should filter hidden widgets', () {
      final now = DateTime.now();
      final config = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
            isVisible: true,
          ),
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.dailyBarChart,
            position: 1,
            isVisible: false,
          ),
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.paymentMethodChart,
            position: 2,
            isVisible: true,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final visible = config.visibleWidgets;
      expect(visible.length, 2);
      expect(visible.any((w) => w.widgetType == DashboardWidgetType.dailyBarChart), false);
    });

    test('visibleWidgets should be sorted by position', () {
      final now = DateTime.now();
      final config = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 2,
            isVisible: true,
          ),
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.dailyBarChart,
            position: 0,
            isVisible: true,
          ),
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.paymentMethodChart,
            position: 1,
            isVisible: true,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final visible = config.visibleWidgets;
      expect(visible[0].position, 0);
      expect(visible[1].position, 1);
      expect(visible[2].position, 2);
      expect(visible[0].widgetType, DashboardWidgetType.dailyBarChart);
      expect(visible[1].widgetType, DashboardWidgetType.paymentMethodChart);
      expect(visible[2].widgetType, DashboardWidgetType.categoryPieChart);
    });

    test('should support JSON serialization roundtrip', () {
      final now = DateTime.now();
      final config = DashboardConfig(
        id: 'test',
        name: 'Test Config',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
          ),
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.dailyBarChart,
            position: 1,
            isVisible: false,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final json = config.toJson();
      final restored = DashboardConfig.fromJson(json);
      expect(restored, config);
    });

    test('should support copyWith for updating widgets', () {
      final now = DateTime.now();
      final original = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final newWidgets = [
        DashboardWidgetConfig(
          widgetType: DashboardWidgetType.dailyBarChart,
          position: 0,
        ),
      ];

      final updated = original.copyWith(widgets: newWidgets);
      expect(updated.widgets.length, 1);
      expect(updated.widgets[0].widgetType, DashboardWidgetType.dailyBarChart);
      expect(updated.id, 'test'); // unchanged
    });

    test('should implement equality', () {
      final now = DateTime.now();
      final a = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
      final b = DashboardConfig(
        id: 'test',
        name: 'Test',
        widgets: [
          DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
      expect(a, b);
    });
  });
}

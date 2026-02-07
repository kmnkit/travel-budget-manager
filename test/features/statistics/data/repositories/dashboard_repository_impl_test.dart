import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/statistics/data/repositories/dashboard_repository_impl.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late DashboardRepositoryImpl repository;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = DashboardRepositoryImpl(mockPrefs);
  });

  group('DashboardRepositoryImpl', () {
    group('loadDashboardConfig', () {
      test('returns default config when no saved config', () async {
        // Arrange
        when(() => mockPrefs.getString('dashboard_config')).thenReturn(null);

        // Act
        final result = await repository.loadDashboardConfig();

        // Assert
        expect(result.id, equals('default'));
        expect(result.name, equals('Default'));
        expect(result.widgets.length, equals(10)); // All 10 widget types
        expect(result.widgets.every((w) => w.isVisible), isTrue);
        verify(() => mockPrefs.getString('dashboard_config')).called(1);
      });

      test('returns default config when saved JSON is invalid', () async {
        // Arrange
        when(() => mockPrefs.getString('dashboard_config'))
            .thenReturn('invalid json');

        // Act
        final result = await repository.loadDashboardConfig();

        // Assert
        expect(result.id, equals('default'));
        expect(result.name, equals('Default'));
        expect(result.widgets.length, equals(10)); // All 10 widget types
        expect(result.widgets.every((w) => w.isVisible), isTrue);
        verify(() => mockPrefs.getString('dashboard_config')).called(1);
      });

      test('returns saved config when valid JSON exists', () async {
        // Arrange
        final savedConfig = DashboardConfig(
          id: 'test-id',
          name: 'My Dashboard',
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
          ],
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 2),
        );
        final jsonString = jsonEncode(savedConfig.toJson());
        when(() => mockPrefs.getString('dashboard_config'))
            .thenReturn(jsonString);

        // Act
        final result = await repository.loadDashboardConfig();

        // Assert
        expect(result.id, equals('test-id'));
        expect(result.name, equals('My Dashboard'));
        expect(result.widgets.length, equals(2));
        expect(result.widgets[0].widgetType, equals(DashboardWidgetType.categoryPieChart));
        expect(result.widgets[0].position, equals(0));
        expect(result.widgets[0].isVisible, isTrue);
        expect(result.widgets[1].widgetType, equals(DashboardWidgetType.dailyBarChart));
        expect(result.widgets[1].position, equals(1));
        expect(result.widgets[1].isVisible, isFalse);
        verify(() => mockPrefs.getString('dashboard_config')).called(1);
      });

      test('preserves widget order from saved config', () async {
        // Arrange
        final savedConfig = DashboardConfig(
          id: 'order-test',
          name: 'Order Test',
          widgets: [
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.paymentMethodChart,
              position: 2,
              isVisible: true,
            ),
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.categoryPieChart,
              position: 0,
              isVisible: true,
            ),
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.dailyBarChart,
              position: 1,
              isVisible: true,
            ),
          ],
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final jsonString = jsonEncode(savedConfig.toJson());
        when(() => mockPrefs.getString('dashboard_config'))
            .thenReturn(jsonString);

        // Act
        final result = await repository.loadDashboardConfig();

        // Assert
        expect(result.widgets[0].position, equals(2));
        expect(result.widgets[1].position, equals(0));
        expect(result.widgets[2].position, equals(1));
        expect(result.widgets[0].widgetType, equals(DashboardWidgetType.paymentMethodChart));
        expect(result.widgets[1].widgetType, equals(DashboardWidgetType.categoryPieChart));
        expect(result.widgets[2].widgetType, equals(DashboardWidgetType.dailyBarChart));
      });

      test('preserves visibility settings from saved config', () async {
        // Arrange
        final savedConfig = DashboardConfig(
          id: 'visibility-test',
          name: 'Visibility Test',
          widgets: [
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.categoryPieChart,
              position: 0,
              isVisible: false,
            ),
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.dailyBarChart,
              position: 1,
              isVisible: true,
            ),
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.paymentMethodChart,
              position: 2,
              isVisible: false,
            ),
          ],
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final jsonString = jsonEncode(savedConfig.toJson());
        when(() => mockPrefs.getString('dashboard_config'))
            .thenReturn(jsonString);

        // Act
        final result = await repository.loadDashboardConfig();

        // Assert
        expect(result.widgets[0].isVisible, isFalse);
        expect(result.widgets[1].isVisible, isTrue);
        expect(result.widgets[2].isVisible, isFalse);
      });
    });

    group('saveDashboardConfig', () {
      test('serializes config to JSON string', () async {
        // Arrange
        final config = DashboardConfig(
          id: 'save-test',
          name: 'Save Test',
          widgets: [
            DashboardWidgetConfig(
              widgetType: DashboardWidgetType.categoryPieChart,
              position: 0,
              isVisible: true,
            ),
          ],
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        when(() => mockPrefs.setString(any(), any()))
            .thenAnswer((_) async => true);

        // Act
        await repository.saveDashboardConfig(config);

        // Assert
        final captured = verify(
          () => mockPrefs.setString('dashboard_config', captureAny()),
        ).captured;
        expect(captured.length, equals(1));
        final savedJson = jsonDecode(captured[0] as String);
        expect(savedJson['id'], equals('save-test'));
        expect(savedJson['name'], equals('Save Test'));
        expect(savedJson['widgets'], isA<List>());
        expect(savedJson['widgets'].length, equals(1));
      });

      test('overwrites existing config', () async {
        // Arrange
        final config1 = DashboardConfig(
          id: 'config-1',
          name: 'Config 1',
          widgets: [],
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        final config2 = DashboardConfig(
          id: 'config-2',
          name: 'Config 2',
          widgets: [],
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        );
        when(() => mockPrefs.setString(any(), any()))
            .thenAnswer((_) async => true);

        // Act
        await repository.saveDashboardConfig(config1);
        await repository.saveDashboardConfig(config2);

        // Assert
        final captured = verify(
          () => mockPrefs.setString('dashboard_config', captureAny()),
        ).captured;
        expect(captured.length, equals(2));
        final lastSaved = jsonDecode(captured[1] as String);
        expect(lastSaved['id'], equals('config-2'));
        expect(lastSaved['name'], equals('Config 2'));
      });
    });

    group('resetToDefault', () {
      test('removes the saved config key', () async {
        // Arrange
        when(() => mockPrefs.remove('dashboard_config'))
            .thenAnswer((_) async => true);

        // Act
        await repository.resetToDefault();

        // Assert
        verify(() => mockPrefs.remove('dashboard_config')).called(1);
      });
    });
  });
}

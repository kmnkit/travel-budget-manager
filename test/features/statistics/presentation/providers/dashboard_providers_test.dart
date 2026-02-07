import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/dashboard_providers.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('dashboardEditModeProvider', () {
    test('initial value is false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(dashboardEditModeProvider), false);
    });

    test('toggle switches state from false to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(dashboardEditModeProvider), false);
      container.read(dashboardEditModeProvider.notifier).toggle();
      expect(container.read(dashboardEditModeProvider), true);
    });

    test('toggle switches state from true to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(dashboardEditModeProvider.notifier).toggle();
      expect(container.read(dashboardEditModeProvider), true);
      container.read(dashboardEditModeProvider.notifier).toggle();
      expect(container.read(dashboardEditModeProvider), false);
    });

    test('enable sets state to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(dashboardEditModeProvider), false);
      container.read(dashboardEditModeProvider.notifier).enable();
      expect(container.read(dashboardEditModeProvider), true);
    });

    test('disable sets state to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(dashboardEditModeProvider.notifier).enable();
      expect(container.read(dashboardEditModeProvider), true);
      container.read(dashboardEditModeProvider.notifier).disable();
      expect(container.read(dashboardEditModeProvider), false);
    });
  });

  group('dashboardConfigProvider', () {
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
    });

    test('loads default config when no saved config', () async {
      when(() => mockPrefs.getString('dashboard_config')).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      // Listen first for async provider
      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final config = container.read(dashboardConfigProvider).value;
      expect(config, isNotNull);
      expect(config!.widgets.length, DashboardWidgetType.values.length);
      expect(config.id, 'default');
      expect(config.name, 'Default');
      expect(config.widgets.every((w) => w.isVisible), true);
    });

    test('loads saved config from SharedPreferences', () async {
      final savedConfig = DashboardConfig.defaultConfig();
      final jsonString = jsonEncode(savedConfig.toJson());
      when(() => mockPrefs.getString('dashboard_config')).thenReturn(jsonString);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final config = container.read(dashboardConfigProvider).value;
      expect(config, isNotNull);
      expect(config!.id, savedConfig.id);
      expect(config.widgets.length, savedConfig.widgets.length);
    });

    test('reorderWidget swaps positions correctly', () async {
      when(() => mockPrefs.getString('dashboard_config')).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final initialConfig = container.read(dashboardConfigProvider).value!;
      final firstWidget = initialConfig.visibleWidgets[0];
      final secondWidget = initialConfig.visibleWidgets[1];

      await container.read(dashboardConfigProvider.notifier).reorderWidget(0, 1);

      final updatedConfig = container.read(dashboardConfigProvider).value!;
      final updatedFirstPos = updatedConfig.widgets
          .firstWhere((w) => w.widgetType == firstWidget.widgetType)
          .position;
      final updatedSecondPos = updatedConfig.widgets
          .firstWhere((w) => w.widgetType == secondWidget.widgetType)
          .position;

      expect(updatedFirstPos, secondWidget.position);
      expect(updatedSecondPos, firstWidget.position);
      verify(() => mockPrefs.setString('dashboard_config', any())).called(1);
    });

    test('reorderWidget handles invalid indices gracefully', () async {
      when(() => mockPrefs.getString('dashboard_config')).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final initialConfig = container.read(dashboardConfigProvider).value!;

      // Try invalid indices
      await container.read(dashboardConfigProvider.notifier).reorderWidget(-1, 1);
      await container.read(dashboardConfigProvider.notifier).reorderWidget(0, 100);

      final finalConfig = container.read(dashboardConfigProvider).value!;
      expect(finalConfig.widgets, initialConfig.widgets);
      verifyNever(() => mockPrefs.setString('dashboard_config', any()));
    });

    test('toggleWidgetVisibility toggles widget visibility', () async {
      when(() => mockPrefs.getString('dashboard_config')).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final initialConfig = container.read(dashboardConfigProvider).value!;
      final targetWidget = initialConfig.widgets.first;
      final initialVisibility = targetWidget.isVisible;

      await container
          .read(dashboardConfigProvider.notifier)
          .toggleWidgetVisibility(targetWidget.widgetType);

      final updatedConfig = container.read(dashboardConfigProvider).value!;
      final updatedWidget = updatedConfig.widgets
          .firstWhere((w) => w.widgetType == targetWidget.widgetType);

      expect(updatedWidget.isVisible, !initialVisibility);
      verify(() => mockPrefs.setString('dashboard_config', any())).called(1);
    });

    test('toggleWidgetVisibility updates timestamp', () async {
      when(() => mockPrefs.getString('dashboard_config')).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final initialConfig = container.read(dashboardConfigProvider).value!;
      final targetWidget = initialConfig.widgets.first;

      // Wait a bit to ensure timestamp difference
      await Future.delayed(const Duration(milliseconds: 10));

      await container
          .read(dashboardConfigProvider.notifier)
          .toggleWidgetVisibility(targetWidget.widgetType);

      final updatedConfig = container.read(dashboardConfigProvider).value!;
      expect(updatedConfig.updatedAt.isAfter(initialConfig.updatedAt), true);
    });

    test('resetToDefault restores default config', () async {
      // Start with a modified config
      final modifiedConfig = DashboardConfig.defaultConfig().copyWith(
        widgets: [
          const DashboardWidgetConfig(
            widgetType: DashboardWidgetType.categoryPieChart,
            position: 0,
            isVisible: false, // Hidden
          ),
          ...DashboardConfig.defaultConfig().widgets.skip(1),
        ],
      );
      final jsonString = jsonEncode(modifiedConfig.toJson());

      when(() => mockPrefs.getString('dashboard_config')).thenReturn(jsonString);
      when(() => mockPrefs.remove('dashboard_config')).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      container.listen(dashboardConfigProvider, (_, _) {});
      await container.read(dashboardConfigProvider.future);

      final initialConfig = container.read(dashboardConfigProvider).value!;
      expect(initialConfig.widgets.first.isVisible, false);

      await container.read(dashboardConfigProvider.notifier).resetToDefault();

      final resetConfig = container.read(dashboardConfigProvider).value!;
      expect(resetConfig.id, 'default');
      expect(resetConfig.widgets.every((w) => w.isVisible), true);
      verify(() => mockPrefs.remove('dashboard_config')).called(1);
    });
  });
}

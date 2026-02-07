import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/statistics/data/repositories/dashboard_repository_impl.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';
import 'package:trip_wallet/features/statistics/domain/repositories/dashboard_repository.dart';

/// Repository provider for dashboard persistence
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DashboardRepositoryImpl(prefs);
});

/// Provider that manages dashboard configuration state
/// Supports: load, save, reorder widgets, toggle visibility, reset to default
class DashboardConfigNotifier extends AsyncNotifier<DashboardConfig> {
  @override
  Future<DashboardConfig> build() async {
    final repo = ref.watch(dashboardRepositoryProvider);
    return repo.loadDashboardConfig();
  }

  /// Reorder a widget from oldIndex to newIndex
  Future<void> reorderWidget(int oldIndex, int newIndex) async {
    if (!state.hasValue) return;
    final current = state.value!;

    final widgets = List<DashboardWidgetConfig>.from(current.widgets);
    // Get visible widgets sorted by position
    final visibleWidgets = current.visibleWidgets;
    if (oldIndex < 0 || oldIndex >= visibleWidgets.length) return;
    if (newIndex < 0 || newIndex >= visibleWidgets.length) return;

    final movedWidget = visibleWidgets[oldIndex];
    final targetWidget = visibleWidgets[newIndex];

    // Swap positions
    final movedIdx =
        widgets.indexWhere((w) => w.widgetType == movedWidget.widgetType);
    final targetIdx =
        widgets.indexWhere((w) => w.widgetType == targetWidget.widgetType);

    if (movedIdx != -1 && targetIdx != -1) {
      widgets[movedIdx] =
          widgets[movedIdx].copyWith(position: targetWidget.position);
      widgets[targetIdx] =
          widgets[targetIdx].copyWith(position: movedWidget.position);
    }

    final updated = current.copyWith(
      widgets: widgets,
      updatedAt: DateTime.now(),
    );

    state = AsyncData(updated);
    final repo = ref.read(dashboardRepositoryProvider);
    await repo.saveDashboardConfig(updated);
  }

  /// Toggle visibility of a widget type
  Future<void> toggleWidgetVisibility(DashboardWidgetType widgetType) async {
    if (!state.hasValue) return;
    final current = state.value!;

    final widgets = current.widgets.map((w) {
      if (w.widgetType == widgetType) {
        return w.copyWith(isVisible: !w.isVisible);
      }
      return w;
    }).toList();

    final updated = current.copyWith(
      widgets: widgets,
      updatedAt: DateTime.now(),
    );

    state = AsyncData(updated);
    final repo = ref.read(dashboardRepositoryProvider);
    await repo.saveDashboardConfig(updated);
  }

  /// Reset to default configuration
  Future<void> resetToDefault() async {
    final repo = ref.read(dashboardRepositoryProvider);
    await repo.resetToDefault();
    state = AsyncData(DashboardConfig.defaultConfig());
  }
}

final dashboardConfigProvider =
    AsyncNotifierProvider<DashboardConfigNotifier, DashboardConfig>(
  DashboardConfigNotifier.new,
);

/// Edit mode toggle for the dashboard
class DashboardEditModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void enable() => state = true;
  void disable() => state = false;
}

final dashboardEditModeProvider =
    NotifierProvider<DashboardEditModeNotifier, bool>(
  DashboardEditModeNotifier.new,
);

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_config.freezed.dart';
part 'dashboard_config.g.dart';

/// Types of widgets available in the statistics dashboard
enum DashboardWidgetType {
  categoryPieChart,
  dailyBarChart,
  paymentMethodChart,
  trendIndicator,
  spendingVelocity,
  periodComparison,
  categoryInsights,
  smartInsights,
  budgetForecast,
  budgetBurndown,
}

/// Configuration for a single dashboard widget
@freezed
abstract class DashboardWidgetConfig with _$DashboardWidgetConfig {
  const factory DashboardWidgetConfig({
    required DashboardWidgetType widgetType,
    required int position,
    @Default(true) bool isVisible,
  }) = _DashboardWidgetConfig;

  factory DashboardWidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$DashboardWidgetConfigFromJson(json);
}

/// Dashboard configuration containing ordered list of widget configs
@Freezed(toJson: true)
abstract class DashboardConfig with _$DashboardConfig {
  const DashboardConfig._(); // Private constructor for custom methods

  @JsonSerializable(explicitToJson: true)
  const factory DashboardConfig({
    required String id,
    required String name,
    required List<DashboardWidgetConfig> widgets,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DashboardConfig;

  factory DashboardConfig.fromJson(Map<String, dynamic> json) =>
      _$DashboardConfigFromJson(json);

  /// Creates default dashboard configuration with all widgets visible
  factory DashboardConfig.defaultConfig() {
    final now = DateTime.now();
    return DashboardConfig(
      id: 'default',
      name: 'Default',
      widgets: DashboardWidgetType.values.asMap().entries.map((entry) {
        return DashboardWidgetConfig(
          widgetType: entry.value,
          position: entry.key,
          isVisible: true,
        );
      }).toList(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Returns only visible widgets, sorted by position
  List<DashboardWidgetConfig> get visibleWidgets =>
      widgets.where((w) => w.isVisible).toList()
        ..sort((a, b) => a.position.compareTo(b.position));
}

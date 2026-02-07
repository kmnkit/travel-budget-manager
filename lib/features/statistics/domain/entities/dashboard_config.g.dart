// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardWidgetConfig _$DashboardWidgetConfigFromJson(
  Map<String, dynamic> json,
) => _DashboardWidgetConfig(
  widgetType: $enumDecode(_$DashboardWidgetTypeEnumMap, json['widgetType']),
  position: (json['position'] as num).toInt(),
  isVisible: json['isVisible'] as bool? ?? true,
);

Map<String, dynamic> _$DashboardWidgetConfigToJson(
  _DashboardWidgetConfig instance,
) => <String, dynamic>{
  'widgetType': _$DashboardWidgetTypeEnumMap[instance.widgetType]!,
  'position': instance.position,
  'isVisible': instance.isVisible,
};

const _$DashboardWidgetTypeEnumMap = {
  DashboardWidgetType.categoryPieChart: 'categoryPieChart',
  DashboardWidgetType.dailyBarChart: 'dailyBarChart',
  DashboardWidgetType.paymentMethodChart: 'paymentMethodChart',
  DashboardWidgetType.trendIndicator: 'trendIndicator',
  DashboardWidgetType.spendingVelocity: 'spendingVelocity',
  DashboardWidgetType.periodComparison: 'periodComparison',
  DashboardWidgetType.categoryInsights: 'categoryInsights',
  DashboardWidgetType.smartInsights: 'smartInsights',
  DashboardWidgetType.budgetForecast: 'budgetForecast',
  DashboardWidgetType.budgetBurndown: 'budgetBurndown',
};

_DashboardConfig _$DashboardConfigFromJson(Map<String, dynamic> json) =>
    _DashboardConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      widgets: (json['widgets'] as List<dynamic>)
          .map((e) => DashboardWidgetConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DashboardConfigToJson(_DashboardConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'widgets': instance.widgets.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

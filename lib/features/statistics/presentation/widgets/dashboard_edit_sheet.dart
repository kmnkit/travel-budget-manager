import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/dashboard_providers.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class DashboardEditSheet extends ConsumerWidget {
  const DashboardEditSheet({super.key});

  String _getWidgetLabel(BuildContext context, DashboardWidgetType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case DashboardWidgetType.categoryPieChart:
        return l10n.widgetCategoryPieChart;
      case DashboardWidgetType.dailyBarChart:
        return l10n.widgetDailyBarChart;
      case DashboardWidgetType.paymentMethodChart:
        return l10n.widgetPaymentMethodChart;
      case DashboardWidgetType.trendIndicator:
        return l10n.widgetTrendIndicator;
      case DashboardWidgetType.spendingVelocity:
        return l10n.widgetSpendingVelocity;
      case DashboardWidgetType.periodComparison:
        return l10n.widgetPeriodComparison;
      case DashboardWidgetType.categoryInsights:
        return l10n.widgetCategoryInsights;
      case DashboardWidgetType.smartInsights:
        return l10n.widgetSmartInsights;
      case DashboardWidgetType.budgetForecast:
        return l10n.widgetBudgetForecast;
      case DashboardWidgetType.budgetBurndown:
        return l10n.widgetBudgetBurndown;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final configAsync = ref.watch(dashboardConfigProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.dashboardEdit,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Widget list
          Flexible(
            child: configAsync.when(
              data: (config) {
                return ReorderableListView(
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) {
                    ref
                        .read(dashboardConfigProvider.notifier)
                        .reorderWidget(oldIndex, newIndex);
                  },
                  children: config.widgets.map((widgetConfig) {
                    return ListTile(
                      key: ValueKey(widgetConfig.widgetType),
                      leading: const Icon(Icons.drag_handle),
                      title: Text(_getWidgetLabel(context, widgetConfig.widgetType)),
                      trailing: Switch(
                        value: widgetConfig.isVisible,
                        activeTrackColor: AppColors.primary,
                        onChanged: (value) {
                          ref
                              .read(dashboardConfigProvider.notifier)
                              .toggleWidgetVisibility(widgetConfig.widgetType);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          // Reset button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                ref.read(dashboardConfigProvider.notifier).resetToDefault();
              },
              child: Text(l10n.resetToDefault),
            ),
          ),
        ],
      ),
    );
  }
}

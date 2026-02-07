import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/trend_analysis_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/category_pie_chart.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/daily_bar_chart.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/payment_method_chart.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/trend_indicator.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/spending_velocity_card.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/comparative_analytics_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/comparison_card.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/category_insight_card.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/insights_provider.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/insight_card.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/budget_forecast_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/budget_forecast_card.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/budget_burndown_chart.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/dashboard_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/widgets/dashboard_edit_sheet.dart';
import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';

enum StatisticsPeriod {
  all,
  week,
  month,
  custom;

  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case StatisticsPeriod.all:
        return l10n.periodAll;
      case StatisticsPeriod.week:
        return l10n.periodWeek;
      case StatisticsPeriod.month:
        return l10n.periodMonth;
      case StatisticsPeriod.custom:
        return l10n.periodCustom;
    }
  }
}

/// Screen displaying statistics and charts for trip expenses
class StatisticsScreen extends ConsumerStatefulWidget {
  final int tripId;
  final String currencyCode;

  const StatisticsScreen({
    super.key,
    required this.tripId,
    required this.currencyCode,
  });

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  StatisticsPeriod _selectedPeriod = StatisticsPeriod.all;
  DateTimeRange? _customRange;

  bool _isInPeriod(DateTime date) {
    final now = DateTime.now();

    switch (_selectedPeriod) {
      case StatisticsPeriod.all:
        return true;
      case StatisticsPeriod.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        return date.isAfter(weekAgo);
      case StatisticsPeriod.month:
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return date.isAfter(monthAgo);
      case StatisticsPeriod.custom:
        if (_customRange == null) return true;
        return date.isAfter(_customRange!.start) &&
               date.isBefore(_customRange!.end.add(const Duration(days: 1)));
    }
  }

  Future<void> _selectCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customRange = picked;
      });
    }
  }

  Widget? _buildWidget(
    DashboardWidgetType type, {
    required Map<ExpenseCategory, double> filteredCategoryData,
    required Map<DateTime, double> filteredDailyData,
    required Map<String, double> filteredMethodData,
    required double filteredTotal,
    required AsyncValue trendAnalysisAsync,
    required AsyncValue velocityAsync,
    required AsyncValue periodComparisonAsync,
    required AsyncValue categoryInsightsAsync,
    required AsyncValue insightsAsync,
    required AsyncValue budgetForecastAsync,
  }) {
    switch (type) {
      case DashboardWidgetType.categoryPieChart:
        return CategoryPieChart(
          categoryData: filteredCategoryData,
          totalAmount: filteredTotal,
          currencyCode: widget.currencyCode,
        );
      case DashboardWidgetType.dailyBarChart:
        return DailyBarChart(
          dailyData: filteredDailyData,
          currencyCode: widget.currencyCode,
        );
      case DashboardWidgetType.paymentMethodChart:
        return PaymentMethodChart(
          methodData: filteredMethodData,
          totalAmount: filteredTotal,
          currencyCode: widget.currencyCode,
        );
      case DashboardWidgetType.trendIndicator:
        if (filteredDailyData.length < 2) return null;
        return trendAnalysisAsync.when(
          data: (trendData) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.overallSpendingTrend,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(width: 12),
                TrendIndicator(trendData: trendData.overallTrend),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      case DashboardWidgetType.spendingVelocity:
        if (filteredDailyData.isEmpty) return null;
        return velocityAsync.when(
          data: (velocityData) => SpendingVelocityCard(
            velocity: velocityData.velocity,
            currencyCode: widget.currencyCode,
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      case DashboardWidgetType.periodComparison:
        return periodComparisonAsync.when(
          data: (comparisonData) => ComparisonCard(
            comparisons: comparisonData.comparisons,
            currencyCode: widget.currencyCode,
            periodLabel: comparisonData.periodLabel,
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      case DashboardWidgetType.categoryInsights:
        return categoryInsightsAsync.when(
          data: (insightsData) => insightsData.insights.isNotEmpty
              ? CategoryInsightCard(
                  insights: insightsData.insights,
                  currencyCode: widget.currencyCode,
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      case DashboardWidgetType.smartInsights:
        return insightsAsync.when(
          data: (insightsData) => insightsData.insights.isNotEmpty
              ? InsightCard(insights: insightsData.insights)
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      case DashboardWidgetType.budgetForecast:
        return budgetForecastAsync.when(
          data: (forecastData) {
            if (forecastData.forecast.totalBudget <= 0) {
              return const SizedBox.shrink();
            }
            return BudgetForecastCard(
              forecast: forecastData.forecast,
              currencyCode: widget.currencyCode,
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
      case DashboardWidgetType.budgetBurndown:
        return budgetForecastAsync.when(
          data: (forecastData) {
            if (forecastData.forecast.totalBudget <= 0) {
              return const SizedBox.shrink();
            }
            return BudgetBurndownChart(
              forecast: forecastData.forecast,
              currencyCode: widget.currencyCode,
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statisticsAsync = ref.watch(statisticsDataProvider(widget.tripId));
    final trendAnalysisAsync = ref.watch(trendAnalysisProvider(widget.tripId));
    final velocityAsync = ref.watch(spendingVelocityProvider(widget.tripId));
    final periodComparisonAsync = ref.watch(periodComparisonProvider(widget.tripId));
    final categoryInsightsAsync = ref.watch(categoryInsightsProvider(widget.tripId));
    final insightsAsync = ref.watch(insightsProvider(widget.tripId));
    final budgetForecastAsync = ref.watch(budgetForecastProvider(widget.tripId));
    final dashboardConfigAsync = ref.watch(dashboardConfigProvider);

    return Scaffold(
      body: Column(
        children: [
          // Period filter chips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: StatisticsPeriod.values.map((period) {
                        final isSelected = _selectedPeriod == period;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(period.localizedLabel(context)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedPeriod = period;
                                if (period == StatisticsPeriod.custom) {
                                  _selectCustomRange();
                                }
                              });
                            },
                            selectedColor: AppColors.primary,
                            checkmarkColor: AppColors.onPrimary,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.textHint,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      builder: (context) => const DashboardEditSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
          // Statistics content
          Expanded(
            child: statisticsAsync.when(
              data: (statistics) {
                // Filter data by period
                final filteredCategoryData = <ExpenseCategory, double>{};
                final filteredDailyData = <DateTime, double>{};
                final filteredMethodData = <String, double>{};
                double filteredTotal = 0.0;

                // Filter categories
                statistics.categoryTotals.forEach((category, amount) {
                  filteredCategoryData[category] = amount;
                });

                // Filter daily data
                statistics.dailyTotals.forEach((date, amount) {
                  if (_isInPeriod(date)) {
                    filteredDailyData[date] = amount;
                    filteredTotal += amount;
                  }
                });

                // Filter payment methods
                statistics.paymentMethodTotals.forEach((method, amount) {
                  filteredMethodData[method] = amount;
                });

                // If no data after filtering
                if (filteredTotal == 0.0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noExpenseData,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.noExpenseDataInPeriod,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textHint,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: dashboardConfigAsync.when(
                    data: (config) {
                      final visibleWidgets = config.visibleWidgets;
                      return Column(
                        children: [
                          for (final widgetConfig in visibleWidgets)
                            _buildWidget(
                              widgetConfig.widgetType,
                              filteredCategoryData: filteredCategoryData,
                              filteredDailyData: filteredDailyData,
                              filteredMethodData: filteredMethodData,
                              filteredTotal: filteredTotal,
                              trendAnalysisAsync: trendAnalysisAsync,
                              velocityAsync: velocityAsync,
                              periodComparisonAsync: periodComparisonAsync,
                              categoryInsightsAsync: categoryInsightsAsync,
                              insightsAsync: insightsAsync,
                              budgetForecastAsync: budgetForecastAsync,
                            ) ?? const SizedBox.shrink(),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                    loading: () => Column(
                      children: [
                        // Fallback to original hardcoded order
                        CategoryPieChart(
                          categoryData: filteredCategoryData,
                          totalAmount: filteredTotal,
                          currencyCode: widget.currencyCode,
                        ),
                        if (filteredDailyData.length >= 2)
                          trendAnalysisAsync.when(
                            data: (trendData) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.overallSpendingTrend,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(width: 12),
                                  TrendIndicator(trendData: trendData.overallTrend),
                                ],
                              ),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (error, stackTrace) => const SizedBox.shrink(),
                          ),
                        DailyBarChart(
                          dailyData: filteredDailyData,
                          currencyCode: widget.currencyCode,
                        ),
                        if (filteredDailyData.isNotEmpty)
                          velocityAsync.when(
                            data: (velocityData) => SpendingVelocityCard(
                              velocity: velocityData.velocity,
                              currencyCode: widget.currencyCode,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (error, stackTrace) => const SizedBox.shrink(),
                          ),
                        periodComparisonAsync.when(
                          data: (comparisonData) => ComparisonCard(
                            comparisons: comparisonData.comparisons,
                            currencyCode: widget.currencyCode,
                            periodLabel: comparisonData.periodLabel,
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        categoryInsightsAsync.when(
                          data: (insightsData) => insightsData.insights.isNotEmpty
                            ? CategoryInsightCard(
                                insights: insightsData.insights,
                                currencyCode: widget.currencyCode,
                              )
                            : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        insightsAsync.when(
                          data: (insightsData) => insightsData.insights.isNotEmpty
                            ? InsightCard(insights: insightsData.insights)
                            : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        budgetForecastAsync.when(
                          data: (forecastData) {
                            if (forecastData.forecast.totalBudget <= 0) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                BudgetForecastCard(
                                  forecast: forecastData.forecast,
                                  currencyCode: widget.currencyCode,
                                ),
                                BudgetBurndownChart(
                                  forecast: forecastData.forecast,
                                  currencyCode: widget.currencyCode,
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        PaymentMethodChart(
                          methodData: filteredMethodData,
                          totalAmount: filteredTotal,
                          currencyCode: widget.currencyCode,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    error: (_, _) => Column(
                      children: [
                        // Fallback to original hardcoded order
                        CategoryPieChart(
                          categoryData: filteredCategoryData,
                          totalAmount: filteredTotal,
                          currencyCode: widget.currencyCode,
                        ),
                        if (filteredDailyData.length >= 2)
                          trendAnalysisAsync.when(
                            data: (trendData) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.overallSpendingTrend,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(width: 12),
                                  TrendIndicator(trendData: trendData.overallTrend),
                                ],
                              ),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (error, stackTrace) => const SizedBox.shrink(),
                          ),
                        DailyBarChart(
                          dailyData: filteredDailyData,
                          currencyCode: widget.currencyCode,
                        ),
                        if (filteredDailyData.isNotEmpty)
                          velocityAsync.when(
                            data: (velocityData) => SpendingVelocityCard(
                              velocity: velocityData.velocity,
                              currencyCode: widget.currencyCode,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (error, stackTrace) => const SizedBox.shrink(),
                          ),
                        periodComparisonAsync.when(
                          data: (comparisonData) => ComparisonCard(
                            comparisons: comparisonData.comparisons,
                            currencyCode: widget.currencyCode,
                            periodLabel: comparisonData.periodLabel,
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        categoryInsightsAsync.when(
                          data: (insightsData) => insightsData.insights.isNotEmpty
                            ? CategoryInsightCard(
                                insights: insightsData.insights,
                                currencyCode: widget.currencyCode,
                              )
                            : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        insightsAsync.when(
                          data: (insightsData) => insightsData.insights.isNotEmpty
                            ? InsightCard(insights: insightsData.insights)
                            : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        budgetForecastAsync.when(
                          data: (forecastData) {
                            if (forecastData.forecast.totalBudget <= 0) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                BudgetForecastCard(
                                  forecast: forecastData.forecast,
                                  currencyCode: widget.currencyCode,
                                ),
                                BudgetBurndownChart(
                                  forecast: forecastData.forecast,
                                  currencyCode: widget.currencyCode,
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                        PaymentMethodChart(
                          methodData: filteredMethodData,
                          totalAmount: filteredTotal,
                          currencyCode: widget.currencyCode,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
              loading: () => LoadingIndicator(message: AppLocalizations.of(context)!.statisticsCalculating),
              error: (error, stack) => AppErrorWidget(
                message: AppLocalizations.of(context)!.statisticsLoadFailed(error.toString()),
                onRetry: () {
                  ref.invalidate(statisticsDataProvider(widget.tripId));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

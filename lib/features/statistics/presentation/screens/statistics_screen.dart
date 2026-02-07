import 'package:flutter/material.dart';
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
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';

enum StatisticsPeriod {
  all('전체'),
  week('이번 주'),
  month('이번 달'),
  custom('직접 설정');

  const StatisticsPeriod(this.label);
  final String label;
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

  @override
  Widget build(BuildContext context) {
    final statisticsAsync = ref.watch(statisticsDataProvider(widget.tripId));
    final trendAnalysisAsync = ref.watch(trendAnalysisProvider(widget.tripId));
    final velocityAsync = ref.watch(spendingVelocityProvider(widget.tripId));
    final periodComparisonAsync = ref.watch(periodComparisonProvider(widget.tripId));
    final categoryInsightsAsync = ref.watch(categoryInsightsProvider(widget.tripId));
    final insightsAsync = ref.watch(insightsProvider(widget.tripId));

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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: StatisticsPeriod.values.map((period) {
                  final isSelected = _selectedPeriod == period;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(period.label),
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
                          '지출 데이터가 없습니다',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '선택한 기간에 지출 내역이 없습니다',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textHint,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Category pie chart
                      CategoryPieChart(
                        categoryData: filteredCategoryData,
                        totalAmount: filteredTotal,
                        currencyCode: widget.currencyCode,
                      ),
                      // Overall trend indicator
                      if (filteredDailyData.length >= 2)
                        trendAnalysisAsync.when(
                          data: (trendData) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  '전체 지출 추세:',
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
                      // Daily bar chart
                      DailyBarChart(
                        dailyData: filteredDailyData,
                        currencyCode: widget.currencyCode,
                      ),
                      // Spending velocity card
                      if (filteredDailyData.isNotEmpty)
                        velocityAsync.when(
                          data: (velocityData) => SpendingVelocityCard(
                            velocity: velocityData.velocity,
                            currencyCode: widget.currencyCode,
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (error, stackTrace) => const SizedBox.shrink(),
                        ),
                      // Period comparison card
                      periodComparisonAsync.when(
                        data: (comparisonData) => ComparisonCard(
                          comparisons: comparisonData.comparisons,
                          currencyCode: widget.currencyCode,
                          periodLabel: comparisonData.periodLabel,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (error, stackTrace) => const SizedBox.shrink(),
                      ),
                      // Category insights card
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
                      // Smart insights card
                      insightsAsync.when(
                        data: (insightsData) => insightsData.insights.isNotEmpty
                          ? InsightCard(insights: insightsData.insights)
                          : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (error, stackTrace) => const SizedBox.shrink(),
                      ),
                      // Payment method chart
                      PaymentMethodChart(
                        methodData: filteredMethodData,
                        totalAmount: filteredTotal,
                        currencyCode: widget.currencyCode,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
              loading: () => const LoadingIndicator(message: '통계를 계산하는 중...'),
              error: (error, stack) => AppErrorWidget(
                message: '통계 데이터를 불러올 수 없습니다\n${error.toString()}',
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

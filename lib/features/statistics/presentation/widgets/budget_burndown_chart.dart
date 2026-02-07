import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

/// Line chart showing budget burn-down with projections
///
/// Displays:
/// - Blue solid line: historical cumulative spending
/// - Blue dashed line: projected spending (linear extension)
/// - Red horizontal line: budget limit
/// - Light blue area: confidence interval band
class BudgetBurndownChart extends StatelessWidget {
  final BudgetForecast forecast;
  final String currencyCode;

  const BudgetBurndownChart({
    super.key,
    required this.forecast,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    if (forecast.historicalSpending.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    // Compute all data points for axis ranges
    final allPoints = <DataPoint>[
      ...forecast.historicalSpending,
      ...forecast.projectedSpending,
    ];
    if (forecast.budgetLine.isNotEmpty) {
      allPoints.addAll(forecast.budgetLine);
    }

    final firstDate = allPoints
        .map((p) => p.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final maxY = allPoints.map((p) => p.value).reduce(math.max);
    final budgetMax = forecast.totalBudget;
    final chartMaxY = math.max(maxY, budgetMax) * 1.15;

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.budgetBurndownChart,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Legend
            _buildLegend(context),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: chartMaxY,
                  titlesData: _buildTitlesData(context, firstDate),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: chartMaxY / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.textHint.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            CurrencyFormatter.format(spot.y, currencyCode),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: _buildLineBarsData(firstDate),
                  betweenBarsData: _buildConfidenceBand(firstDate),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(theme, Colors.blue, AppLocalizations.of(context)!.actualSpending),
        const SizedBox(width: 16),
        _legendItem(theme, Colors.blue.shade200, AppLocalizations.of(context)!.projectedSpending),
        const SizedBox(width: 16),
        _legendItem(theme, Colors.red, AppLocalizations.of(context)!.budgetLimit),
      ],
    );
  }

  Widget _legendItem(ThemeData theme, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context, DateTime firstDate) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final date = firstDate.add(Duration(days: value.toInt()));
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                DateFormat('M/d').format(date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
              ),
            );
          },
          reservedSize: 30,
          interval: _calculateDateInterval(),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              CurrencyFormatter.formatCompact(value, currencyCode),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
            );
          },
          reservedSize: 55,
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  double _calculateDateInterval() {
    final totalDays = forecast.daysElapsed + forecast.daysRemaining;
    if (totalDays <= 7) return 1;
    if (totalDays <= 14) return 2;
    if (totalDays <= 30) return 5;
    return 7;
  }

  List<LineChartBarData> _buildLineBarsData(DateTime firstDate) {
    final lines = <LineChartBarData>[];

    // 1. Historical spending (solid blue line)
    if (forecast.historicalSpending.isNotEmpty) {
      lines.add(LineChartBarData(
        spots: forecast.historicalSpending
            .map((p) => FlSpot(
                  p.date.difference(firstDate).inDays.toDouble(),
                  p.value,
                ))
            .toList(),
        isCurved: false,
        color: Colors.blue,
        barWidth: 3,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    }

    // 2. Projected spending (dashed blue line)
    if (forecast.projectedSpending.isNotEmpty) {
      // Connect from last historical point
      final projSpots = <FlSpot>[];
      if (forecast.historicalSpending.isNotEmpty) {
        final last = forecast.historicalSpending.last;
        projSpots.add(FlSpot(
          last.date.difference(firstDate).inDays.toDouble(),
          last.value,
        ));
      }
      projSpots.addAll(forecast.projectedSpending.map((p) => FlSpot(
            p.date.difference(firstDate).inDays.toDouble(),
            p.value,
          )));

      lines.add(LineChartBarData(
        spots: projSpots,
        isCurved: false,
        color: Colors.blue.shade200,
        barWidth: 2,
        dotData: const FlDotData(show: false),
        dashArray: [8, 4],
        belowBarData: BarAreaData(show: false),
      ));
    }

    // 3. Budget limit (red horizontal line)
    if (forecast.budgetLine.length >= 2) {
      lines.add(LineChartBarData(
        spots: forecast.budgetLine
            .map((p) => FlSpot(
                  p.date.difference(firstDate).inDays.toDouble(),
                  p.value,
                ))
            .toList(),
        isCurved: false,
        color: Colors.red,
        barWidth: 2,
        dotData: const FlDotData(show: false),
        dashArray: [4, 4],
        belowBarData: BarAreaData(show: false),
      ));
    }

    // 4. Best-case confidence line (invisible, for band rendering)
    if (forecast.historicalSpending.isNotEmpty && 
        forecast.confidenceInterval.bestCase != forecast.confidenceInterval.worstCase &&
        forecast.daysRemaining > 0) {
      final lastHistorical = forecast.historicalSpending.last;
      final startDay = lastHistorical.date.difference(firstDate).inDays.toDouble();
      final startValue = lastHistorical.value;
      final endValue = forecast.confidenceInterval.bestCase;
      
      // Generate points from last historical to best case over remaining days
      final bestCaseSpots = <FlSpot>[];
      for (int i = 0; i <= forecast.daysRemaining; i++) {
        final progress = forecast.daysRemaining > 0 ? i / forecast.daysRemaining : 1.0;
        final value = startValue + (endValue - startValue) * progress;
        bestCaseSpots.add(FlSpot(startDay + i, value));
      }

      lines.add(LineChartBarData(
        spots: bestCaseSpots,
        isCurved: false,
        color: Colors.transparent,
        barWidth: 0,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    }

    // 5. Worst-case confidence line (invisible, for band rendering)
    if (forecast.historicalSpending.isNotEmpty && 
        forecast.confidenceInterval.bestCase != forecast.confidenceInterval.worstCase &&
        forecast.daysRemaining > 0) {
      final lastHistorical = forecast.historicalSpending.last;
      final startDay = lastHistorical.date.difference(firstDate).inDays.toDouble();
      final startValue = lastHistorical.value;
      final endValue = forecast.confidenceInterval.worstCase;
      
      // Generate points from last historical to worst case over remaining days
      final worstCaseSpots = <FlSpot>[];
      for (int i = 0; i <= forecast.daysRemaining; i++) {
        final progress = forecast.daysRemaining > 0 ? i / forecast.daysRemaining : 1.0;
        final value = startValue + (endValue - startValue) * progress;
        worstCaseSpots.add(FlSpot(startDay + i, value));
      }

      lines.add(LineChartBarData(
        spots: worstCaseSpots,
        isCurved: false,
        color: Colors.transparent,
        barWidth: 0,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    }

    return lines;
  }

  List<BetweenBarsData> _buildConfidenceBand(DateTime firstDate) {
    if (forecast.projectedSpending.isEmpty ||
        forecast.confidenceInterval.bestCase == forecast.confidenceInterval.worstCase ||
        forecast.daysRemaining <= 0 ||
        forecast.historicalSpending.isEmpty) {
      return [];
    }

    // Return BetweenBarsData connecting the best-case (index 3) and worst-case (index 4) lines
    return [
      BetweenBarsData(
        fromIndex: 3,
        toIndex: 4,
        color: Colors.blue.withValues(alpha: 0.1),
      ),
    ];
  }
}

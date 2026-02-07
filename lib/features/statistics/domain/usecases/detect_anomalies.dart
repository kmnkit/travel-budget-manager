import 'dart:math' show sqrt;

import '../entities/analytics_insight.dart';

/// Use case for detecting anomalous spending patterns
///
/// Analyzes daily spending data and category distributions to identify:
/// - Daily spending spikes (> mean + 2*stddev)
/// - Recent spending increase trends (last 3 days avg > overall avg * 1.5)
/// - Budget threshold breaches (single day > 20% of budget)
/// - Category concentration (single category > 50% of total)
class DetectAnomalies {
  /// Detect anomalies in spending data
  ///
  /// [dailyTotals] - Map of date to total spending for that day
  /// [categoryTotals] - Map of category name to total spending
  /// [totalBudget] - Optional total budget to check against
  ///
  /// Returns a list of [AnalyticsInsight] objects representing detected anomalies
  List<AnalyticsInsight> call({
    required Map<DateTime, double> dailyTotals,
    required Map<String, double> categoryTotals,
    double? totalBudget,
  }) {
    final insights = <AnalyticsInsight>[];
    final now = DateTime.now();
    var idCounter = 0;

    String nextId() => 'anomaly_${now.millisecondsSinceEpoch}_${idCounter++}';

    if (dailyTotals.isEmpty) return insights;

    final values = dailyTotals.values.toList();

    // 1. Daily spending spike detection (> mean + 2*stddev)
    if (values.length >= 3) {
      final mean = _calculateMean(values);
      final stdDev = _calculateStdDev(values, mean);

      if (stdDev > 0) {
        final threshold = mean + 2 * stdDev;

        final sortedEntries = dailyTotals.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        for (final entry in sortedEntries) {
          if (entry.value > threshold) {
            insights.add(AnalyticsInsight(
              id: nextId(),
              type: InsightType.anomaly,
              title: '비정상 지출 감지',
              description:
                  '${entry.key.month}월 ${entry.key.day}일 지출이 평균보다 현저히 높습니다',
              priority: InsightPriority.high,
              generatedAt: now,
              metadata: {
                'date': entry.key.toIso8601String(),
                'amount': entry.value,
                'mean': mean,
                'threshold': threshold,
              },
            ));
          }
        }
      }
    }

    // 2. Recent spending increase (last 3 days avg > overall avg * 1.5)
    if (values.length >= 4) {
      final sortedEntries = dailyTotals.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      final overallMean = _calculateMean(values);
      final last3 = sortedEntries.sublist(sortedEntries.length - 3);
      final last3Values = last3.map((e) => e.value).toList();
      final recentMean = _calculateMean(last3Values);

      if (overallMean > 0 && recentMean > overallMean * 1.5) {
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.trend,
          title: '최근 지출 증가',
          description: '최근 3일간 지출이 증가 추세입니다',
          priority: InsightPriority.medium,
          generatedAt: now,
          metadata: {
            'recentAvg': recentMean,
            'overallAvg': overallMean,
          },
        ));
      }
    }

    // 3. Budget threshold breach (single day > 20% of budget)
    if (totalBudget != null && totalBudget > 0) {
      final budgetThreshold = totalBudget * 0.2;

      final sortedEntries = dailyTotals.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      for (final entry in sortedEntries) {
        if (entry.value > budgetThreshold) {
          final percentage = (entry.value / totalBudget * 100);
          insights.add(AnalyticsInsight(
            id: nextId(),
            type: InsightType.anomaly,
            title: '일일 예산 초과',
            description:
                '하루에 예산의 ${percentage.toStringAsFixed(1)}%를 사용했습니다',
            priority: InsightPriority.high,
            generatedAt: now,
            metadata: {
              'date': entry.key.toIso8601String(),
              'amount': entry.value,
              'budgetPercentage': percentage,
            },
          ));
        }
      }
    }

    // 4. Category concentration (single category > 50%)
    if (categoryTotals.isNotEmpty) {
      final totalCategoryAmount =
          categoryTotals.values.fold(0.0, (sum, v) => sum + v);
      if (totalCategoryAmount > 0) {
        for (final entry in categoryTotals.entries) {
          final percentage = (entry.value / totalCategoryAmount) * 100;
          if (percentage > 50) {
            insights.add(AnalyticsInsight(
              id: nextId(),
              type: InsightType.anomaly,
              title: '지출 편중',
              description: '${entry.key} 카테고리에 지출이 집중되어 있습니다',
              priority: InsightPriority.medium,
              generatedAt: now,
              metadata: {
                'category': entry.key,
                'percentage': percentage,
              },
            ));
          }
        }
      }
    }

    return insights;
  }

  double _calculateMean(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.fold(0.0, (sum, v) => sum + v) / values.length;
  }

  double _calculateStdDev(List<double> values, double mean) {
    if (values.length < 2) return 0.0;
    final variance = values
            .map((v) => (v - mean) * (v - mean))
            .fold(0.0, (sum, v) => sum + v) /
        values.length;
    return sqrt(variance);
  }
}

import '../entities/analytics_insight.dart';

/// Use case for generating spending and budget insights
class GenerateInsights {
  /// Generate insights from spending and budget data
  List<AnalyticsInsight> call({
    required Map<String, double> categoryTotals,
    required double totalAmount,
    double? totalBudget,
    double? budgetRemaining,
    int? daysRemaining,
    double? dailyBudgetRemaining,
    double? dailyAverage,
  }) {
    if (categoryTotals.isEmpty || totalAmount <= 0) return [];

    final insights = <AnalyticsInsight>[];
    final now = DateTime.now();
    var idCounter = 0;

    String nextId() => 'insight_${now.millisecondsSinceEpoch}_${idCounter++}';

    // 1. Category dominance insights
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedCategories) {
      final percentage = (entry.value / totalAmount) * 100;
      if (percentage > 40) {
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.spending,
          title: '${entry.key} 지출 비중 높음',
          description: '${entry.key}이(가) 전체 지출의 ${percentage.toStringAsFixed(1)}%를 차지합니다',
          priority: InsightPriority.high,
          generatedAt: now,
          metadata: {'category': entry.key, 'percentage': percentage},
        ));
      } else if (percentage >= 25) {
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.spending,
          title: '${entry.key} 지출 주의',
          description: '${entry.key}이(가) 전체 지출의 ${percentage.toStringAsFixed(1)}%를 차지합니다',
          priority: InsightPriority.medium,
          generatedAt: now,
          metadata: {'category': entry.key, 'percentage': percentage},
        ));
      }
    }

    // 2. Budget insights (only if budget data available)
    if (totalBudget != null && totalBudget > 0) {
      final percentUsed = ((totalBudget - (budgetRemaining ?? 0)) / totalBudget) * 100;

      if (budgetRemaining != null && budgetRemaining < 0) {
        // Budget exceeded
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.budget,
          title: '예산 초과',
          description: '예산을 ${(-budgetRemaining).toStringAsFixed(0)}원 초과했습니다',
          priority: InsightPriority.high,
          generatedAt: now,
          metadata: {'budgetRemaining': budgetRemaining, 'percentUsed': percentUsed},
        ));
      } else if (percentUsed > 75) {
        // Budget warning
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.budget,
          title: '예산 주의',
          description: '예산의 ${percentUsed.toStringAsFixed(1)}%를 사용했습니다',
          priority: InsightPriority.high,
          generatedAt: now,
          metadata: {'percentUsed': percentUsed},
        ));
      } else if (dailyAverage != null && dailyBudgetRemaining != null && dailyAverage <= dailyBudgetRemaining) {
        // On track
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.budget,
          title: '예산 관리 양호',
          description: '예산 내에서 잘 관리하고 있습니다',
          priority: InsightPriority.low,
          generatedAt: now,
        ));
      }

      // Daily budget recommendation
      if (daysRemaining != null && daysRemaining > 0 && budgetRemaining != null && budgetRemaining > 0) {
        final dailyBudget = budgetRemaining / daysRemaining;
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.recommendation,
          title: '일일 예산 제안',
          description: '남은 $daysRemaining일간 하루 ${dailyBudget.toStringAsFixed(0)}원 이내로 지출하세요',
          priority: InsightPriority.medium,
          generatedAt: now,
          metadata: {'daysRemaining': daysRemaining, 'dailyBudget': dailyBudget},
        ));
      }
    }

    // 3. Top category recommendation
    if (sortedCategories.isNotEmpty) {
      final topCategory = sortedCategories.first;
      final topPercentage = (topCategory.value / totalAmount) * 100;
      if (topPercentage > 30) {
        insights.add(AnalyticsInsight(
          id: nextId(),
          type: InsightType.recommendation,
          title: '${topCategory.key} 절약 제안',
          description: '${topCategory.key} 지출을 줄이는 것을 고려해보세요',
          priority: InsightPriority.medium,
          generatedAt: now,
          metadata: {'category': topCategory.key, 'percentage': topPercentage},
        ));
      }
    }

    // Sort by priority (high first)
    insights.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return insights;
  }
}

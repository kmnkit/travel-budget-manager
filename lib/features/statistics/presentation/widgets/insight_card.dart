import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';

/// Widget that displays a list of analytics insights
class InsightCard extends StatelessWidget {
  final List<AnalyticsInsight> insights;

  const InsightCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.smartInsights,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...insights.asMap().entries.map((entry) {
              final index = entry.key;
              final insight = entry.value;
              final isLast = index == insights.length - 1;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getIconForType(insight.type),
                        color: _getColorForPriority(insight.priority),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              insight.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) const Divider(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(InsightType type) {
    switch (type) {
      case InsightType.spending:
        return Icons.attach_money;
      case InsightType.budget:
        return Icons.account_balance_wallet;
      case InsightType.trend:
        return Icons.trending_up;
      case InsightType.anomaly:
        return Icons.warning_amber;
      case InsightType.recommendation:
        return Icons.lightbulb_outline;
    }
  }

  Color _getColorForPriority(InsightPriority priority) {
    switch (priority) {
      case InsightPriority.high:
        return Colors.red;
      case InsightPriority.medium:
        return Colors.amber.shade700;
      case InsightPriority.low:
        return Colors.teal;
    }
  }
}

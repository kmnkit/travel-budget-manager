import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/statistics/domain/entities/category_insight.dart';

/// A card widget that displays ranked category insights
///
/// Shows categories ranked by spending amount with percentage bars
/// and optional comparison indicators.
class CategoryInsightCard extends StatelessWidget {
  final List<CategoryInsight> insights;
  final String currencyCode;

  const CategoryInsightCard({
    super.key,
    required this.insights,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
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
            // Title
            Text(
              AppLocalizations.of(context)!.categoryAnalysis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Insights or empty state
            if (insights.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    AppLocalizations.of(context)!.noCategoryData,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              ...insights.map((insight) => _buildInsightRow(context, insight)),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(BuildContext context, CategoryInsight insight) {
    final theme = Theme.of(context);

    // Rank badge colors
    final Color rankColor;
    switch (insight.rank) {
      case 1:
        rankColor = const Color(0xFFFFD700); // Gold
      case 2:
        rankColor = const Color(0xFFC0C0C0); // Silver
      case 3:
        rankColor = const Color(0xFFCD7F32); // Bronze
      default:
        rankColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: rankColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${insight.rank}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Category name
              Expanded(
                child: Text(
                  insight.category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Amount
              Text(
                CurrencyFormatter.format(insight.amount, currencyCode),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              // Percentage
              SizedBox(
                width: 50,
                child: Text(
                  '${insight.percentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Progress bar
          Row(
            children: [
              const SizedBox(width: 32), // Align with text after rank badge
              Expanded(
                child: LinearProgressIndicator(
                  value: insight.percentage / 100,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(
                  width: 58), // Align with amount + percentage
            ],
          ),
          // Change indicator (if available)
          if (insight.changePercentage != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                const SizedBox(width: 32),
                Icon(
                  insight.changePercentage! > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 14,
                  color: insight.changePercentage! > 0
                      ? Colors.red
                      : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  '${insight.changePercentage!.abs().toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: insight.changePercentage! > 0
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

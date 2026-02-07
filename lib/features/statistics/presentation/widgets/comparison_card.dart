import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/statistics/domain/entities/comparison_result.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

/// A card widget that displays period comparison results
///
/// Shows current vs previous period totals with percentage change
/// and color-coded trend indicators.
class ComparisonCard extends StatelessWidget {
  final List<ComparisonResult> comparisons;
  final String currencyCode;
  final String? periodLabel;

  const ComparisonCard({
    super.key,
    required this.comparisons,
    required this.currencyCode,
    this.periodLabel,
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
              AppLocalizations.of(context)!.periodComparison,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Period label
            if (periodLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                _resolveLabel(context, periodLabel!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Comparison rows or empty state
            if (comparisons.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    AppLocalizations.of(context)!.noComparisonData,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              ...comparisons.map(
                  (comparison) => _buildComparisonRow(context, comparison)),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
      BuildContext context, ComparisonResult comparison) {
    final theme = Theme.of(context);

    // Color coding: green for savings (down), red for overspending (up), grey for stable
    final Color trendColor;
    final IconData trendIcon;

    switch (comparison.direction) {
      case TrendDirection.up:
        trendColor = Colors.red;
        trendIcon = Icons.trending_up;
      case TrendDirection.down:
        trendColor = Colors.green;
        trendIcon = Icons.trending_down;
      case TrendDirection.stable:
        trendColor = Colors.grey;
        trendIcon = Icons.trending_flat;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Label
          Expanded(
            flex: 2,
            child: Text(
              _resolveLabel(context, comparison.label),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Current value
          Expanded(
            flex: 2,
            child: Text(
              CurrencyFormatter.format(comparison.currentValue, currencyCode),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 8),
          // Trend icon and percentage
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(trendIcon, color: trendColor, size: 18),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${comparison.percentageChange.abs().toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Resolves l10n key identifiers to localized strings.
  /// Falls back to the raw string for category names or other dynamic labels.
  String _resolveLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'totalExpense':
        return l10n.totalExpense;
      case 'thisWeekVsLastWeek':
        return l10n.thisWeekVsLastWeek;
      default:
        return key;
    }
  }
}

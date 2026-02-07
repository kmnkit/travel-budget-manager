import 'package:flutter/material.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

/// A compact widget that displays trend direction, change percentage, and confidence
class TrendIndicator extends StatelessWidget {
  final TrendData trendData;

  const TrendIndicator({
    super.key,
    required this.trendData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine icon and color based on trend direction
    final IconData icon;
    final Color color;

    switch (trendData.direction) {
      case TrendDirection.up:
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case TrendDirection.down:
        icon = Icons.trending_down;
        color = Colors.red;
        break;
      case TrendDirection.stable:
        icon = Icons.trending_flat;
        color = Colors.grey;
        break;
    }

    // Format percentages with 1 decimal place
    final changeText = '${trendData.changePercentage.abs().toStringAsFixed(1)}%';
    final confidenceText = '${(trendData.confidence * 100).toStringAsFixed(0)}%';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          changeText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.confidenceLabel(confidenceText),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

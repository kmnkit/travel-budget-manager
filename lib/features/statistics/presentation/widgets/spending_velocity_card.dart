import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/statistics/domain/entities/spending_velocity.dart';

/// A card widget that displays spending velocity metrics
///
/// Shows daily/weekly averages and acceleration trends
class SpendingVelocityCard extends StatelessWidget {
  final SpendingVelocity velocity;
  final String currencyCode;

  const SpendingVelocityCard({
    super.key,
    required this.velocity,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine acceleration indicator
    final IconData accelerationIcon;
    final Color accelerationColor;
    final String accelerationText;

    const stableThreshold = 2.0; // Threshold for "stable" classification

    if (velocity.acceleration.abs() < stableThreshold) {
      accelerationIcon = Icons.trending_flat;
      accelerationColor = Colors.grey;
      accelerationText = '안정';
    } else if (velocity.acceleration > 0) {
      accelerationIcon = Icons.trending_up;
      accelerationColor = Colors.green;
      accelerationText = '증가 중';
    } else {
      accelerationIcon = Icons.trending_down;
      accelerationColor = Colors.red;
      accelerationText = '감소 중';
    }

    // Format period dates
    final periodText = _formatPeriod(velocity.periodStart, velocity.periodEnd);

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
              '지출 속도',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Daily Average
            _buildMetricRow(
              context,
              label: '일평균',
              value: CurrencyFormatter.format(
                velocity.dailyAverage,
                currencyCode,
              ),
            ),
            const SizedBox(height: 12),

            // Weekly Average
            _buildMetricRow(
              context,
              label: '주평균',
              value: CurrencyFormatter.format(
                velocity.weeklyAverage,
                currencyCode,
              ),
            ),
            const SizedBox(height: 16),

            // Acceleration Indicator
            Row(
              children: [
                Icon(
                  accelerationIcon,
                  color: accelerationColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '가속도: $accelerationText',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accelerationColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Period
            Text(
              '기간: $periodText',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatPeriod(DateTime start, DateTime end) {
    final formatter = DateFormat('M/d');

    if (start == end) {
      return formatter.format(start);
    }

    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }
}

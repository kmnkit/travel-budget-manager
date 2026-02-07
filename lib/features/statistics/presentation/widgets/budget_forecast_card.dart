import 'package:flutter/material.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';

/// A card widget that displays budget forecast metrics
///
/// Shows projected total spend, days until exhaustion,
/// daily spending rate, and color-coded forecast status
class BudgetForecastCard extends StatelessWidget {
  final BudgetForecast forecast;
  final String currencyCode;

  const BudgetForecastCard({
    super.key,
    required this.forecast,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(forecast.status);

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
            // Title with status icon
            Row(
              children: [
                Text(
                  '예산 예측',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  statusInfo.icon,
                  color: statusInfo.color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  statusInfo.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: statusInfo.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Projected total spend
            _buildMetricRow(
              context,
              label: '예상 총 지출',
              value: CurrencyFormatter.format(
                forecast.projectedTotalSpend,
                currencyCode,
              ),
            ),
            const SizedBox(height: 12),

            // Daily spending rate
            _buildMetricRow(
              context,
              label: '일일 지출',
              value: CurrencyFormatter.format(
                forecast.dailySpendingRate,
                currencyCode,
              ),
            ),
            const SizedBox(height: 12),

            // Days until exhaustion
            _buildMetricRow(
              context,
              label: '예산 소진까지',
              value: forecast.daysUntilExhaustion != null
                  ? '${forecast.daysUntilExhaustion}일'
                  : '예산 충분',
            ),
            const SizedBox(height: 12),

            // Budget vs projected progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: forecast.totalBudget > 0
                    ? (forecast.totalSpent / forecast.totalBudget).clamp(0.0, 1.0)
                    : 0.0,
                minHeight: 8,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(statusInfo.color),
              ),
            ),
            const SizedBox(height: 8),

            // Spent vs budget label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(forecast.totalSpent, currencyCode),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  CurrencyFormatter.format(forecast.totalBudget, currencyCode),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
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

  _StatusInfo _getStatusInfo(ForecastStatus status) {
    switch (status) {
      case ForecastStatus.onTrack:
        return _StatusInfo(
          icon: Icons.check_circle,
          color: Colors.green,
          label: '순조로움',
        );
      case ForecastStatus.atRisk:
        return _StatusInfo(
          icon: Icons.warning,
          color: Colors.amber,
          label: '주의 필요',
        );
      case ForecastStatus.overBudget:
        return _StatusInfo(
          icon: Icons.error,
          color: Colors.red,
          label: '초과 예상',
        );
      case ForecastStatus.exhausted:
        return _StatusInfo(
          icon: Icons.dangerous,
          color: const Color(0xFFB71C1C),
          label: '예산 소진',
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;
  final String label;

  const _StatusInfo({
    required this.icon,
    required this.color,
    required this.label,
  });
}

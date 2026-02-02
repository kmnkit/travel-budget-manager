import 'package:flutter/material.dart';
import 'package:trip_wallet/core/constants/app_constants.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/budget/presentation/widgets/circular_budget_progress.dart';

class BudgetSummaryCard extends StatelessWidget {
  final BudgetSummary budgetSummary;
  final String currencyCode;

  const BudgetSummaryCard({
    super.key,
    required this.budgetSummary,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Left: Vertical stats
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  context,
                  label: '총 예산',
                  amount: budgetSummary.totalBudget,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  label: '지출',
                  amount: budgetSummary.totalSpent,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  label: '잔액',
                  amount: budgetSummary.remaining,
                  textTheme: textTheme,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right: Circular donut chart
          Expanded(
            flex: 2,
            child: Column(
              children: [
                CircularBudgetProgress(
                  percentUsed: budgetSummary.percentUsed,
                  status: budgetSummary.status,
                  size: 100,
                ),
                const SizedBox(height: 4),
                Text(
                  '사용됨',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required String label,
    required double amount,
    required TextTheme textTheme,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          CurrencyFormatter.format(amount, currencyCode),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

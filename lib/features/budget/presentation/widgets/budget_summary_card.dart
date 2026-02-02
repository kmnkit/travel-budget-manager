import 'package:flutter/material.dart';
import 'package:trip_wallet/core/constants/app_constants.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/budget/presentation/widgets/linear_budget_progress.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Horizontal 3-column layout
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  context,
                  label: '예산',
                  amount: budgetSummary.totalBudget,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: _buildStatColumn(
                  context,
                  label: '사용',
                  amount: budgetSummary.totalSpent,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: _buildStatColumn(
                  context,
                  label: '잔액',
                  amount: budgetSummary.remaining,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Linear progress bar
          LinearBudgetProgress(
            percentUsed: budgetSummary.percentUsed,
            status: budgetSummary.status,
          ),
          const SizedBox(height: 8),
          // Percentage text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${budgetSummary.percentUsed.toStringAsFixed(0)}% 사용됨',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required String label,
    required double amount,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount, currencyCode),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

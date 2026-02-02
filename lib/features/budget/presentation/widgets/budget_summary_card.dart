import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircularBudgetProgress(
              percentUsed: budgetSummary.percentUsed,
              status: budgetSummary.status,
            ),
            const SizedBox(height: 24),
            _buildStatRow(
              context,
              label: '예산',
              amount: budgetSummary.totalBudget,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              label: '사용',
              amount: budgetSummary.totalSpent,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              label: '잔액',
              amount: budgetSummary.remaining,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required String label,
    required double amount,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          CurrencyFormatter.format(amount, currencyCode),
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

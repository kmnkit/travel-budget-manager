import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';

class LinearBudgetProgress extends StatelessWidget {
  final double percentUsed;
  final BudgetStatus status;
  final double height;

  const LinearBudgetProgress({
    super.key,
    required this.percentUsed,
    required this.status,
    this.height = 6,
  });

  Color _getStatusColor() {
    switch (status) {
      case BudgetStatus.comfortable:
        return AppColors.budgetComfortable;
      case BudgetStatus.caution:
        return AppColors.budgetCaution;
      case BudgetStatus.warning:
        return AppColors.budgetWarning;
      case BudgetStatus.exceeded:
        return AppColors.budgetExceeded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clampedPercent = (percentUsed / 100).clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth * clampedPercent,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

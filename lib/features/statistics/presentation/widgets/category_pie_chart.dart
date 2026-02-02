import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// Pie chart showing expense distribution by category
class CategoryPieChart extends StatelessWidget {
  final Map<ExpenseCategory, double> categoryData;
  final double totalAmount;
  final String currencyCode;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.totalAmount,
    required this.currencyCode,
  });

  Color _getCategoryColor(ExpenseCategory category) {
    return category.color;
  }

  @override
  Widget build(BuildContext context) {
    // Filter out categories with zero amounts
    final nonZeroCategories = categoryData.entries
        .where((entry) => entry.value > 0)
        .toList();

    if (nonZeroCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '카테고리별 지출',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: nonZeroCategories.map((entry) {
                    final category = entry.key;
                    final amount = entry.value;
                    final percentage = (amount / totalAmount * 100);

                    return PieChartSectionData(
                      value: amount,
                      title: '${percentage.toStringAsFixed(1)}%',
                      color: _getCategoryColor(category),
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: nonZeroCategories.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                final percentage = (amount / totalAmount * 100).toStringAsFixed(1);

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${category.labelKo} ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                    Text(
                      '$percentage% · ${CurrencyFormatter.formatCompact(amount, currencyCode)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

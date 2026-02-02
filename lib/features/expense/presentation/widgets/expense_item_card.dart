import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// A card widget that displays a single expense item in a list.
///
/// Shows category icon, memo/category name, payment method, and dual currency amounts.
class ExpenseItemCard extends StatelessWidget {
  /// The expense category for icon and color display
  final ExpenseCategory category;

  /// Optional memo text for the expense
  final String? memo;

  /// The original expense amount
  final double amount;

  /// The currency code of the original amount
  final String currency;

  /// The converted amount in the base currency
  final double convertedAmount;

  /// The base currency code for converted amount display
  final String baseCurrency;

  /// Optional payment method name to display
  final String? paymentMethodName;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  const ExpenseItemCard({
    super.key,
    required this.category,
    this.memo,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.baseCurrency,
    this.paymentMethodName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryInfo = _getCategoryInfo(category);

    return Semantics(
      label: 'Expense: ${memo ?? categoryInfo.label}, ${CurrencyFormatter.format(amount, currency)}',
      button: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Category icon circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: categoryInfo.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryInfo.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // Memo and payment method
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memo ?? categoryInfo.label,
                        style: theme.textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (paymentMethodName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          paymentMethodName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Dual amount display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Original amount (bold)
                    Text(
                      CurrencyFormatter.format(amount, currency),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Converted amount (smaller, secondary color)
                    Text(
                      CurrencyFormatter.format(convertedAmount, baseCurrency),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns icon and color information for a given expense category
  _CategoryInfo _getCategoryInfo(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return const _CategoryInfo(
          icon: Icons.restaurant,
          color: AppColors.categoryFood,
          label: '식비',
        );
      case ExpenseCategory.transport:
        return const _CategoryInfo(
          icon: Icons.directions_car,
          color: AppColors.categoryTransport,
          label: '교통',
        );
      case ExpenseCategory.accommodation:
        return const _CategoryInfo(
          icon: Icons.hotel,
          color: AppColors.categoryAccommodation,
          label: '숙박',
        );
      case ExpenseCategory.shopping:
        return const _CategoryInfo(
          icon: Icons.shopping_bag,
          color: AppColors.categoryShopping,
          label: '쇼핑',
        );
      case ExpenseCategory.entertainment:
        return const _CategoryInfo(
          icon: Icons.movie,
          color: AppColors.categoryEntertainment,
          label: '오락',
        );
      case ExpenseCategory.sightseeing:
        return const _CategoryInfo(
          icon: Icons.camera_alt,
          color: AppColors.categorySightseeing,
          label: '관광',
        );
      case ExpenseCategory.communication:
        return const _CategoryInfo(
          icon: Icons.phone,
          color: AppColors.categoryCommunication,
          label: '통신',
        );
      case ExpenseCategory.other:
        return const _CategoryInfo(
          icon: Icons.more_horiz,
          color: AppColors.categoryOther,
          label: '기타',
        );
    }
  }
}

/// Internal class to hold category display information
class _CategoryInfo {
  final IconData icon;
  final Color color;
  final String label;

  const _CategoryInfo({
    required this.icon,
    required this.color,
    required this.label,
  });
}

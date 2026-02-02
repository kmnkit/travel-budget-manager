import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// A 2x4 grid of category selection buttons for expense categorization.
///
/// Shows all available expense categories with icons and labels.
/// Selected category is highlighted with teal background and white icon.
class CategoryGrid extends StatelessWidget {
  /// The currently selected category, if any
  final ExpenseCategory? selectedCategory;

  /// Callback when a category is selected
  final ValueChanged<ExpenseCategory> onCategorySelected;

  const CategoryGrid({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: ExpenseCategory.values.map((category) {
        final info = _getCategoryInfo(category);
        final isSelected = category == selectedCategory;

        return Semantics(
          label: '${info.label} category',
          selected: isSelected,
          button: true,
          child: Material(
            color: isSelected
                ? AppColors.primary
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => onCategorySelected(category),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    info.icon,
                    color: isSelected ? Colors.white : info.color,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : info.color,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Returns display information for a given expense category
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/quick_filter_providers.dart';

/// A horizontal scrollable row of FilterChip widgets for quick filtering
/// Two sections: Categories and Payment Methods
/// Multi-select supported (can select multiple categories and/or payment methods)
/// Shows "전체 초기화" (Clear All) chip when any filter is active
class QuickFilterChips extends ConsumerWidget {
  final List<String> availablePaymentMethods;

  const QuickFilterChips({
    super.key,
    required this.availablePaymentMethods,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filterState = ref.watch(quickFilterProvider);
    final filterNotifier = ref.read(quickFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category filter row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 16),
              // Clear all chip (only when filters active)
              if (filterState.hasActiveFilters)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Chip(
                    label: Text(l10n.clearAllFilters),
                    onDeleted: () => filterNotifier.clearAll(),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    backgroundColor: AppColors.surfaceVariant,
                  ),
                ),
              // Category chips
              ...ExpenseCategory.values.map((category) {
                final isSelected =
                    filterState.selectedCategories.contains(category);
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: FilterChip(
                    label: Text(category.labelKo),
                    selected: isSelected,
                    onSelected: (_) => filterNotifier.toggleCategory(category),
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textHint,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
            ],
          ),
        ),
        // Payment method filter row (only if payment methods exist)
        if (availablePaymentMethods.isNotEmpty) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 16),
                ...availablePaymentMethods.map((method) {
                  final isSelected =
                      filterState.selectedPaymentMethods.contains(method);
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: FilterChip(
                      label: Text(method),
                      selected: isSelected,
                      onSelected: (_) =>
                          filterNotifier.togglePaymentMethod(method),
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

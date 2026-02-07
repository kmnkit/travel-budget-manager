import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/ads/presentation/widgets/ad_banner_widget.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/presentation/providers/expense_providers.dart';
import 'package:trip_wallet/features/expense/presentation/widgets/expense_item_card.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';

enum _SortOrder {
  dateDesc('최신순'),
  amountDesc('금액순');

  final String label;
  const _SortOrder(this.label);
}

/// Expense list screen with filtering and sorting
class ExpenseListScreen extends ConsumerStatefulWidget {
  final int tripId;

  const ExpenseListScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  ExpenseCategory? _selectedCategory;
  _SortOrder _sortOrder = _SortOrder.dateDesc;

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseListProvider(widget.tripId));
    final tripAsync = ref.watch(tripDetailProvider(widget.tripId));

    return expensesAsync.when(
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => AppErrorWidget(
        message: '지출 목록을 불러올 수 없습니다',
        onRetry: () => ref.invalidate(expenseListProvider(widget.tripId)),
      ),
      data: (expenses) {
        if (expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  '지출을 기록해보세요!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
        }

        final baseCurrency = tripAsync.value?.baseCurrency ?? 'KRW';
        final filteredExpenses = _filterExpenses(expenses);
        final sortedExpenses = _sortExpenses(filteredExpenses);
        final groupedExpenses = _groupByDate(sortedExpenses);

        final shouldShowAds = ref.watch(shouldShowAdsProvider);

        // Fixed top banner (always 1) + interleave every 3 date groups
        const adInterval = 3;
        final dateGroupCount = groupedExpenses.length;
        final fixedAdCount = shouldShowAds ? 1 : 0;
        final interleaveAdCount =
            shouldShowAds ? (dateGroupCount ~/ adInterval) : 0;
        final totalItems =
            dateGroupCount + fixedAdCount + interleaveAdCount;

        return Column(
          children: [
            // Filter and sort bar
            _buildFilterBar(),
            const Divider(height: 1),

            // Expense list
            Expanded(
              child: ListView.builder(
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  // Index 0: fixed top banner ad
                  if (shouldShowAds && index == 0) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: AdBannerWidget(),
                    );
                  }

                  // Offset by 1 for the fixed banner
                  final adjustedIndex =
                      shouldShowAds ? index - 1 : index;

                  // Interleave ads every 3 date groups
                  final adsBefore = shouldShowAds
                      ? (adjustedIndex ~/ (adInterval + 1))
                          .clamp(0, interleaveAdCount)
                      : 0;
                  final groupIndex = adjustedIndex - adsBefore;

                  // Check if this position is an interleave ad slot
                  final isAdPosition = shouldShowAds &&
                      adsBefore < interleaveAdCount &&
                      (adjustedIndex + 1) % (adInterval + 1) == 0;

                  if (isAdPosition) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: AdBannerWidget(),
                    );
                  }

                  // Show date group
                  final entry =
                      groupedExpenses.entries.elementAt(groupIndex);
                  final date = entry.key;
                  final dayExpenses = entry.value;
                  final dailyTotal = dayExpenses.fold(
                    0.0,
                    (sum, expense) => sum + expense.convertedAmount,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header with daily total
                      _buildDateHeader(date, dailyTotal, baseCurrency),

                      // Expense items for this date
                      ...dayExpenses.map((expense) => _buildExpenseItem(
                            expense,
                            baseCurrency,
                          )),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Category filter
          Expanded(
            child: DropdownButton<ExpenseCategory?>(
              value: _selectedCategory,
              isExpanded: true,
              hint: const Text('전체'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('전체'),
                ),
                ...ExpenseCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_getCategoryLabel(category)),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),

          // Sort order
          DropdownButton<_SortOrder>(
            value: _sortOrder,
            items: _SortOrder.values.map((order) {
              return DropdownMenuItem(
                value: order,
                child: Text(order.label),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _sortOrder = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date, double dailyTotal, String currency) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${date.year}년 ${date.month}월 ${date.day}일',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            CurrencyFormatter.format(dailyTotal, currency),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense, String baseCurrency) {
    return Dismissible(
      key: Key('expense_${expense.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _showDeleteConfirmation(expense),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ExpenseItemCard(
        category: expense.category,
        memo: expense.memo,
        amount: expense.amount,
        currency: expense.currency,
        convertedAmount: expense.convertedAmount,
        baseCurrency: baseCurrency,
        onTap: () => context.go('/trip/${widget.tripId}/expense/${expense.id}'),
      ),
    );
  }

  List<Expense> _filterExpenses(List<Expense> expenses) {
    if (_selectedCategory == null) return expenses;
    return expenses.where((e) => e.category == _selectedCategory).toList();
  }

  List<Expense> _sortExpenses(List<Expense> expenses) {
    final sorted = List<Expense>.from(expenses);
    switch (_sortOrder) {
      case _SortOrder.dateDesc:
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
      case _SortOrder.amountDesc:
        sorted.sort((a, b) => b.convertedAmount.compareTo(a.convertedAmount));
        break;
    }
    return sorted;
  }

  Map<DateTime, List<Expense>> _groupByDate(List<Expense> expenses) {
    final grouped = <DateTime, List<Expense>>{};
    for (final expense in expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      grouped.putIfAbsent(date, () => []).add(expense);
    }
    return grouped;
  }

  String _getCategoryLabel(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return '식비';
      case ExpenseCategory.transport:
        return '교통';
      case ExpenseCategory.accommodation:
        return '숙박';
      case ExpenseCategory.shopping:
        return '쇼핑';
      case ExpenseCategory.entertainment:
        return '오락';
      case ExpenseCategory.sightseeing:
        return '관광';
      case ExpenseCategory.communication:
        return '통신';
      case ExpenseCategory.other:
        return '기타';
    }
  }

  Future<bool?> _showDeleteConfirmation(Expense expense) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지출 삭제'),
        content: Text('${expense.memo ?? _getCategoryLabel(expense.category)}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(expenseNotifierProvider.notifier)
                  .deleteExpense(expense.id);
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

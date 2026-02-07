import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

/// State for quick filters
class QuickFilterState {
  final Set<ExpenseCategory> selectedCategories;
  final Set<String> selectedPaymentMethods;

  const QuickFilterState({
    this.selectedCategories = const {},
    this.selectedPaymentMethods = const {},
  });

  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty || selectedPaymentMethods.isNotEmpty;

  QuickFilterState copyWith({
    Set<ExpenseCategory>? selectedCategories,
    Set<String>? selectedPaymentMethods,
  }) =>
      QuickFilterState(
        selectedCategories: selectedCategories ?? this.selectedCategories,
        selectedPaymentMethods:
            selectedPaymentMethods ?? this.selectedPaymentMethods,
      );
}

/// Notifier for managing quick filters (Riverpod v3 - use Notifier, NOT StateNotifier)
class QuickFilterNotifier extends Notifier<QuickFilterState> {
  @override
  QuickFilterState build() => const QuickFilterState();

  void toggleCategory(ExpenseCategory category) {
    final current = Set<ExpenseCategory>.from(state.selectedCategories);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    state = state.copyWith(selectedCategories: current);
  }

  void togglePaymentMethod(String method) {
    final current = Set<String>.from(state.selectedPaymentMethods);
    if (current.contains(method)) {
      current.remove(method);
    } else {
      current.add(method);
    }
    state = state.copyWith(selectedPaymentMethods: current);
  }

  void clearAll() {
    state = const QuickFilterState();
  }
}

final quickFilterProvider =
    NotifierProvider<QuickFilterNotifier, QuickFilterState>(
  QuickFilterNotifier.new,
);

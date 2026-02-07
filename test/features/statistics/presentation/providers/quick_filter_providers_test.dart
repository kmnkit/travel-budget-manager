import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/quick_filter_providers.dart';

void main() {
  group('QuickFilterState', () {
    test('initial state has empty filters', () {
      const state = QuickFilterState();
      expect(state.selectedCategories, isEmpty);
      expect(state.selectedPaymentMethods, isEmpty);
    });

    test('hasActiveFilters returns false initially', () {
      const state = QuickFilterState();
      expect(state.hasActiveFilters, false);
    });

    test('hasActiveFilters returns true when categories selected', () {
      const state = QuickFilterState(
        selectedCategories: {ExpenseCategory.food},
      );
      expect(state.hasActiveFilters, true);
    });

    test('hasActiveFilters returns true when payment methods selected', () {
      const state = QuickFilterState(
        selectedPaymentMethods: {'Cash'},
      );
      expect(state.hasActiveFilters, true);
    });

    test('copyWith creates new instance with updated values', () {
      const state = QuickFilterState();
      final updated = state.copyWith(
        selectedCategories: {ExpenseCategory.food},
      );

      expect(updated.selectedCategories, {ExpenseCategory.food});
      expect(updated.selectedPaymentMethods, isEmpty);
    });
  });

  group('QuickFilterNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('toggleCategory adds category when not selected', () {
      final notifier = container.read(quickFilterProvider.notifier);

      notifier.toggleCategory(ExpenseCategory.food);

      final state = container.read(quickFilterProvider);
      expect(state.selectedCategories, {ExpenseCategory.food});
    });

    test('toggleCategory removes already-selected category', () {
      final notifier = container.read(quickFilterProvider.notifier);

      // Add category first
      notifier.toggleCategory(ExpenseCategory.food);
      // Then remove it
      notifier.toggleCategory(ExpenseCategory.food);

      final state = container.read(quickFilterProvider);
      expect(state.selectedCategories, isEmpty);
    });

    test('multiple categories can be selected', () {
      final notifier = container.read(quickFilterProvider.notifier);

      notifier.toggleCategory(ExpenseCategory.food);
      notifier.toggleCategory(ExpenseCategory.transport);
      notifier.toggleCategory(ExpenseCategory.shopping);

      final state = container.read(quickFilterProvider);
      expect(state.selectedCategories, {
        ExpenseCategory.food,
        ExpenseCategory.transport,
        ExpenseCategory.shopping,
      });
    });

    test('togglePaymentMethod adds method when not selected', () {
      final notifier = container.read(quickFilterProvider.notifier);

      notifier.togglePaymentMethod('Cash');

      final state = container.read(quickFilterProvider);
      expect(state.selectedPaymentMethods, {'Cash'});
    });

    test('togglePaymentMethod removes already-selected method', () {
      final notifier = container.read(quickFilterProvider.notifier);

      // Add method first
      notifier.togglePaymentMethod('Cash');
      // Then remove it
      notifier.togglePaymentMethod('Cash');

      final state = container.read(quickFilterProvider);
      expect(state.selectedPaymentMethods, isEmpty);
    });

    test('multiple payment methods can be selected', () {
      final notifier = container.read(quickFilterProvider.notifier);

      notifier.togglePaymentMethod('Cash');
      notifier.togglePaymentMethod('Credit Card');
      notifier.togglePaymentMethod('Debit Card');

      final state = container.read(quickFilterProvider);
      expect(state.selectedPaymentMethods, {
        'Cash',
        'Credit Card',
        'Debit Card',
      });
    });

    test('mixed filters (both categories and payment methods)', () {
      final notifier = container.read(quickFilterProvider.notifier);

      notifier.toggleCategory(ExpenseCategory.food);
      notifier.toggleCategory(ExpenseCategory.transport);
      notifier.togglePaymentMethod('Cash');
      notifier.togglePaymentMethod('Credit Card');

      final state = container.read(quickFilterProvider);
      expect(state.selectedCategories, {
        ExpenseCategory.food,
        ExpenseCategory.transport,
      });
      expect(state.selectedPaymentMethods, {
        'Cash',
        'Credit Card',
      });
      expect(state.hasActiveFilters, true);
    });

    test('clearAll resets to empty state', () {
      final notifier = container.read(quickFilterProvider.notifier);

      // Add some filters
      notifier.toggleCategory(ExpenseCategory.food);
      notifier.togglePaymentMethod('Cash');

      // Clear all
      notifier.clearAll();

      final state = container.read(quickFilterProvider);
      expect(state.selectedCategories, isEmpty);
      expect(state.selectedPaymentMethods, isEmpty);
      expect(state.hasActiveFilters, false);
    });
  });
}

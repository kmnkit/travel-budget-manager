import 'package:freezed_annotation/freezed_annotation.dart';
import 'expense_category.dart';

part 'expense.freezed.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required int id,
    required int tripId,
    required double amount,
    required String currency,
    required double convertedAmount,
    required ExpenseCategory category,
    required int paymentMethodId,
    String? memo,
    required DateTime date,
    required DateTime createdAt,
  }) = _Expense;
}

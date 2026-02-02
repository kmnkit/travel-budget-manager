import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';

/// A horizontal scrollable row of payment method selection chips.
///
/// Displays all available payment methods as choice chips with icons.
/// Selected chip is filled with teal color, unselected chips are outlined.
class PaymentMethodChips extends StatelessWidget {
  /// List of available payment methods
  final List<PaymentMethod> paymentMethods;

  /// ID of the currently selected payment method
  final int? selectedId;

  /// Callback when a payment method is selected
  final ValueChanged<PaymentMethod> onSelected;

  const PaymentMethodChips({
    super.key,
    required this.paymentMethods,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Payment method selector',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: paymentMethods.map((method) {
            final isSelected = method.id == selectedId;
            final icon = _getIconForType(method.type);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Semantics(
                label: '${method.name} payment method',
                selected: isSelected,
                button: true,
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(method.name),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => onSelected(method),
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.transparent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5),
                    width: isSelected ? 0 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  showCheckmark: false,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Returns the appropriate icon for a payment method type
  IconData _getIconForType(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.cash:
        return Icons.money;
      case PaymentMethodType.creditCard:
        return Icons.credit_card;
      case PaymentMethodType.debitCard:
        return Icons.payment;
      case PaymentMethodType.transitCard:
        return Icons.directions_bus;
      case PaymentMethodType.other:
        return Icons.account_balance_wallet;
    }
  }
}

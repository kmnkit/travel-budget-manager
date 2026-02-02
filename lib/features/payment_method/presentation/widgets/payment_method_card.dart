import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';

/// Card widget displaying a single payment method.
///
/// Shows:
/// - Icon based on payment method type
/// - Payment method name
/// - Type label in Korean
/// - "기본" badge if it's the default payment method
/// - Edit and delete action buttons
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.onEdit,
    required this.onDelete,
    this.onSetDefault,
  });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: paymentMethod.isDefault
            ? BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForType(paymentMethod.type),
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Name and type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        paymentMethod.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (paymentMethod.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '기본',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    paymentMethod.type.labelKo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onSetDefault != null)
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    tooltip: '기본으로 설정',
                    onPressed: onSetDefault,
                    color: AppColors.primary,
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: '수정',
                  onPressed: onEdit,
                  color: AppColors.primary,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '삭제',
                  onPressed: paymentMethod.isDefault ? null : onDelete,
                  color: paymentMethod.isDefault ? Colors.grey : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

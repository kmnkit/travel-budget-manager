import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';

/// Data class for payment method form results
class PaymentMethodFormData {
  final String name;
  final PaymentMethodType type;
  final bool isDefault;

  const PaymentMethodFormData({
    required this.name,
    required this.type,
    required this.isDefault,
  });
}

/// Bottom sheet for adding or editing a payment method.
///
/// Shows form with:
/// - Name text field
/// - Type selector (choice chips)
/// - Default toggle switch
/// - Save/Cancel buttons
class PaymentMethodBottomSheet extends StatefulWidget {
  final PaymentMethod? paymentMethod;

  const PaymentMethodBottomSheet({
    super.key,
    this.paymentMethod,
  });

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  PaymentMethodType _selectedType = PaymentMethodType.cash;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      _nameController.text = widget.paymentMethod!.name;
      _selectedType = widget.paymentMethod!.type;
      _isDefault = widget.paymentMethod!.isDefault;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.paymentMethod != null;

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = PaymentMethodFormData(
      name: _nameController.text.trim(),
      type: _selectedType,
      isDefault: _isDefault,
    );

    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                _isEditMode ? '지불수단 수정' : '지불수단 추가',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: '예: 신한카드, 교통카드',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
                autofocus: !_isEditMode,
              ),
              const SizedBox(height: 24),

              // Type selector
              Text(
                '종류',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PaymentMethodType.values.map((type) {
                  final isSelected = type == _selectedType;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type.icon,
                          size: 18,
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(type.labelKo),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.transparent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.5),
                      width: isSelected ? 0 : 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Default toggle
              SwitchListTile(
                title: const Text('기본 지불수단으로 설정'),
                subtitle: const Text('새 지출 추가 시 자동으로 선택됩니다'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
                activeTrackColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(_isEditMode ? '수정' : '추가'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

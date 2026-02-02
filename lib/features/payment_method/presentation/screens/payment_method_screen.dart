import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/presentation/providers/payment_method_providers.dart';
import 'package:trip_wallet/features/payment_method/data/datasources/payment_method_local_datasource.dart';
import 'package:trip_wallet/features/payment_method/presentation/widgets/payment_method_bottom_sheet.dart';
import 'package:trip_wallet/features/payment_method/presentation/widgets/payment_method_card.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';

/// Screen for managing payment methods.
///
/// Shows list of all payment methods with ability to:
/// - Add new payment methods via bottom sheet
/// - Edit existing payment methods
/// - Delete payment methods (except default)
/// - Set default payment method
class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  Future<void> _showAddBottomSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<PaymentMethodFormData>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const PaymentMethodBottomSheet(),
    );

    if (result != null && context.mounted) {
      await _createPaymentMethod(context, ref, result);
    }
  }

  Future<void> _showEditBottomSheet(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod method,
  ) async {
    final result = await showModalBottomSheet<PaymentMethodFormData>(
      context: context,
      isScrollControlled: true,
      builder: (context) => PaymentMethodBottomSheet(paymentMethod: method),
    );

    if (result != null && context.mounted) {
      await _updatePaymentMethod(context, ref, method.id, result);
    }
  }

  Future<void> _createPaymentMethod(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodFormData data,
  ) async {
    try {
      final useCase = ref.read(createPaymentMethodProvider);
      await useCase(
        name: data.name,
        type: data.type,
      );

      // Invalidate to refresh list
      ref.invalidate(paymentMethodListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('지불수단이 추가되었습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('추가 실패: $e')),
        );
      }
    }
  }

  Future<void> _updatePaymentMethod(
    BuildContext context,
    WidgetRef ref,
    int id,
    PaymentMethodFormData data,
  ) async {
    try {
      final datasource = ref.read(paymentMethodLocalDatasourceProvider);
      final updated = PaymentMethod(
        id: id,
        name: data.name,
        type: data.type,
        isDefault: data.isDefault,
        createdAt: DateTime.now(), // Will be ignored in update
      );
      await datasource.updatePaymentMethod(updated);

      // Invalidate to refresh list
      ref.invalidate(paymentMethodListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('지불수단이 수정되었습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정 실패: $e')),
        );
      }
    }
  }

  Future<void> _deletePaymentMethod(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod method,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지불수단 삭제'),
        content: Text('${method.name}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final useCase = ref.read(deletePaymentMethodProvider);
        await useCase(method.id);

        // Invalidate to refresh list
        ref.invalidate(paymentMethodListProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('지불수단이 삭제되었습니다')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: $e')),
          );
        }
      }
    }
  }

  Future<void> _setDefault(
    BuildContext context,
    WidgetRef ref,
    PaymentMethod method,
  ) async {
    try {
      final datasource = ref.read(paymentMethodLocalDatasourceProvider);
      await datasource.setDefault(method.id);

      // Invalidate to refresh list
      ref.invalidate(paymentMethodListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${method.name}을(를) 기본 지불수단으로 설정했습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('설정 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethodsAsync = ref.watch(paymentMethodListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('지불수단 관리'),
      ),
      body: paymentMethodsAsync.when(
        data: (methods) {
          if (methods.isEmpty) {
            return const Center(
              child: Text('지불수단이 없습니다'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PaymentMethodCard(
                  paymentMethod: method,
                  onEdit: () => _showEditBottomSheet(context, ref, method),
                  onDelete: () => _deletePaymentMethod(context, ref, method),
                  onSetDefault: method.isDefault
                      ? null
                      : () => _setDefault(context, ref, method),
                ),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => Center(
          child: Text('로드 실패: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBottomSheet(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('지불수단 추가'),
      ),
    );
  }
}

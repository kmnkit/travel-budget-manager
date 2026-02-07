import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/extensions/context_extensions.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/premium/presentation/providers/iap_providers.dart';
import 'package:trip_wallet/features/premium/presentation/widgets/feature_list_item.dart';

/// Dialog for quick premium upgrade prompts
class PremiumDialog extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final List<String> features;
  final String? buttonText;
  final VoidCallback? onDismiss;

  const PremiumDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.features,
    this.buttonText,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final purchaseState = ref.watch(purchaseStateNotifierProvider);
    final isPurchasing = purchaseState.when(
      data: (value) => false,
      loading: () => true,
      error: (error, stack) => false,
    );

    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.workspace_premium,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
            ],
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FeatureListItem(
                  title: feature,
                  icon: Icons.check_circle,
                  iconColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss ?? () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),
          child: Text(l10n.later),
        ),
        FilledButton(
          onPressed: isPurchasing
              ? null
              : () async {
                  await ref
                      .read(purchaseStateNotifierProvider.notifier)
                      .purchasePremium();
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isPurchasing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(buttonText ?? l10n.upgrade),
        ),
      ],
    );
  }

  /// Show this dialog
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? subtitle,
    required List<String> features,
    String? buttonText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => PremiumDialog(
        title: title,
        subtitle: subtitle,
        features: features,
        buttonText: buttonText,
      ),
    );
  }
}

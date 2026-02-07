import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/consent_providers.dart';
import '../widgets/privacy_policy_content.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ConsentScreen extends ConsumerWidget {
  static const String _policyVersion = '1.0.0';
  final VoidCallback onConsentGiven;

  const ConsentScreen({
    super.key,
    required this.onConsentGiven,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Icon
              Icon(
                Icons.privacy_tip,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                l10n.consentTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                l10n.consentDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Policy preview (scrollable)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: PrivacyPolicyContent(scrollable: true),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Accept button
              FilledButton(
                onPressed: () => _handleAccept(context, ref),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.consentAccept),
              ),
              const SizedBox(height: 12),
              // Decline button
              OutlinedButton(
                onPressed: () => _handleDecline(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.consentDecline),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAccept(BuildContext context, WidgetRef ref) async {
    try {
      final repository = ref.read(consentRepositoryProvider);

      // Save consent with current version
      await repository.setConsentAccepted(_policyVersion);

      // Invalidate provider to trigger reload
      ref.invalidate(consentRecordProvider);

      // Call callback
      onConsentGiven();
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.consentSaveError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleDecline(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.consentDeclineTitle),
        content: Text(l10n.consentDeclineMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.consentDeclineUnderstand),
          ),
        ],
      ),
    );
  }
}

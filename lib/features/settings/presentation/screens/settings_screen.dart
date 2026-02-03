import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/constants/app_constants.dart';
import 'package:trip_wallet/core/constants/currency_constants.dart';
import 'package:trip_wallet/core/extensions/context_extensions.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(localeProvider);
    final defaultCurrency = ref.watch(defaultCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General section
          _buildSectionLabel(theme, context.l10n.general),
          const SizedBox(height: 8),
          _buildSectionCard(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(context.l10n.language),
                subtitle: Text(
                  locale.languageCode == 'ko' ? context.l10n.languageKorean : context.l10n.languageEnglish,
                ),
                trailing: Switch(
                  value: locale.languageCode == 'en',
                  onChanged: (value) {
                    final newLocale = value ? const Locale('en') : const Locale('ko');
                    ref.read(localeProvider.notifier).setLocale(newLocale);
                  },
                  activeTrackColor: AppColors.primary,
                ),
                onTap: () {
                  final currentIsEn = locale.languageCode == 'en';
                  final newLocale = currentIsEn ? const Locale('ko') : const Locale('en');
                  ref.read(localeProvider.notifier).setLocale(newLocale);
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: Text(context.l10n.defaultCurrency),
                subtitle: Text(
                  _currencyName(SupportedCurrency.fromCode(defaultCurrency), locale),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyPicker(context, ref, defaultCurrency, locale),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data section
          _buildSectionLabel(theme, context.l10n.data),
          const SizedBox(height: 8),
          _buildSectionCard(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: Text(context.l10n.backup),
                subtitle: Text(context.l10n.comingSoon),
                enabled: false,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.cloud_download),
                title: Text(context.l10n.restore),
                subtitle: Text(context.l10n.comingSoon),
                enabled: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Info section
          _buildSectionLabel(theme, context.l10n.info),
          const SizedBox(height: 8),
          _buildSectionCard(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(context.l10n.version),
                subtitle: const Text('1.0.0'),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.policy),
                title: Text(context.l10n.privacyPolicy),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.comingSoon)),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(context.l10n.licenses),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'TripWallet',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
            ],
          ),

          // Footer
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Made with ♥ by TripWallet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  String _currencyName(SupportedCurrency currency, Locale locale) {
    return locale.languageCode == 'ko' ? currency.nameKo : currency.nameEn;
  }

  Future<void> _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    String currentCurrency,
    Locale locale,
  ) async {
    final selectedCurrency = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.selectDefaultCurrency),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SupportedCurrency.values.length,
            itemBuilder: (context, index) {
              final currency = SupportedCurrency.values[index];
              final isSelected = currency.code == currentCurrency;

              return ListTile(
                title: Text(_currencyName(currency, locale)),
                subtitle: Text('${currency.code} (${currency.symbol})'),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                selected: isSelected,
                onTap: () => Navigator.pop(context, currency.code),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
        ],
      ),
    );

    if (selectedCurrency != null) {
      ref.read(defaultCurrencyProvider.notifier).setCurrency(selectedCurrency);
    }
  }
}

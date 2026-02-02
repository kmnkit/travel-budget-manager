import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/constants/app_constants.dart';
import 'package:trip_wallet/core/constants/currency_constants.dart';
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
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General section
          _buildSectionLabel(theme, '일반'),
          const SizedBox(height: 8),
          _buildSectionCard(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('언어'),
                subtitle: Text(
                  locale.languageCode == 'ko' ? '한국어' : 'English',
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
                title: const Text('기본 통화'),
                subtitle: Text(
                  SupportedCurrency.fromCode(defaultCurrency).nameKo,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyPicker(context, ref, defaultCurrency),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data section
          _buildSectionLabel(theme, '데이터'),
          const SizedBox(height: 8),
          _buildSectionCard(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('백업'),
                subtitle: const Text('준비 중'),
                enabled: false,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.cloud_download),
                title: const Text('복원'),
                subtitle: const Text('준비 중'),
                enabled: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Info section
          _buildSectionLabel(theme, '정보'),
          const SizedBox(height: 8),
          _buildSectionCard(
            children: [
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('버전'),
                subtitle: Text('1.0.0'),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.policy),
                title: const Text('개인정보 처리방침'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('준비 중입니다')),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('오픈소스 라이선스'),
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

  Future<void> _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    String currentCurrency,
  ) async {
    final selectedCurrency = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기본 통화 선택'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SupportedCurrency.values.length,
            itemBuilder: (context, index) {
              final currency = SupportedCurrency.values[index];
              final isSelected = currency.code == currentCurrency;

              return ListTile(
                title: Text(currency.nameKo),
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
            child: const Text('취소'),
          ),
        ],
      ),
    );

    if (selectedCurrency != null) {
      ref.read(defaultCurrencyProvider.notifier).setCurrency(selectedCurrency);
    }
  }
}

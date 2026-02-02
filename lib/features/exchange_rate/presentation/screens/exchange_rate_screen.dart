import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/exchange_rate/presentation/providers/exchange_rate_providers.dart';
import 'package:trip_wallet/features/exchange_rate/presentation/widgets/auto_manual_toggle.dart';
import 'package:trip_wallet/features/exchange_rate/presentation/widgets/exchange_rate_card.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';

/// Screen displaying exchange rates for a trip
class ExchangeRateScreen extends ConsumerWidget {
  final int tripId;
  final String baseCurrency;

  const ExchangeRateScreen({
    super.key,
    required this.tripId,
    required this.baseCurrency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(exchangeRateModeProvider);
    final ratesAsync = ref.watch(tripExchangeRatesProvider(tripId));

    return Scaffold(
      body: Column(
        children: [
          // Top controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Mode toggle
                AutoManualToggle(
                  selectedMode: mode,
                  onModeChanged: (newMode) {
                    ref.read(exchangeRateModeProvider.notifier).setMode(newMode);
                  },
                ),
                // Refresh button for auto mode
                if (mode == ExchangeRateMode.auto) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.invalidate(fetchRatesProvider(baseCurrency));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('환율 새로고침'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Exchange rates list
          Expanded(
            child: ratesAsync.when(
              data: (rates) {
                if (rates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '등록된 환율이 없습니다',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        if (mode == ExchangeRateMode.auto) ...[
                          const SizedBox(height: 8),
                          Text(
                            '환율을 가져오려면 새로고침 버튼을 눌러주세요',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textHint,
                                ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: rates.length,
                  itemBuilder: (context, index) {
                    final rate = rates[index];
                    return ExchangeRateCard(
                      exchangeRate: rate,
                      isManual: mode == ExchangeRateMode.manual,
                      onRateChanged: (newRate) {
                        // TODO: Implement rate update logic
                        // This would call a use case to update the manual rate
                      },
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(message: '환율 정보를 불러오는 중...'),
              error: (error, stack) => AppErrorWidget(
                message: '환율 정보를 불러올 수 없습니다\n${error.toString()}',
                onRetry: () {
                  ref.invalidate(tripExchangeRatesProvider(tripId));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

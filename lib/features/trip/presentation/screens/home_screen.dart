import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/core/extensions/context_extensions.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';
import 'package:trip_wallet/features/ads/presentation/widgets/ad_banner_widget.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/features/trip/presentation/widgets/empty_trip_state.dart';
import 'package:trip_wallet/features/trip/presentation/widgets/trip_card.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTrips = ref.watch(filteredTripListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_wallet, size: 24),
            const SizedBox(width: 8),
            const Text('TripWallet'),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: context.l10n.settings,
          ),
        ],
      ),
      body: Column(
        children: [
          const _TotalBalanceBanner(),
          const _FilterChips(),
          Expanded(
            child: filteredTrips.when(
              loading: () => const LoadingIndicator(),
              error: (error, stack) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(tripListProvider),
              ),
              data: (trips) {
                if (trips.isEmpty) {
                  return const EmptyTripState();
                }

                final shouldShowAds = ref.watch(shouldShowAdsProvider);

                // Fixed top banner (always 1) + interleave every 4 trips
                const adInterval = 4;
                final fixedAdCount = shouldShowAds ? 1 : 0;
                final interleaveAdCount = shouldShowAds
                    ? (trips.length ~/ adInterval)
                    : 0;
                final totalItems =
                    trips.length + fixedAdCount + interleaveAdCount;

                return ListView.builder(
                  itemCount: totalItems,
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemBuilder: (context, index) {
                    // Index 0: fixed top banner ad
                    if (shouldShowAds && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: AdBannerWidget(),
                      );
                    }

                    // Offset by 1 for the fixed banner
                    final adjustedIndex = shouldShowAds ? index - 1 : index;

                    // Interleave ads every 4 trips
                    final adsBefore = shouldShowAds
                        ? (adjustedIndex ~/ (adInterval + 1)).clamp(
                            0,
                            interleaveAdCount,
                          )
                        : 0;
                    final tripIndex = adjustedIndex - adsBefore;

                    // Check if this position is an interleave ad slot
                    final isAdPosition =
                        shouldShowAds &&
                        adsBefore < interleaveAdCount &&
                        (adjustedIndex + 1) % (adInterval + 1) == 0;

                    if (isAdPosition) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: AdBannerWidget(),
                      );
                    }

                    // Show trip card
                    return TripCard(trip: trips[tripIndex]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/trip/create'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TotalBalanceBanner extends ConsumerWidget {
  const _TotalBalanceBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(totalBalanceProvider);

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: balanceAsync.when(
        loading: () => const SizedBox(
          height: 48,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
        ),
        error: (_, _) => const SizedBox.shrink(),
        data: (balance) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.totalBalance,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  CurrencyFormatter.format(balance.total, balance.currency),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  balance.currency,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(tripFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: TripFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_filterLabel(context, filter)),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) =>
                  ref.read(tripFilterProvider.notifier).setFilter(filter),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(BuildContext context, TripFilter filter) {
    switch (filter) {
      case TripFilter.all:
        return context.l10n.filterAllTrips;
      case TripFilter.active:
        return context.l10n.filterActive;
      case TripFilter.past:
        return context.l10n.filterPast;
    }
  }
}

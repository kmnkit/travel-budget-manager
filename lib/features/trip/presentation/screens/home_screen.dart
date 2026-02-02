import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/features/trip/presentation/widgets/empty_trip_state.dart';
import 'package:trip_wallet/features/trip/presentation/widgets/trip_card.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripListProvider);

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
            onPressed: () => context.go('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: tripsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(tripListProvider),
        ),
        data: (trips) {
          if (trips.isEmpty) {
            return const EmptyTripState();
          }

          return ListView.builder(
            itemCount: trips.length,
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemBuilder: (context, index) {
              return TripCard(trip: trips[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/trip/create'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

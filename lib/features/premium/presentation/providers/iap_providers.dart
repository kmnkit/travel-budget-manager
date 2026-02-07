import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:trip_wallet/features/premium/data/datasources/iap_datasource.dart';
import 'package:trip_wallet/features/premium/data/datasources/premium_local_datasource.dart';
import 'package:trip_wallet/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

/// Provider for IAP datasource
final iapDatasourceProvider = Provider<IapDatasource>((ref) {
  final datasource = IapDatasourceImpl();
  ref.onDispose(() {
    datasource.dispose();
  });
  return datasource;
});

/// Provider for premium repository with IAP support
final premiumRepositoryWithIapProvider = Provider<PremiumRepositoryImpl>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  final localDatasource = PremiumLocalDatasourceImpl(sharedPreferences);
  final iapDatasource = ref.watch(iapDatasourceProvider);

  return PremiumRepositoryImpl(
    localDatasource,
    iapDatasource: iapDatasource,
  );
});

/// Stream provider for purchase updates
/// Listens to IAP purchase stream and handles purchase completion
final purchaseStreamProvider = StreamProvider<List<PurchaseDetails>>((ref) {
  final iapDatasource = ref.watch(iapDatasourceProvider);
  final repository = ref.watch(premiumRepositoryWithIapProvider);

  // Listen to purchase stream and handle updates
  return iapDatasource.purchaseStream.asyncMap((purchases) async {
    for (final purchase in purchases) {
      await repository.handlePurchaseUpdate(purchase);
    }

    // Invalidate premium status to refresh UI
    ref.invalidate(premiumStatusProvider);

    return purchases;
  });
});

/// State notifier for managing purchase state
class PurchaseStateNotifier extends Notifier<AsyncValue<bool>> {
  late final PremiumRepositoryImpl repository;

  @override
  AsyncValue<bool> build() {
    repository = ref.watch(premiumRepositoryWithIapProvider);

    // Start listening to purchase stream
    ref.listen(purchaseStreamProvider, (previous, next) {
      next.when(
        data: (purchases) {
          // Check if any purchase was successful
          final hasSuccessful = purchases.any(
            (p) => p.status == PurchaseStatus.purchased ||
                   p.status == PurchaseStatus.restored,
          );
          if (hasSuccessful) {
            state = const AsyncValue.data(true);
          }

          // Check for errors
          final hasError = purchases.any((p) => p.status == PurchaseStatus.error);
          if (hasError) {
            final errorPurchase = purchases.firstWhere((p) => p.status == PurchaseStatus.error);
            state = AsyncValue.error(
              errorPurchase.error ?? Exception('Purchase failed'),
              StackTrace.current,
            );
          }
        },
        loading: () {
          // Keep current state during loading
        },
        error: (error, stack) {
          state = AsyncValue.error(error, stack);
        },
      );
    });

    return const AsyncValue.data(false);
  }

  /// Start premium purchase flow
  Future<void> purchasePremium() async {
    state = const AsyncValue.loading();
    try {
      final success = await repository.startPremiumPurchase();
      if (!success) {
        state = AsyncValue.error(
          Exception('Failed to start purchase'),
          StackTrace.current,
        );
      }
      // State will be updated by purchase stream listener
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    state = const AsyncValue.loading();
    try {
      final success = await repository.restorePurchases();
      if (!success) {
        state = AsyncValue.error(
          Exception('Failed to restore purchases'),
          StackTrace.current,
        );
      }
      // State will be updated by purchase stream listener
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Notifier provider for purchase flow
final purchaseStateNotifierProvider =
    NotifierProvider<PurchaseStateNotifier, AsyncValue<bool>>(
  PurchaseStateNotifier.new,
);

/// Future provider for IAP product details
final iapProductDetailsProvider = FutureProvider<ProductDetails?>((ref) async {
  final repository = ref.watch(premiumRepositoryWithIapProvider);
  return await repository.getProductDetails();
});

/// Future provider for IAP availability
final iapAvailableProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(premiumRepositoryWithIapProvider);
  return await repository.isIapAvailable();
});

/// Computed provider: is purchase in progress
final isPurchaseInProgressProvider = Provider<bool>((ref) {
  final purchaseState = ref.watch(purchaseStateNotifierProvider);
  return purchaseState.isLoading;
});

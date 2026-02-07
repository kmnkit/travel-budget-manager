import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/premium/data/datasources/premium_local_datasource.dart';
import 'package:trip_wallet/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';
import 'package:trip_wallet/features/premium/domain/repositories/premium_repository.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

// Data source provider
final premiumLocalDataSourceProvider = Provider<PremiumLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PremiumLocalDatasourceImpl(prefs);
});

// Repository provider
final premiumRepositoryProvider = Provider<PremiumRepository>((ref) {
  final dataSource = ref.watch(premiumLocalDataSourceProvider);
  return PremiumRepositoryImpl(dataSource);
});

// Premium status provider (FutureProvider for one-time check)
final premiumStatusProvider = FutureProvider<PremiumStatus>((ref) async {
  final repository = ref.watch(premiumRepositoryProvider);
  return repository.getPremiumStatus();
});

// Computed provider: should show ads (opposite of premium)
final shouldShowAdsProvider = Provider<bool>((ref) {
  final premiumAsync = ref.watch(premiumStatusProvider);
  return premiumAsync.when(
    data: (status) => !status.isPremium || status.isExpired,  // Show ads if NOT premium or expired
    loading: () => true,               // Show ads by default until premium confirmed
    error: (error, stack) => true,     // Show ads on error (fallback)
  );
});

// Quick check provider (for UI that needs immediate status)
final isPremiumActiveProvider = Provider<bool>((ref) {
  final premiumAsync = ref.watch(premiumStatusProvider);
  return premiumAsync.when(
    data: (status) => status.isPremium && !status.isExpired,
    loading: () => false,
    error: (error, stack) => false,
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/ads/data/datasources/ad_datasource.dart';
import 'package:trip_wallet/features/ads/data/repositories/ad_repository_impl.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';

/// Provider for ad datasource
final adDatasourceProvider = Provider<AdDatasource>((ref) {
  return AdDatasourceImpl();
});

/// Provider for ad repository
final adRepositoryProvider = Provider<AdRepository>((ref) {
  final datasource = ref.watch(adDatasourceProvider);
  return AdRepositoryImpl(datasource);
});

/// Future provider for banner ad config
final bannerAdConfigProvider = FutureProvider<AdConfig>((ref) async {
  final repository = ref.watch(adRepositoryProvider);
  return await repository.getAdConfig(AdType.banner);
});

/// Future provider for interstitial ad config
final interstitialAdConfigProvider = FutureProvider<AdConfig>((ref) async {
  final repository = ref.watch(adRepositoryProvider);
  return await repository.getAdConfig(AdType.interstitial);
});

/// Future provider for rewarded ad config
final rewardedAdConfigProvider = FutureProvider<AdConfig>((ref) async {
  final repository = ref.watch(adRepositoryProvider);
  return await repository.getAdConfig(AdType.rewarded);
});

/// Future provider for all ad configs
final allAdConfigsProvider = FutureProvider<List<AdConfig>>((ref) async {
  final repository = ref.watch(adRepositoryProvider);
  return await repository.getAllAdConfigs();
});

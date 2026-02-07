import 'package:trip_wallet/features/ads/data/datasources/ad_datasource.dart';
import 'package:trip_wallet/features/ads/data/helpers/ad_helper.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';

class AdRepositoryImpl implements AdRepository {
  final AdDatasource _datasource;

  AdRepositoryImpl(this._datasource);

  @override
  Future<AdConfig> getAdConfig(AdType adType) async {
    return AdHelper.createAdConfig(adType, useTestAds: true);
  }

  @override
  Future<List<AdConfig>> getAllAdConfigs() async {
    return AdHelper.createAllAdConfigs(useTestAds: true);
  }

  @override
  Future<void> loadBannerAd(AdConfig config) async {
    return await _datasource.loadBannerAd(config);
  }

  @override
  Future<void> loadInterstitialAd(AdConfig config) async {
    return await _datasource.loadInterstitialAd(config);
  }

  @override
  Future<void> loadRewardedAd(AdConfig config) async {
    return await _datasource.loadRewardedAd(config);
  }

  @override
  Future<void> showInterstitialAd() async {
    return await _datasource.showInterstitialAd();
  }

  @override
  Future<void> showRewardedAd() async {
    return await _datasource.showRewardedAd();
  }

  @override
  Future<void> disposeAds() async {
    return await _datasource.disposeAds();
  }
}

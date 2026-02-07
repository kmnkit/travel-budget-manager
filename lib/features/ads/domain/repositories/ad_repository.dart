import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';

abstract class AdRepository {
  /// Get ad configuration for a specific ad type
  Future<AdConfig> getAdConfig(AdType adType);

  /// Get all ad configurations
  Future<List<AdConfig>> getAllAdConfigs();

  /// Load and display a banner ad
  Future<void> loadBannerAd(AdConfig config);

  /// Load and display an interstitial ad
  Future<void> loadInterstitialAd(AdConfig config);

  /// Load and display a rewarded ad
  Future<void> loadRewardedAd(AdConfig config);

  /// Show a loaded interstitial ad
  Future<void> showInterstitialAd();

  /// Show a loaded rewarded ad
  Future<void> showRewardedAd();

  /// Dispose all ad resources
  Future<void> disposeAds();
}

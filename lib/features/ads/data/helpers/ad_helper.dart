import 'dart:io';

import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';

/// Helper class for managing ad configurations with test and production IDs
class AdHelper {
  // Test Ad Unit IDs (from Google's sample app)
  // Android: https://developers.google.com/admob/android/test-ads
  // iOS: https://developers.google.com/admob/ios/test-ads
  static String get _testBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get _testInterstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String get _testRewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  // Production Ad Unit IDs (replace with actual IDs)
  static const String _productionBannerAdUnitId =
      'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  static const String _productionInterstitialAdUnitId =
      'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  static const String _productionRewardedAdUnitId =
      'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';

  /// Get ad unit ID for a specific ad type
  /// Returns test ID if [useTestAds] is true, otherwise returns production ID
  static String getAdUnitId(AdType type, {bool useTestAds = true}) {
    if (useTestAds) {
      return _getTestAdUnitId(type);
    }
    return _getProductionAdUnitId(type);
  }

  /// Get test ad unit ID for a specific type
  static String _getTestAdUnitId(AdType type) {
    switch (type) {
      case AdType.banner:
        return _testBannerAdUnitId;
      case AdType.interstitial:
        return _testInterstitialAdUnitId;
      case AdType.rewarded:
        return _testRewardedAdUnitId;
    }
  }

  /// Get production ad unit ID for a specific type
  static String _getProductionAdUnitId(AdType type) {
    switch (type) {
      case AdType.banner:
        return _productionBannerAdUnitId;
      case AdType.interstitial:
        return _productionInterstitialAdUnitId;
      case AdType.rewarded:
        return _productionRewardedAdUnitId;
    }
  }

  /// Create AdConfig with test or production IDs
  static AdConfig createAdConfig(
    AdType type, {
    bool useTestAds = true,
    bool isEnabled = true,
  }) {
    return AdConfig(
      type: type,
      unitId: getAdUnitId(type, useTestAds: useTestAds),
      isTestAd: useTestAds,
      isEnabled: isEnabled,
    );
  }

  /// Create all ad configurations
  static List<AdConfig> createAllAdConfigs({
    bool useTestAds = true,
    bool isEnabled = true,
  }) {
    return [
      createAdConfig(AdType.banner, useTestAds: useTestAds, isEnabled: isEnabled),
      createAdConfig(AdType.interstitial,
          useTestAds: useTestAds, isEnabled: isEnabled),
      createAdConfig(AdType.rewarded,
          useTestAds: useTestAds, isEnabled: isEnabled),
    ];
  }
}

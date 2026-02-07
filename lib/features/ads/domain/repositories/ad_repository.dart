import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Abstract repository for ad operations
abstract class AdRepository {
  /// Initialize the Mobile Ads SDK
  Future<void> initialize();

  /// Load a banner ad
  Future<BannerAd?> loadBannerAd({
    required AdSize adSize,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  });

  /// Load an interstitial ad
  Future<InterstitialAd?> loadInterstitialAd();

  /// Show interstitial ad if loaded (with frequency cap)
  Future<bool> showInterstitialAd();

  /// Check if ads should be shown (based on consent)
  bool shouldShowAds();

  /// Dispose resources
  void dispose();
}

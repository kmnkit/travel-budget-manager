import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ad_providers.dart';

/// Manager class for interstitial ads with frequency capping
class InterstitialAdManager {
  final Ref _ref;

  InterstitialAdManager(this._ref);

  /// Show interstitial ad (respects frequency cap of 1 in 3)
  /// Returns true if ad was shown
  Future<bool> showAd() async {
    final adRepo = _ref.read(adRepositoryProvider);
    return await adRepo.showInterstitialAd();
  }

  /// Preload an interstitial ad for later use
  Future<void> preloadAd() async {
    final adRepo = _ref.read(adRepositoryProvider);
    await adRepo.loadInterstitialAd();
  }
}

/// Provider for interstitial ad manager
final interstitialAdManagerProvider = Provider<InterstitialAdManager>((ref) {
  return InterstitialAdManager(ref);
});

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';

abstract class AdDatasource {
  Future<void> loadBannerAd(AdConfig config);
  Future<void> loadInterstitialAd(AdConfig config);
  Future<void> loadRewardedAd(AdConfig config);
  Future<void> showInterstitialAd();
  Future<void> showRewardedAd();
  Future<void> disposeAds();
}

class AdDatasourceImpl implements AdDatasource {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  @override
  Future<void> loadBannerAd(AdConfig config) async {
    if (!config.isEnabled) return;

    try {
      _bannerAd = BannerAd(
        adUnitId: config.unitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
      );

      await _bannerAd?.load();
    } catch (e) {
      // Log error in production
    }
  }

  @override
  Future<void> loadInterstitialAd(AdConfig config) async {
    if (!config.isEnabled) return;

    try {
      await InterstitialAd.load(
        adUnitId: config.unitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // Log error
          },
        ),
      );
    } catch (e) {
      // Log error in production
    }
  }

  @override
  Future<void> loadRewardedAd(AdConfig config) async {
    if (!config.isEnabled) return;

    try {
      await RewardedAd.load(
        adUnitId: config.unitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // Log error
          },
        ),
      );
    } catch (e) {
      // Log error in production
    }
  }

  @override
  Future<void> showInterstitialAd() async {
    if (_interstitialAd == null) return;

    try {
      await _interstitialAd?.show();
      _interstitialAd = null;
    } catch (e) {
      // Log error
    }
  }

  @override
  Future<void> showRewardedAd() async {
    if (_rewardedAd == null) return;

    try {
      await _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // Handle reward
        },
      );
      _rewardedAd = null;
    } catch (e) {
      // Log error
    }
  }

  @override
  Future<void> disposeAds() async {
    try {
      await _bannerAd?.dispose();
      await _interstitialAd?.dispose();
      await _rewardedAd?.dispose();

      _bannerAd = null;
      _interstitialAd = null;
      _rewardedAd = null;
    } catch (e) {
      // Log error
    }
  }
}

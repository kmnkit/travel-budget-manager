import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_unit.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';

class AdRepositoryImpl implements AdRepository {
  final ConsentRepository _consentRepository;

  InterstitialAd? _interstitialAd;
  int _interstitialShowCount = 0;
  static const int _interstitialFrequency = 3; // Show every 3rd time
  bool _isInitialized = false;

  AdRepositoryImpl(this._consentRepository);

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();

    // Configure for non-personalized ads if no consent
    final consent = await _consentRepository.getConsentStatus();
    if (consent == null || !consent.personalizedAdsConsent) {
      // Request non-personalized ads
      final requestConfig = RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        maxAdContentRating: MaxAdContentRating.g,
      );
      await MobileAds.instance.updateRequestConfiguration(requestConfig);
    }

    _isInitialized = true;
  }

  @override
  Future<BannerAd?> loadBannerAd({
    required AdSize adSize,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) async {
    if (!shouldShowAds()) return null;

    final bannerAd = BannerAd(
      adUnitId: AdUnitIds.getBannerId(),
      size: adSize,
      request: _createAdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );

    await bannerAd.load();
    return bannerAd;
  }

  @override
  Future<InterstitialAd?> loadInterstitialAd() async {
    if (!shouldShowAds()) return null;

    await InterstitialAd.load(
      adUnitId: AdUnitIds.getInterstitialId(),
      request: _createAdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );

    return _interstitialAd;
  }

  @override
  Future<bool> showInterstitialAd() async {
    _interstitialShowCount++;

    // Only show every Nth time (frequency cap)
    if (_interstitialShowCount % _interstitialFrequency != 0) {
      return false;
    }

    if (_interstitialAd == null) {
      await loadInterstitialAd();
    }

    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      return true;
    }

    return false;
  }

  @override
  bool shouldShowAds() {
    // Ads are shown even without consent (non-personalized)
    // Only completely disable if user explicitly opted out
    return _isInitialized;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  AdRequest _createAdRequest() {
    return const AdRequest();
  }
}

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdDataSource {
  BannerAd createBannerAd({
    required String adUnitId,
    required BannerAdListener listener,
  }) {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    );
  }

  InterstitialAd? createInterstitialAd({
    required String adUnitId,
    required InterstitialAdLoadCallback loadCallback,
  }) {
    InterstitialAd? ad;
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: loadCallback,
    );
    return ad;
  }
}

abstract class AdRepository {
  Future<void> loadBannerAd(String adUnitId);
  Future<void> loadInterstitialAd(String adUnitId);
  Future<void> showAd();
  void disposeAd();
}

import 'package:trip_wallet/features/monetization/domain/repositories/ad_repository.dart';

class AdRepositoryImpl implements AdRepository {
  AdRepositoryImpl();

  @override
  Future<void> loadBannerAd(String adUnitId) async {
    // Implementation handled in widget level
  }

  @override
  Future<void> loadInterstitialAd(String adUnitId) async {
    // To be implemented when needed
  }

  @override
  Future<void> showAd() async {
    // To be implemented when needed
  }

  @override
  void disposeAd() {
    // To be implemented when needed
  }
}

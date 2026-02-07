import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/ads/data/datasources/ad_datasource.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';

class MockAdBannerView extends Mock {}
class MockAdInterstitialAd extends Mock {}
class MockAdRewardedAd extends Mock {}

void main() {
  group('AdDatasource', () {
    late AdDatasourceImpl datasource;

    setUp(() {
      datasource = AdDatasourceImpl();
    });

    group('loadBannerAd', () {
      test('should load banner ad without errors', () async {
        final config = AdConfig(
          type: AdType.banner,
          unitId: 'ca-app-pub-3940256099942544/6300978111',
          isTestAd: true,
          isEnabled: true,
        );

        await datasource.loadBannerAd(config);
        // No exception should be thrown
      });

      test('should not load banner ad when disabled', () async {
        final config = AdConfig(
          type: AdType.banner,
          unitId: 'ca-app-pub-3940256099942544/6300978111',
          isTestAd: true,
          isEnabled: false,
        );

        await datasource.loadBannerAd(config);
        // No exception should be thrown
      });
    });

    group('loadInterstitialAd', () {
      test('should load interstitial ad without errors', () async {
        final config = AdConfig(
          type: AdType.interstitial,
          unitId: 'ca-app-pub-3940256099942544/1033173712',
          isTestAd: true,
          isEnabled: true,
        );

        await datasource.loadInterstitialAd(config);
        // No exception should be thrown
      });

      test('should not load interstitial when disabled', () async {
        final config = AdConfig(
          type: AdType.interstitial,
          unitId: 'ca-app-pub-3940256099942544/1033173712',
          isTestAd: true,
          isEnabled: false,
        );

        await datasource.loadInterstitialAd(config);
        // No exception should be thrown
      });
    });

    group('loadRewardedAd', () {
      test('should load rewarded ad without errors', () async {
        final config = AdConfig(
          type: AdType.rewarded,
          unitId: 'ca-app-pub-3940256099942544/5224354917',
          isTestAd: true,
          isEnabled: true,
        );

        await datasource.loadRewardedAd(config);
        // No exception should be thrown
      });

      test('should not load rewarded when disabled', () async {
        final config = AdConfig(
          type: AdType.rewarded,
          unitId: 'ca-app-pub-3940256099942544/5224354917',
          isTestAd: true,
          isEnabled: false,
        );

        await datasource.loadRewardedAd(config);
        // No exception should be thrown
      });
    });

    group('disposeAds', () {
      test('should dispose all ads without errors', () async {
        await datasource.disposeAds();
        // No exception should be thrown
      });
    });
  });
}

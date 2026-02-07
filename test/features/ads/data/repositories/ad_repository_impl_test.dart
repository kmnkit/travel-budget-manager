import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/ads/data/datasources/ad_datasource.dart';
import 'package:trip_wallet/features/ads/data/helpers/ad_helper.dart';
import 'package:trip_wallet/features/ads/data/repositories/ad_repository_impl.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';

class MockAdDatasource extends Mock implements AdDatasource {}

void main() {
  group('AdRepositoryImpl', () {
    late MockAdDatasource mockDatasource;
    late AdRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockAdDatasource();
      repository = AdRepositoryImpl(mockDatasource);
    });

    group('getAdConfig', () {
      test('should return banner ad config', () async {
        final result = await repository.getAdConfig(AdType.banner);

        expect(result.type, AdType.banner);
        expect(result.unitId, AdHelper.getAdUnitId(AdType.banner));
      });

      test('should return interstitial ad config', () async {
        final result = await repository.getAdConfig(AdType.interstitial);

        expect(result.type, AdType.interstitial);
        expect(result.unitId, AdHelper.getAdUnitId(AdType.interstitial));
      });

      test('should return rewarded ad config', () async {
        final result = await repository.getAdConfig(AdType.rewarded);

        expect(result.type, AdType.rewarded);
        expect(result.unitId, AdHelper.getAdUnitId(AdType.rewarded));
      });
    });

    group('getAllAdConfigs', () {
      test('should return all ad configs', () async {
        final result = await repository.getAllAdConfigs();

        expect(result.length, 3);
        expect(result[0].type, AdType.banner);
        expect(result[1].type, AdType.interstitial);
        expect(result[2].type, AdType.rewarded);
      });

      test('all configs should be enabled by default', () async {
        final result = await repository.getAllAdConfigs();

        expect(result.every((config) => config.isEnabled), true);
      });
    });

    group('loadBannerAd', () {
      test('should load banner ad via datasource', () async {
        final config = AdConfig(
          type: AdType.banner,
          unitId: 'ca-app-pub-3940256099942544/6300978111',
          isTestAd: true,
          isEnabled: true,
        );

        when(() => mockDatasource.loadBannerAd(config))
            .thenAnswer((_) async => {});

        await repository.loadBannerAd(config);

        verify(() => mockDatasource.loadBannerAd(config)).called(1);
      });

      test('should propagate exception from datasource', () async {
        final config = AdConfig(
          type: AdType.banner,
          unitId: 'ca-app-pub-3940256099942544/6300978111',
          isTestAd: true,
          isEnabled: true,
        );

        when(() => mockDatasource.loadBannerAd(config))
            .thenThrow(Exception('Load failed'));

        expect(
          () => repository.loadBannerAd(config),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('loadInterstitialAd', () {
      test('should load interstitial ad via datasource', () async {
        final config = AdConfig(
          type: AdType.interstitial,
          unitId: 'ca-app-pub-3940256099942544/1033173712',
          isTestAd: true,
          isEnabled: true,
        );

        when(() => mockDatasource.loadInterstitialAd(config))
            .thenAnswer((_) async => {});

        await repository.loadInterstitialAd(config);

        verify(() => mockDatasource.loadInterstitialAd(config)).called(1);
      });
    });

    group('loadRewardedAd', () {
      test('should load rewarded ad via datasource', () async {
        final config = AdConfig(
          type: AdType.rewarded,
          unitId: 'ca-app-pub-3940256099942544/5224354917',
          isTestAd: true,
          isEnabled: true,
        );

        when(() => mockDatasource.loadRewardedAd(config))
            .thenAnswer((_) async => {});

        await repository.loadRewardedAd(config);

        verify(() => mockDatasource.loadRewardedAd(config)).called(1);
      });
    });

    group('showInterstitialAd', () {
      test('should show interstitial ad via datasource', () async {
        when(() => mockDatasource.showInterstitialAd())
            .thenAnswer((_) async => {});

        await repository.showInterstitialAd();

        verify(() => mockDatasource.showInterstitialAd()).called(1);
      });
    });

    group('showRewardedAd', () {
      test('should show rewarded ad via datasource', () async {
        when(() => mockDatasource.showRewardedAd())
            .thenAnswer((_) async => {});

        await repository.showRewardedAd();

        verify(() => mockDatasource.showRewardedAd()).called(1);
      });
    });

    group('disposeAds', () {
      test('should dispose all ads via datasource', () async {
        when(() => mockDatasource.disposeAds())
            .thenAnswer((_) async => {});

        await repository.disposeAds();

        verify(() => mockDatasource.disposeAds()).called(1);
      });
    });
  });
}

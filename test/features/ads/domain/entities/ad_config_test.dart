import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';

void main() {
  group('AdConfig', () {
    test('should create AdConfig with correct properties', () {
      final adConfig = AdConfig(
        type: AdType.banner,
        unitId: 'ca-app-pub-3940256099942544/6300978111',
        isTestAd: true,
        isEnabled: true,
      );

      expect(adConfig.type, AdType.banner);
      expect(adConfig.unitId, 'ca-app-pub-3940256099942544/6300978111');
      expect(adConfig.isTestAd, true);
      expect(adConfig.isEnabled, true);
    });

    test('should create AdConfig with production ad unit', () {
      final adConfig = AdConfig(
        type: AdType.interstitial,
        unitId: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx',
        isTestAd: false,
        isEnabled: true,
      );

      expect(adConfig.isTestAd, false);
      expect(adConfig.isEnabled, true);
    });

    test('should support value equality', () {
      final adConfig1 = AdConfig(
        type: AdType.banner,
        unitId: 'ca-app-pub-3940256099942544/6300978111',
        isTestAd: true,
        isEnabled: true,
      );

      final adConfig2 = AdConfig(
        type: AdType.banner,
        unitId: 'ca-app-pub-3940256099942544/6300978111',
        isTestAd: true,
        isEnabled: true,
      );

      expect(adConfig1, adConfig2);
    });

    test('should support inequality for different unit IDs', () {
      final adConfig1 = AdConfig(
        type: AdType.banner,
        unitId: 'ca-app-pub-3940256099942544/6300978111',
        isTestAd: true,
        isEnabled: true,
      );

      final adConfig2 = AdConfig(
        type: AdType.banner,
        unitId: 'ca-app-pub-3940256099942544/9033173001',
        isTestAd: true,
        isEnabled: true,
      );

      expect(adConfig1, isNot(adConfig2));
    });

    test('should convert AdConfig to string representation', () {
      final adConfig = AdConfig(
        type: AdType.banner,
        unitId: 'ca-app-pub-3940256099942544/6300978111',
        isTestAd: true,
        isEnabled: true,
      );

      expect(adConfig.toString(), contains('AdConfig'));
      expect(adConfig.toString(), contains('banner'));
    });
  });
}

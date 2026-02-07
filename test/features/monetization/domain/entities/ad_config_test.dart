import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/monetization/domain/entities/ad_config.dart';
import 'package:trip_wallet/features/monetization/domain/entities/ad_type.dart';

void main() {
  group('AdConfig', () {
    test('should create AdConfig with required fields', () {
      const config = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      expect(config.adUnitId, 'test-ad-unit-id');
      expect(config.adType, AdType.banner);
      expect(config.isTestMode, true);
    });

    test('should support value equality', () {
      const config1 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      const config2 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      expect(config1, config2);
    });

    test('should not be equal with different adUnitId', () {
      const config1 = AdConfig(
        adUnitId: 'test-ad-unit-id-1',
        adType: AdType.banner,
        isTestMode: true,
      );

      const config2 = AdConfig(
        adUnitId: 'test-ad-unit-id-2',
        adType: AdType.banner,
        isTestMode: true,
      );

      expect(config1, isNot(config2));
    });

    test('should not be equal with different adType', () {
      const config1 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      const config2 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.interstitial,
        isTestMode: true,
      );

      expect(config1, isNot(config2));
    });

    test('should not be equal with different isTestMode', () {
      const config1 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      const config2 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: false,
      );

      expect(config1, isNot(config2));
    });

    test('should support copyWith for adUnitId', () {
      const config = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      final updated = config.copyWith(adUnitId: 'new-ad-unit-id');

      expect(updated.adUnitId, 'new-ad-unit-id');
      expect(updated.adType, AdType.banner);
      expect(updated.isTestMode, true);
    });

    test('should support copyWith for adType', () {
      const config = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      final updated = config.copyWith(adType: AdType.rewarded);

      expect(updated.adUnitId, 'test-ad-unit-id');
      expect(updated.adType, AdType.rewarded);
      expect(updated.isTestMode, true);
    });

    test('should support copyWith for isTestMode', () {
      const config = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      final updated = config.copyWith(isTestMode: false);

      expect(updated.adUnitId, 'test-ad-unit-id');
      expect(updated.adType, AdType.banner);
      expect(updated.isTestMode, false);
    });

    test('should have working hashCode', () {
      const config1 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      const config2 = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      expect(config1.hashCode, config2.hashCode);
    });

    test('should have working toString', () {
      const config = AdConfig(
        adUnitId: 'test-ad-unit-id',
        adType: AdType.banner,
        isTestMode: true,
      );

      expect(config.toString(), contains('AdConfig'));
      expect(config.toString(), contains('test-ad-unit-id'));
      expect(config.toString(), contains('banner'));
      expect(config.toString(), contains('true'));
    });
  });
}

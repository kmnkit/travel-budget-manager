import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/monetization/domain/entities/ad_type.dart';

void main() {
  group('AdType', () {
    test('should have BANNER value', () {
      expect(AdType.values, contains(AdType.banner));
    });

    test('should have INTERSTITIAL value', () {
      expect(AdType.values, contains(AdType.interstitial));
    });

    test('should have REWARDED value', () {
      expect(AdType.values, contains(AdType.rewarded));
    });

    test('should have exactly 3 values', () {
      expect(AdType.values.length, 3);
    });

    test('banner should have correct name', () {
      expect(AdType.banner.name, 'banner');
    });

    test('interstitial should have correct name', () {
      expect(AdType.interstitial.name, 'interstitial');
    });

    test('rewarded should have correct name', () {
      expect(AdType.rewarded.name, 'rewarded');
    });
  });
}

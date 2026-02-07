import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_unit.dart';

void main() {
  group('AdUnitIds', () {
    test('testBannerId should be valid Google test ID', () {
      expect(AdUnitIds.testBannerId, 'ca-app-pub-3940256099942544/6300978111');
    });

    test('testInterstitialId should be valid Google test ID', () {
      expect(AdUnitIds.testInterstitialId, 'ca-app-pub-3940256099942544/1033173712');
    });

    test('getBannerId returns test ID in debug mode', () {
      // In test environment, kDebugMode is true
      final id = AdUnitIds.getBannerId();
      expect(id, AdUnitIds.testBannerId);
    });

    test('getInterstitialId returns test ID in debug mode', () {
      final id = AdUnitIds.getInterstitialId();
      expect(id, AdUnitIds.testInterstitialId);
    });
  });
}

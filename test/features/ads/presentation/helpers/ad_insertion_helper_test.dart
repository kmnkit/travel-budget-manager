import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/ads/presentation/helpers/ad_insertion_helper.dart';

void main() {
  group('AdInsertionHelper', () {
    group('insertAdsIntoList', () {
      test('should insert ads every N items', () {
        final items = List.generate(10, (index) => 'Item $index');
        const adItem = 'AD';

        final result = AdInsertionHelper.insertAdsIntoList(
          items,
          adItem,
          frequencyInterval: 3,
        );

        expect(result.contains(adItem), true);
        // Items 0,1,2,AD,3,4,5,AD,6,7,8,AD,9
        expect(result.length, greaterThan(items.length));
      });

      test('should not insert ads into empty list', () {
        const adItem = 'AD';

        final result = AdInsertionHelper.insertAdsIntoList(
          [],
          adItem,
          frequencyInterval: 3,
        );

        expect(result.isEmpty, true);
      });

      test('should handle invalid frequency interval', () {
        final items = List.generate(5, (index) => 'Item $index');
        const adItem = 'AD';

        final result = AdInsertionHelper.insertAdsIntoList(
          items,
          adItem,
          frequencyInterval: 0,
        );

        expect(result, items);
      });

      test('should limit ads to max per screen', () {
        final items = List.generate(20, (index) => 'Item $index');
        const adItem = 'AD';

        final result = AdInsertionHelper.insertAdsIntoList(
          items,
          adItem,
          frequencyInterval: 2,
        );

        final adCount = result.where((item) => item == adItem).length;
        expect(adCount, lessThanOrEqualTo(3));
      });

      test('should not add ad as last item', () {
        final items = List.generate(5, (index) => 'Item $index');
        const adItem = 'AD';

        final result = AdInsertionHelper.insertAdsIntoList(
          items,
          adItem,
          frequencyInterval: 5,
        );

        expect(result.last, isNot(adItem));
      });
    });

    group('isAdPlaceholder', () {
      test('should identify ad placeholder', () {
        const adItem = 'AD';
        final result = AdInsertionHelper.isAdPlaceholder(adItem, adItem);

        expect(result, true);
      });

      test('should return false for non-ad items', () {
        const adItem = 'AD';
        const nonAdItem = 'Item';

        final result = AdInsertionHelper.isAdPlaceholder(nonAdItem, adItem);

        expect(result, false);
      });
    });

    group('constants', () {
      test('should have correct frequency constants', () {
        expect(AdInsertionHelper.frequencyHomeScreen, 4);
        expect(AdInsertionHelper.frequencyListScreen, 3);
        expect(AdInsertionHelper.frequencySettingsScreen, 5);
      });
    });
  });
}

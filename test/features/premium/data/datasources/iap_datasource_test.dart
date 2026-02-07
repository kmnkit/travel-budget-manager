import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/premium/data/datasources/iap_datasource.dart';

class MockIapDatasource extends Mock implements IapDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IapDatasource', () {
    late MockIapDatasource datasource;

    setUp(() {
      datasource = MockIapDatasource();
    });

    group('getPremiumProductId', () {
      test('should return correct premium product ID', () {
        when(() => datasource.getPremiumProductId())
            .thenReturn('com.kmnkit.trip_wallet.remove_ads');

        final productId = datasource.getPremiumProductId();
        expect(productId, 'com.kmnkit.trip_wallet.remove_ads');
        verify(() => datasource.getPremiumProductId()).called(1);
      });
    });

    group('isAvailable', () {
      test('should check if IAP is available', () async {
        when(() => datasource.isAvailable())
            .thenAnswer((_) async => true);

        final result = await datasource.isAvailable();
        expect(result, true);
        verify(() => datasource.isAvailable()).called(1);
      });

      test('should return false when IAP is not available', () async {
        when(() => datasource.isAvailable())
            .thenAnswer((_) async => false);

        final result = await datasource.isAvailable();
        expect(result, false);
      });
    });

    group('getProduct', () {
      test('should return product details or null', () async {
        when(() => datasource.getProduct())
            .thenAnswer((_) async => null);

        final result = await datasource.getProduct();
        expect(result, isNull);
        verify(() => datasource.getProduct()).called(1);
      });
    });

    group('purchaseProduct', () {
      test('should handle purchase request', () async {
        when(() => datasource.purchaseProduct())
            .thenAnswer((_) async => true);

        final result = await datasource.purchaseProduct();
        expect(result, true);
        verify(() => datasource.purchaseProduct()).called(1);
      });

      test('should return false when purchase fails', () async {
        when(() => datasource.purchaseProduct())
            .thenAnswer((_) async => false);

        final result = await datasource.purchaseProduct();
        expect(result, false);
      });
    });

    group('restorePurchases', () {
      test('should restore previous purchases', () async {
        when(() => datasource.restorePurchases())
            .thenAnswer((_) async => true);

        final result = await datasource.restorePurchases();
        expect(result, true);
        verify(() => datasource.restorePurchases()).called(1);
      });
    });

    group('purchaseStream', () {
      test('should provide purchase stream', () {
        final controller = StreamController<List<PurchaseDetails>>.broadcast();
        when(() => datasource.purchaseStream)
            .thenAnswer((_) => controller.stream);

        final stream = datasource.purchaseStream;
        expect(stream, isA<Stream<List<PurchaseDetails>>>());

        controller.close();
      });
    });
  });
}

import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IapDatasource {
  /// Get the premium product ID
  String getPremiumProductId();

  /// Check if IAP is available on this device
  Future<bool> isAvailable();

  /// Get product details
  Future<ProductDetails?> getProduct();

  /// Purchase the premium product
  Future<bool> purchaseProduct();

  /// Restore previous purchases
  Future<bool> restorePurchases();

  /// Get stream of purchase updates
  Stream<List<PurchaseDetails>> get purchaseStream;

  /// Complete a purchase (mark as delivered)
  Future<void> completePurchase(PurchaseDetails purchase);

  /// Dispose resources
  void dispose();
}

class IapDatasourceImpl implements IapDatasource {
  static const String _premiumProductId = 'com.kmnkit.trip_wallet.remove_ads';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  ProductDetails? _productDetails;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _purchaseController = StreamController<List<PurchaseDetails>>.broadcast();

  IapDatasourceImpl() {
    _initializePurchaseStream();
  }

  void _initializePurchaseStream() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _purchaseController.add(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        // Handle error
      },
    );
  }

  @override
  String getPremiumProductId() => _premiumProductId;

  @override
  Future<bool> isAvailable() async {
    return await _inAppPurchase.isAvailable();
  }

  @override
  Future<ProductDetails?> getProduct() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails({_premiumProductId});

      if (response.notFoundIDs.isNotEmpty) {
        // Product ID not found in store
        return null;
      }

      if (response.productDetails.isNotEmpty) {
        _productDetails = response.productDetails.first;
        return _productDetails;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> purchaseProduct() async {
    try {
      // Check if IAP is available
      final available = await isAvailable();
      if (!available) {
        return false;
      }

      // Get product details if not cached
      _productDetails ??= await getProduct();

      if (_productDetails == null) {
        return false;
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _productDetails!,
      );

      return await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseController.stream;

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _purchaseController.close();
  }
}

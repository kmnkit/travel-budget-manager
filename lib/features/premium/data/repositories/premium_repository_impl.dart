import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:trip_wallet/features/premium/data/datasources/iap_datasource.dart';
import 'package:trip_wallet/features/premium/data/datasources/premium_local_datasource.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';
import 'package:trip_wallet/features/premium/domain/repositories/premium_repository.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  final PremiumLocalDatasource _localDatasource;
  final IapDatasource _iapDatasource;

  PremiumRepositoryImpl(
    this._localDatasource, {
    IapDatasource? iapDatasource,
  }) : _iapDatasource = iapDatasource ?? IapDatasourceImpl();

  @override
  Future<PremiumStatus> getPremiumStatus() async {
    // Check local storage for premium status
    return await _localDatasource.getPremiumStatus();
  }

  @override
  Future<void> savePremiumStatus(PremiumStatus status) async {
    return await _localDatasource.savePremiumStatus(status);
  }

  @override
  Future<void> clearPremiumStatus() async {
    return await _localDatasource.clearPremiumStatus();
  }

  @override
  Future<bool> isPremium() async {
    final status = await getPremiumStatus();
    return status.isPremium && !status.isExpired;
  }

  @override
  Stream<bool> watchPremiumStatus() async* {
    // Initial check
    yield await isPremium();

    // Poll every 5 seconds for changes (simple implementation)
    // In production, consider using a more efficient change detection mechanism
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield await isPremium();
    }
  }

  /// Get IAP datasource (for provider access)
  IapDatasource get iapDatasource => _iapDatasource;

  /// Process a purchase and update premium status
  Future<void> handlePurchaseUpdate(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      // Verify the purchase is for our premium product
      if (purchase.productID == _iapDatasource.getPremiumProductId()) {
        // Create premium status
        final premiumStatus = PremiumStatus(
          isPremium: true,
          purchaseId: purchase.purchaseID,
          expiryDate: null, // Non-consumable, no expiry
          autoRenewal: false, // Not a subscription
        );

        // Save premium status
        await savePremiumStatus(premiumStatus);

        // Complete the purchase
        await _iapDatasource.completePurchase(purchase);
      }
    } else if (purchase.status == PurchaseStatus.error) {
      // Handle error - don't save premium status
      // Complete the purchase to clear it
      await _iapDatasource.completePurchase(purchase);
    }
  }

  /// Restore previous purchases from app store
  Future<bool> restorePurchases() async {
    try {
      return await _iapDatasource.restorePurchases();
    } catch (e) {
      return false;
    }
  }

  /// Start a new premium purchase
  Future<bool> startPremiumPurchase() async {
    try {
      return await _iapDatasource.purchaseProduct();
    } catch (e) {
      return false;
    }
  }

  /// Get product details
  Future<ProductDetails?> getProductDetails() async {
    return await _iapDatasource.getProduct();
  }

  /// Check if IAP is available
  Future<bool> isIapAvailable() async {
    return await _iapDatasource.isAvailable();
  }
}

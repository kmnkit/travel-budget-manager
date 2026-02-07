import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';

void main() {
  group('PremiumStatus', () {
    test('should create PremiumStatus with correct properties', () {
      final premiumStatus = PremiumStatus(
        isPremium: true,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2025, 12, 31),
        autoRenewal: true,
      );

      expect(premiumStatus.isPremium, true);
      expect(premiumStatus.purchaseId, 'purchase_123');
      expect(premiumStatus.expiryDate, DateTime(2025, 12, 31));
      expect(premiumStatus.autoRenewal, true);
    });

    test('should create PremiumStatus with default values', () {
      final premiumStatus = PremiumStatus(
        isPremium: false,
        purchaseId: null,
        expiryDate: null,
        autoRenewal: false,
      );

      expect(premiumStatus.isPremium, false);
      expect(premiumStatus.purchaseId, null);
      expect(premiumStatus.expiryDate, null);
      expect(premiumStatus.autoRenewal, false);
    });

    test('should return true for isExpired when expiryDate is in the past', () {
      final premiumStatus = PremiumStatus(
        isPremium: true,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2024, 1, 1),
        autoRenewal: false,
      );

      expect(premiumStatus.isExpired, true);
    });

    test('should return false for isExpired when expiryDate is in the future', () {
      final premiumStatus = PremiumStatus(
        isPremium: true,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2099, 12, 31),
        autoRenewal: false,
      );

      expect(premiumStatus.isExpired, false);
    });

    test('should return false for isExpired when expiryDate is null', () {
      final premiumStatus = PremiumStatus(
        isPremium: false,
        purchaseId: null,
        expiryDate: null,
        autoRenewal: false,
      );

      expect(premiumStatus.isExpired, false);
    });

    test('should support value equality', () {
      final premiumStatus1 = PremiumStatus(
        isPremium: true,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2025, 12, 31),
        autoRenewal: true,
      );

      final premiumStatus2 = PremiumStatus(
        isPremium: true,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2025, 12, 31),
        autoRenewal: true,
      );

      expect(premiumStatus1, premiumStatus2);
    });

    test('should support inequality for different properties', () {
      final premiumStatus1 = PremiumStatus(
        isPremium: true,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2025, 12, 31),
        autoRenewal: true,
      );

      final premiumStatus2 = PremiumStatus(
        isPremium: false,
        purchaseId: 'purchase_123',
        expiryDate: DateTime(2025, 12, 31),
        autoRenewal: true,
      );

      expect(premiumStatus1, isNot(premiumStatus2));
    });
  });
}

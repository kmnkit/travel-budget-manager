import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';

abstract class PremiumRepository {
  /// Get current premium status
  Future<PremiumStatus> getPremiumStatus();

  /// Save premium status
  Future<void> savePremiumStatus(PremiumStatus status);

  /// Clear premium status
  Future<void> clearPremiumStatus();

  /// Check if user is premium (convenience method)
  Future<bool> isPremium();

  /// Watch premium status changes (reactive stream)
  Stream<bool> watchPremiumStatus();
}

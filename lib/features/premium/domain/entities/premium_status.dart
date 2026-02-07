import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_status.freezed.dart';

@freezed
abstract class PremiumStatus with _$PremiumStatus {
  const factory PremiumStatus({
    required bool isPremium,
    required String? purchaseId,
    required DateTime? expiryDate,
    required bool autoRenewal,
  }) = _PremiumStatus;

  const PremiumStatus._();

  /// Returns true if premium subscription has expired
  bool get isExpired {
    if (expiryDate == null) {
      return false;
    }
    return expiryDate!.isBefore(DateTime.now());
  }
}

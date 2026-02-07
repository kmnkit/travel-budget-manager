import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';

abstract class PremiumLocalDatasource {
  Future<PremiumStatus> getPremiumStatus();
  Future<void> savePremiumStatus(PremiumStatus status);
  Future<void> clearPremiumStatus();
}

class PremiumLocalDatasourceImpl implements PremiumLocalDatasource {
  static const _premiumStatusKey = 'premium_status';

  final SharedPreferences _sharedPreferences;

  PremiumLocalDatasourceImpl(this._sharedPreferences);

  @override
  Future<PremiumStatus> getPremiumStatus() async {
    final jsonString = _sharedPreferences.getString(_premiumStatusKey);

    if (jsonString == null) {
      return const PremiumStatus(
        isPremium: false,
        purchaseId: null,
        expiryDate: null,
        autoRenewal: false,
      );
    }

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return PremiumStatus(
        isPremium: jsonMap['isPremium'] as bool,
        purchaseId: jsonMap['purchaseId'] as String?,
        expiryDate: jsonMap['expiryDate'] != null
            ? DateTime.parse(jsonMap['expiryDate'] as String)
            : null,
        autoRenewal: jsonMap['autoRenewal'] as bool,
      );
    } catch (e) {
      throw FormatException('Failed to parse premium status: $e');
    }
  }

  @override
  Future<void> savePremiumStatus(PremiumStatus status) async {
    final jsonMap = {
      'isPremium': status.isPremium,
      'purchaseId': status.purchaseId,
      'expiryDate': status.expiryDate?.toIso8601String(),
      'autoRenewal': status.autoRenewal,
    };

    final jsonString = jsonEncode(jsonMap);
    final success =
        await _sharedPreferences.setString(_premiumStatusKey, jsonString);

    if (!success) {
      throw Exception('Failed to save premium status');
    }
  }

  @override
  Future<void> clearPremiumStatus() async {
    final success = await _sharedPreferences.remove(_premiumStatusKey);

    if (!success) {
      throw Exception('Failed to clear premium status');
    }
  }
}

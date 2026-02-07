import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/consent_record.dart';
import '../../domain/repositories/consent_repository.dart';

class ConsentRepositoryImpl implements ConsentRepository {
  final SharedPreferences _prefs;

  static const _keyAccepted = 'privacy_consent_accepted';
  static const _keyTimestamp = 'privacy_consent_timestamp';
  static const _keyVersion = 'privacy_consent_version';

  ConsentRepositoryImpl(this._prefs);

  @override
  Future<ConsentRecord> getConsentRecord() async {
    try {
      final isAccepted = _prefs.getBool(_keyAccepted) ?? false;
      final timestampMs = _prefs.getInt(_keyTimestamp);
      final version = _prefs.getString(_keyVersion) ?? '';

      final acceptedAt = timestampMs != null
          ? DateTime.fromMillisecondsSinceEpoch(timestampMs)
          : null;

      return ConsentRecord(
        isAccepted: isAccepted,
        acceptedAt: acceptedAt,
        policyVersion: version,
      );
    } catch (e) {
      // Return default ConsentRecord on exception
      return const ConsentRecord(
        isAccepted: false,
        acceptedAt: null,
        policyVersion: '',
      );
    }
  }

  @override
  Future<void> setConsentAccepted(String version) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await _prefs.setBool(_keyAccepted, true);
    await _prefs.setInt(_keyTimestamp, now);
    await _prefs.setString(_keyVersion, version);
  }

  @override
  Future<void> clearConsent() async {
    await _prefs.remove(_keyAccepted);
    await _prefs.remove(_keyTimestamp);
    await _prefs.remove(_keyVersion);
  }
}

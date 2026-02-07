import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/consent_status.dart';

class ConsentLocalDataSource {
  final SharedPreferences _prefs;

  static const _keyAnalytics = 'consent_analytics';
  static const _keyPersonalizedAds = 'consent_personalized_ads';
  static const _keyAtt = 'consent_att';
  static const _keyConsentDate = 'consent_date';

  ConsentLocalDataSource(this._prefs);

  Future<ConsentStatus?> getConsentStatus() async {
    final analyticsConsent = _prefs.getBool(_keyAnalytics);
    final personalizedAdsConsent = _prefs.getBool(_keyPersonalizedAds);
    final attGranted = _prefs.getBool(_keyAtt);
    final consentDateMillis = _prefs.getInt(_keyConsentDate);

    if (analyticsConsent == null ||
        personalizedAdsConsent == null ||
        attGranted == null) {
      return null;
    }

    final consentDate = consentDateMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(consentDateMillis)
        : null;

    return ConsentStatus(
      analyticsConsent: analyticsConsent,
      personalizedAdsConsent: personalizedAdsConsent,
      attGranted: attGranted,
      consentDate: consentDate,
    );
  }

  Future<void> saveConsentStatus(ConsentStatus status) async {
    await _prefs.setBool(_keyAnalytics, status.analyticsConsent);
    await _prefs.setBool(_keyPersonalizedAds, status.personalizedAdsConsent);
    await _prefs.setBool(_keyAtt, status.attGranted);

    if (status.consentDate != null) {
      await _prefs.setInt(
        _keyConsentDate,
        status.consentDate!.millisecondsSinceEpoch,
      );
    } else {
      await _prefs.remove(_keyConsentDate);
    }
  }

  Future<bool> isConsentCompleted() async {
    final status = await getConsentStatus();
    return status != null;
  }

  Future<void> clearConsent() async {
    await _prefs.remove(_keyAnalytics);
    await _prefs.remove(_keyPersonalizedAds);
    await _prefs.remove(_keyAtt);
    await _prefs.remove(_keyConsentDate);
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/consent/data/repositories/consent_repository_impl.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late ConsentRepositoryImpl repository;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = ConsentRepositoryImpl(mockPrefs);
  });

  group('ConsentRepositoryImpl', () {
    group('getConsentRecord', () {
      test('returns consent accepted with all data when all keys exist', () async {
        const version = '1.0.0';
        final timestamp = DateTime(2024, 1, 1).millisecondsSinceEpoch;

        when(() => mockPrefs.getBool('privacy_consent_accepted')).thenReturn(true);
        when(() => mockPrefs.getInt('privacy_consent_timestamp')).thenReturn(timestamp);
        when(() => mockPrefs.getString('privacy_consent_version')).thenReturn(version);

        final result = await repository.getConsentRecord();

        expect(result.isAccepted, true);
        expect(result.acceptedAt, DateTime.fromMillisecondsSinceEpoch(timestamp));
        expect(result.policyVersion, version);
        expect(result.hasValidConsent, true);

        verify(() => mockPrefs.getBool('privacy_consent_accepted')).called(1);
        verify(() => mockPrefs.getInt('privacy_consent_timestamp')).called(1);
        verify(() => mockPrefs.getString('privacy_consent_version')).called(1);
      });

      test('returns not accepted when consent key is false', () async {
        when(() => mockPrefs.getBool('privacy_consent_accepted')).thenReturn(false);
        when(() => mockPrefs.getInt('privacy_consent_timestamp')).thenReturn(null);
        when(() => mockPrefs.getString('privacy_consent_version')).thenReturn(null);

        final result = await repository.getConsentRecord();

        expect(result.isAccepted, false);
        expect(result.acceptedAt, null);
        expect(result.policyVersion, '');
        expect(result.hasValidConsent, false);
      });

      test('returns not accepted when consent key does not exist', () async {
        when(() => mockPrefs.getBool('privacy_consent_accepted')).thenReturn(null);
        when(() => mockPrefs.getInt('privacy_consent_timestamp')).thenReturn(null);
        when(() => mockPrefs.getString('privacy_consent_version')).thenReturn(null);

        final result = await repository.getConsentRecord();

        expect(result.isAccepted, false);
        expect(result.acceptedAt, null);
        expect(result.policyVersion, '');
        expect(result.hasValidConsent, false);
      });

      test('returns accepted with null timestamp when timestamp is missing', () async {
        const version = '1.0.0';

        when(() => mockPrefs.getBool('privacy_consent_accepted')).thenReturn(true);
        when(() => mockPrefs.getInt('privacy_consent_timestamp')).thenReturn(null);
        when(() => mockPrefs.getString('privacy_consent_version')).thenReturn(version);

        final result = await repository.getConsentRecord();

        expect(result.isAccepted, true);
        expect(result.acceptedAt, null);
        expect(result.policyVersion, version);
        expect(result.hasValidConsent, false); // No valid consent without timestamp
      });

      test('returns accepted with empty version when version is missing', () async {
        final timestamp = DateTime(2024, 1, 1).millisecondsSinceEpoch;

        when(() => mockPrefs.getBool('privacy_consent_accepted')).thenReturn(true);
        when(() => mockPrefs.getInt('privacy_consent_timestamp')).thenReturn(timestamp);
        when(() => mockPrefs.getString('privacy_consent_version')).thenReturn(null);

        final result = await repository.getConsentRecord();

        expect(result.isAccepted, true);
        expect(result.acceptedAt, DateTime.fromMillisecondsSinceEpoch(timestamp));
        expect(result.policyVersion, '');
        expect(result.hasValidConsent, true); // Still valid if we have accepted + timestamp
      });

      test('returns default ConsentRecord when exception occurs', () async {
        when(() => mockPrefs.getBool('privacy_consent_accepted'))
            .thenThrow(Exception('SharedPreferences error'));

        final result = await repository.getConsentRecord();

        expect(result.isAccepted, false);
        expect(result.acceptedAt, null);
        expect(result.policyVersion, '');
        expect(result.hasValidConsent, false);
      });
    });

    group('setConsentAccepted', () {
      test('persists consent accepted with timestamp and version', () async {
        const version = '1.0.0';

        when(() => mockPrefs.setBool('privacy_consent_accepted', true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setInt('privacy_consent_timestamp', any()))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString('privacy_consent_version', version))
            .thenAnswer((_) async => true);

        await repository.setConsentAccepted(version);

        verify(() => mockPrefs.setBool('privacy_consent_accepted', true)).called(1);
        verify(() => mockPrefs.setInt('privacy_consent_timestamp', any())).called(1);
        verify(() => mockPrefs.setString('privacy_consent_version', version)).called(1);
      });

      test('uses current timestamp when setting consent', () async {
        const version = '1.0.0';
        final beforeTime = DateTime.now().millisecondsSinceEpoch;

        when(() => mockPrefs.setBool('privacy_consent_accepted', true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setInt('privacy_consent_timestamp', any()))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString('privacy_consent_version', version))
            .thenAnswer((_) async => true);

        await repository.setConsentAccepted(version);

        final afterTime = DateTime.now().millisecondsSinceEpoch;

        final captured = verify(
          () => mockPrefs.setInt('privacy_consent_timestamp', captureAny())
        ).captured.single as int;

        expect(captured, greaterThanOrEqualTo(beforeTime));
        expect(captured, lessThanOrEqualTo(afterTime));
      });
    });

    group('clearConsent', () {
      test('removes all consent-related keys', () async {
        when(() => mockPrefs.remove('privacy_consent_accepted'))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove('privacy_consent_timestamp'))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove('privacy_consent_version'))
            .thenAnswer((_) async => true);

        await repository.clearConsent();

        verify(() => mockPrefs.remove('privacy_consent_accepted')).called(1);
        verify(() => mockPrefs.remove('privacy_consent_timestamp')).called(1);
        verify(() => mockPrefs.remove('privacy_consent_version')).called(1);
      });
    });
  });
}

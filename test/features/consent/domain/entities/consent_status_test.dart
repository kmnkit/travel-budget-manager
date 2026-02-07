import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_status.dart';

void main() {
  group('ConsentStatus', () {
    test('should create ConsentStatus with required fields', () {
      // Arrange & Act
      final consentDate = DateTime(2024, 1, 1);
      final status = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );

      // Assert
      expect(status.analyticsConsent, true);
      expect(status.personalizedAdsConsent, false);
      expect(status.attGranted, true);
      expect(status.consentDate, consentDate);
    });

    test('should allow null consentDate', () {
      // Arrange & Act
      final status = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: true,
        attGranted: false,
        consentDate: null,
      );

      // Assert
      expect(status.consentDate, isNull);
    });

    test('should support equality comparison', () {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final status1 = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );
      final status2 = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );

      // Act & Assert
      expect(status1, equals(status2));
      expect(status1.hashCode, equals(status2.hashCode));
    });

    test('should not be equal with different values', () {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final status1 = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );
      final status2 = ConsentStatus(
        analyticsConsent: false,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );

      // Act & Assert
      expect(status1, isNot(equals(status2)));
    });

    test('should support copyWith for analyticsConsent', () {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final original = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );

      // Act
      final modified = original.copyWith(analyticsConsent: false);

      // Assert
      expect(modified.analyticsConsent, false);
      expect(modified.personalizedAdsConsent, false);
      expect(modified.attGranted, true);
      expect(modified.consentDate, consentDate);
    });

    test('should support copyWith for personalizedAdsConsent', () {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final original = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: consentDate,
      );

      // Act
      final modified = original.copyWith(personalizedAdsConsent: true);

      // Assert
      expect(modified.analyticsConsent, true);
      expect(modified.personalizedAdsConsent, true);
      expect(modified.attGranted, true);
      expect(modified.consentDate, consentDate);
    });

    test('should support copyWith for attGranted', () {
      // Arrange
      final consentDate = DateTime(2024, 1, 1);
      final original = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: false,
        consentDate: consentDate,
      );

      // Act
      final modified = original.copyWith(attGranted: true);

      // Assert
      expect(modified.analyticsConsent, true);
      expect(modified.personalizedAdsConsent, false);
      expect(modified.attGranted, true);
      expect(modified.consentDate, consentDate);
    });

    test('should support copyWith for consentDate', () {
      // Arrange
      final originalDate = DateTime(2024, 1, 1);
      final newDate = DateTime(2024, 2, 1);
      final original = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: originalDate,
      );

      // Act
      final modified = original.copyWith(consentDate: newDate);

      // Assert
      expect(modified.consentDate, newDate);
      expect(original.consentDate, originalDate);
    });

    test('should support copyWith to set consentDate to null', () {
      // Arrange
      final original = ConsentStatus(
        analyticsConsent: true,
        personalizedAdsConsent: false,
        attGranted: true,
        consentDate: DateTime(2024, 1, 1),
      );

      // Act
      final modified = original.copyWith(consentDate: null);

      // Assert
      expect(modified.consentDate, isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_record.dart';

void main() {
  group('ConsentRecord', () {
    test('should create ConsentRecord with all fields', () {
      // Arrange
      final timestamp = DateTime(2024, 1, 1);
      const version = '1.0.0';

      // Act
      final record = ConsentRecord(
        isAccepted: true,
        acceptedAt: timestamp,
        policyVersion: version,
      );

      // Assert
      expect(record.isAccepted, true);
      expect(record.acceptedAt, timestamp);
      expect(record.policyVersion, version);
    });

    test('should create ConsentRecord with null acceptedAt', () {
      // Act
      const record = ConsentRecord(
        isAccepted: false,
        acceptedAt: null,
        policyVersion: '1.0.0',
      );

      // Assert
      expect(record.isAccepted, false);
      expect(record.acceptedAt, null);
      expect(record.policyVersion, '1.0.0');
    });

    group('hasValidConsent', () {
      test('should return true when accepted and timestamp present', () {
        // Arrange
        final record = ConsentRecord(
          isAccepted: true,
          acceptedAt: DateTime.now(),
          policyVersion: '1.0.0',
        );

        // Assert
        expect(record.hasValidConsent, true);
      });

      test('should return false when accepted but timestamp missing', () {
        // Arrange
        const record = ConsentRecord(
          isAccepted: true,
          acceptedAt: null,
          policyVersion: '1.0.0',
        );

        // Assert
        expect(record.hasValidConsent, false);
      });

      test('should return false when not accepted even with timestamp', () {
        // Arrange
        final record = ConsentRecord(
          isAccepted: false,
          acceptedAt: DateTime.now(),
          policyVersion: '1.0.0',
        );

        // Assert
        expect(record.hasValidConsent, false);
      });

      test('should return false when not accepted and no timestamp', () {
        // Arrange
        const record = ConsentRecord(
          isAccepted: false,
          acceptedAt: null,
          policyVersion: '1.0.0',
        );

        // Assert
        expect(record.hasValidConsent, false);
      });
    });

    group('copyWith', () {
      test('should copy with new isAccepted value', () {
        // Arrange
        const original = ConsentRecord(
          isAccepted: false,
          acceptedAt: null,
          policyVersion: '1.0.0',
        );

        // Act
        final copied = original.copyWith(isAccepted: true);

        // Assert
        expect(copied.isAccepted, true);
        expect(copied.acceptedAt, null);
        expect(copied.policyVersion, '1.0.0');
      });

      test('should copy with new acceptedAt value', () {
        // Arrange
        final oldTimestamp = DateTime(2024, 1, 1);
        final newTimestamp = DateTime(2024, 2, 1);
        final original = ConsentRecord(
          isAccepted: true,
          acceptedAt: oldTimestamp,
          policyVersion: '1.0.0',
        );

        // Act
        final copied = original.copyWith(acceptedAt: newTimestamp);

        // Assert
        expect(copied.isAccepted, true);
        expect(copied.acceptedAt, newTimestamp);
        expect(copied.policyVersion, '1.0.0');
      });

      test('should copy with new policyVersion value', () {
        // Arrange
        final original = ConsentRecord(
          isAccepted: true,
          acceptedAt: DateTime.now(),
          policyVersion: '1.0.0',
        );

        // Act
        final copied = original.copyWith(policyVersion: '2.0.0');

        // Assert
        expect(copied.isAccepted, true);
        expect(copied.acceptedAt, original.acceptedAt);
        expect(copied.policyVersion, '2.0.0');
      });

      test('should copy with multiple fields', () {
        // Arrange
        const original = ConsentRecord(
          isAccepted: false,
          acceptedAt: null,
          policyVersion: '1.0.0',
        );
        final newTimestamp = DateTime(2024, 1, 1);

        // Act
        final copied = original.copyWith(
          isAccepted: true,
          acceptedAt: newTimestamp,
          policyVersion: '2.0.0',
        );

        // Assert
        expect(copied.isAccepted, true);
        expect(copied.acceptedAt, newTimestamp);
        expect(copied.policyVersion, '2.0.0');
      });
    });

    group('equality', () {
      test('should be equal with same values', () {
        // Arrange
        final timestamp = DateTime(2024, 1, 1);
        final record1 = ConsentRecord(
          isAccepted: true,
          acceptedAt: timestamp,
          policyVersion: '1.0.0',
        );
        final record2 = ConsentRecord(
          isAccepted: true,
          acceptedAt: timestamp,
          policyVersion: '1.0.0',
        );

        // Assert
        expect(record1, equals(record2));
        expect(record1.hashCode, equals(record2.hashCode));
      });

      test('should not be equal with different values', () {
        // Arrange
        final record1 = ConsentRecord(
          isAccepted: true,
          acceptedAt: DateTime(2024, 1, 1),
          policyVersion: '1.0.0',
        );
        final record2 = ConsentRecord(
          isAccepted: false,
          acceptedAt: DateTime(2024, 1, 1),
          policyVersion: '1.0.0',
        );

        // Assert
        expect(record1, isNot(equals(record2)));
      });
    });
  });
}

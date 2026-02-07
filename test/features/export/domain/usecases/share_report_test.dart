import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/export/domain/usecases/share_report.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ShareReport useCase;
  late File testFile;

  setUp(() {
    useCase = ShareReport();
    testFile = File('test.pdf');

    // Mock the method channel for share_plus
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'shareFiles') {
          return 'success';
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      null,
    );
  });

  group('ShareReport', () {
    test('should share file without subject', () async {
      // Act & Assert
      expect(
        () async => await useCase(testFile),
        returnsNormally,
      );
    });

    test('should share file with subject', () async {
      // Arrange
      const subject = 'Trip Report';

      // Act & Assert
      expect(
        () async => await useCase(testFile, subject: subject),
        returnsNormally,
      );
    });
  });
}

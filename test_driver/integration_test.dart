import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes,
          [Map<String, Object?>? args]) async {
        final File image = File('screenshots/$screenshotName.png');
        await image.create(recursive: true);
        await image.writeAsBytes(screenshotBytes);
        return true;
      },
    );

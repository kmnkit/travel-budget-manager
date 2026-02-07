import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('TripWallet Screenshots', () {
    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      driver.close();
    });

    test('capture home screen', () async {
      await driver.waitFor(find.text('My Trips'));
      await Future.delayed(Duration(seconds: 1));
      // Screenshot will be taken by integration_test
    });

    test('capture trip list with data', () async {
      // Wait for trip list
      await driver.waitFor(find.byType('ListView'));
      await Future.delayed(Duration(seconds: 1));
    });

    test('capture expense screen', () async {
      // Tap on first trip if exists
      final tripCard = find.byType('Card');
      try {
        await driver.tap(tripCard);
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        // No trips yet, skip
      }
    });

    test('capture statistics screen', () async {
      // Navigate to statistics
      final statsTab = find.text('Statistics');
      try {
        await driver.tap(statsTab);
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        // Stats tab not found, skip
      }
    });

    test('capture settings screen', () async {
      // Navigate to settings
      final settingsIcon = find.byTooltip('Settings');
      try {
        await driver.tap(settingsIcon);
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        // Settings not found, skip
      }
    });
  });
}

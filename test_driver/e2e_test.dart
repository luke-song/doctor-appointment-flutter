// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import "dart:io";

void main() {
  group('Appointment Booking App', () {
    FlutterDriver driver;

    takeScreenshot(FlutterDriver driver, String path) async {
      final List<int> pixels = await driver.screenshot();
      final File file = new File(path);
      await file.writeAsBytes(pixels);
      print(path);
    }

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      new Directory("screenshots").create();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test('Take a screenshot of home screen', () async {
      // wait 5 seconds after loading the app
      sleep(const Duration(seconds: 5));
      // take a screenshot
      await takeScreenshot(driver, 'screenshots/home_screen.png');
      // that's it
    });
  });
}

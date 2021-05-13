import 'package:flutter_driver/flutter_driver.dart';
import 'package:pedantic/pedantic.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_print

void main() {
  group('main test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      unawaited(driver?.close());
    });

    test('Freefall strip and navigation', () async {
      // There's a loop animation (star ratings of comics) on the main page;
      // regularly the finder has to wait until animation finishes, and
      // runUnsynchronized lifts this restriction.
      await driver.runUnsynchronized(() async {
        print('Tapping "Freefall"...');
        await driver.tap(find.text('Freefall'));
      });
      print('Tapping "Go to page"...');
      await driver.tap(find.byTooltip('Перейти на страницу'));
      print('Awaiting "Go" button...');
      await driver.waitFor(find.text('Перейти'));
      print('Typing page number...');
      await driver.enterText('127');
      print('Tapping "Go"...');
      await driver.tap(find.text('Перейти'));
      print('Tapping "Next page"...');
      await driver.tap(find.byTooltip('Next page'));
      print('Awaiting page title...');
      await driver.waitFor(find.text('Поймал! Появление Пилозуба'));
    });
  });
}

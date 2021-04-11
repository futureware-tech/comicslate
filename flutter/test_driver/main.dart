import 'package:comicslate/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  // This line enables the extension. It must go before WidgetsFlutterBinding is
  // used.
  enableFlutterDriverExtension();
  // Call the `main()` of your app or call `runApp` with whatever widget
  // you are interested in testing.
  app.main();
}

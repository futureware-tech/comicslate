import 'dart:async';
import 'dart:convert';

import 'package:comicslate/flutter/styles.dart' as app_styles;
import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/models/storage.dart';
import 'package:comicslate/view/comic_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sentry/flutter_sentry.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provide/provide.dart';

void main() {
  FlutterSentry.wrap(() {
    // The class that contains all the providers. This shouldn't change after
    // being used.
    //
    // In this case, the ComicslateClient gets instantiated
    // the first time someone uses it, and lives as a singleton after that.
    final providers = Providers()
      ..provide(Provider.value(ComicslateClient(
        language: 'ru',
        offlineStorage: FlutterCachingAPIClient(
            cacheName: 'comicslate-client-json',
            responseParser: (js) => json.decode(utf8.decode(js))),
        prefetchCache: FlutterCachingAPIClient(
            cacheName: 'comicslate-client-images',
            responseParser: (bytes) => bytes),
      )));

    runApp(ProviderNode(providers: providers, child: MyApp()));
  }, dsn: 'https://b150cab29afe42278804731d11f2af9b@o336071.ingest.sentry.io/5230711');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Comicslate',
        theme: ThemeData(
          fontFamily: app_styles.kFontFamily,
          primaryColorDark: app_styles.kPrimaryColorDark,
          primaryColor: app_styles.kPrimaryColor,
          accentColor: app_styles.kAccentColor,
          primaryColorLight: app_styles.kPrimaryColorLight,
          dividerColor: app_styles.kDividerColor,
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: app_styles.kFontFamily,
                displayColor: app_styles.kPrimaryText,
                decorationColor: app_styles.kSecondaryText,
              ),
        ),
        home: ComicList(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizationsDelegate(),
        ],
        supportedLocales: const [
          // This list limits what locales Global Localizations delegates above
          // will support. The first element of this list is a fallback locale.
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future load(Locale locale) async {
    final name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    await initializeDateFormatting();
    Intl.defaultLocale = localeName;
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}

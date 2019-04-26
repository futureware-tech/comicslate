import 'dart:convert';

import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/models/storage.dart';
import 'package:comicslate/view/comic_list.dart';
import 'package:comicslate/view/helpers/comicslate_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.onError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final client = ComicslateClient(
      language: 'ru',
      offlineStorage: FlutterCachingAPIClient(
          cacheName: 'comicslate-client-json',
          responseParser: (js) => json.decode(utf8.decode(js))),
      prefetchCache: FlutterCachingAPIClient(
          cacheName: 'comicslate-client-images',
          responseParser: (bytes) => bytes),
    );

    return MaterialApp(
      title: 'Comicslate',
      theme: ThemeData(
          fontFamily: 'DatFestComic',
          primaryColorDark: const Color(0xFF00796B),
          primaryColor: const Color(0xFF009688),
          accentColor: const Color(0xFF795548),
          primaryColorLight: const Color(0xFFB2DFDB),
          dividerColor: const Color(0xFFBDBDBD),
          textTheme: Theme.of(context).textTheme.apply(
              displayColor: const Color(0xFF212121),
              decorationColor: const Color(0xFF757575))),
      // If Inherited widget assigned to build param, it will be recreated
      // every time(rotation, set state, etc). Therefore create it here once.
      home: ComicslateClientWidget(client: client, child: ComicList()),
      localizationsDelegates: [
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

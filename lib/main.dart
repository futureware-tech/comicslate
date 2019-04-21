import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/models/storage.dart';
import 'package:comicslate/view/comic_list.dart';
import 'package:comicslate/view/helpers/comicslate_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final client = ComicslateClient(
        language: 'ru', cache: FlutterCacheStorage(DefaultCacheManager()));

    return MaterialApp(
      title: 'Comicslate',
      theme: ThemeData(
          fontFamily: 'DatFestComic',
          primaryColorDark: const Color(0xFF00796B),
          primaryColor: const Color(0xFF009688),
          accentColor: const Color(0xFFFFEB3B),
          primaryColorLight: const Color(0xFFB2DFDB),
          dividerColor: const Color(0xFFBDBDBD),
          textTheme: Theme.of(context).textTheme.apply(
              displayColor: const Color(0xFF212121),
              decorationColor: const Color(0xFF757575))),
      builder: (context, child) =>
          ComicslateClientWidget(client: client, child: child),
      home: ComicList(client: client),
    );
  }
}

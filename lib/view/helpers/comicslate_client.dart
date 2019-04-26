import 'dart:convert';

import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/models/storage.dart';
import 'package:flutter/material.dart';

@immutable
class ComicslateClientWidget {
  final ComicslateClient client;

  ComicslateClientWidget()
      : client = ComicslateClient(
          language: 'ru',
          offlineStorage: FlutterCachingAPIClient(
              cacheName: 'comicslate-client-json',
              responseParser: (js) => json.decode(utf8.decode(js))),
          prefetchCache: FlutterCachingAPIClient(
              cacheName: 'comicslate-client-images',
              responseParser: (bytes) => bytes),
        );
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:comicslate/models/storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'serializers.dart';

@immutable
class ComicslateClient {
  final String language;
  final Storage offlineStorage;
  final Storage prefetchCache;

  static final Uri _baseUri = Uri.parse('https://app.comicslate.org/');

  const ComicslateClient({
    @required this.language,
    @required this.offlineStorage,
    @required this.prefetchCache,
  });

  Future<http.Response> request(String path) async {
    final response =
        await http.get(_baseUri.replace(path: path).toString(), headers: {
      HttpHeaders.acceptLanguageHeader: language,
    });
    if (response.statusCode != 200) {
      try {
        throw Exception('$path: ${json.decode(response.body)}');
      } on FormatException catch (e) {
        throw Exception('$path: $e: ${response.body}');
      }
    }
    return response;
  }

  Future<dynamic> requestJson(String path) async {
    String body;
    try {
      body = (await request(path)).body;
      offlineStorage[path] = utf8.encode(body);
    } on SocketException {
      final offlineData = await offlineStorage[path];
      if (offlineData == null) {
        rethrow;
      }
      body = utf8.decode(offlineData);
    }
    return json.decode(body);
  }

  Future<List<Comic>> getComicsList() async {
    final List comics = await requestJson('comics');
    return comics
        .map((comic) => serializers.deserializeWith(Comic.serializer, comic))
        .toList();
  }

  Future<List<String>> getStoryStripsList(Comic comic) async =>
      List<String>.from(
          (await requestJson('comics/${comic.id}/strips'))['storyStrips']);

  Future<ComicStrip> _fetchStrip(
    Comic comic,
    String stripId, {
    @required bool allowFromCache,
  }) async {
    final stripMetaPath = 'comics/${comic.id}/strips/$stripId';
    dynamic jsonData;

    if (allowFromCache) {
      final cachedBytes = await prefetchCache[stripMetaPath];
      if (cachedBytes != null) {
        jsonData = json.decode(utf8.decode(cachedBytes));
      }
    }
    if (jsonData == null) {
      jsonData = await requestJson(stripMetaPath);
      prefetchCache[stripMetaPath] = utf8.encode(json.encode(jsonData));
    }
    final strip = serializers.deserializeWith(ComicStrip.serializer, jsonData);

    final stripRenderPath = '$stripMetaPath/render';
    Uint8List imageBytes;
    if (allowFromCache) {
      imageBytes = await prefetchCache[stripRenderPath];
    }
    if (imageBytes == null) {
      try {
        imageBytes =
            (await request('comics/${comic.id}/strips/$stripId/render'))
                .bodyBytes;
      } catch (e) {
        print(e);
      }
      if (imageBytes != null) {
        prefetchCache[stripRenderPath] = imageBytes;
      }
    }

    return strip.rebuild((b) => b.imageBytes = imageBytes);
  }

  Future<ComicStrip> getStrip(
    Comic comic,
    String stripId, {
    bool allowFromCache = true,
    List<String> prefetch = const [],
  }) async {
    final strip =
        await _fetchStrip(comic, stripId, allowFromCache: allowFromCache);
    for (final prefetchStripId in prefetch) {
      if (prefetchStripId != stripId) {
        // Intentionally do not await to fetch in background.
        _fetchStrip(comic, prefetchStripId, allowFromCache: true);
      }
    }
    return strip;
  }
}

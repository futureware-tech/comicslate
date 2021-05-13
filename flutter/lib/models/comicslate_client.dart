import 'dart:io';
import 'dart:typed_data';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:comicslate/models/serializers.dart';
import 'package:comicslate/models/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

@immutable
class ComicslateClient {
  final String language;
  final CachingAPIClient<dynamic> offlineStorage;
  final CachingAPIClient<Uint8List> prefetchCache;

  static final Uri _baseUri = Uri.parse('https://app.comicslate.org/');

  const ComicslateClient({
    @required this.language,
    @required this.offlineStorage,
    @required this.prefetchCache,
  });

  /*Future<http.Response> request(String path,
      [Map<String, dynamic> queryParameters = const {}]) async {
    final response = await http.get(
        _baseUri
            .replace(path: path, queryParameters: queryParameters)
            .toString(),
        headers: {
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
      }*/

  Future<void> emptyCache() =>
      Future.wait([offlineStorage.emptyCache(), prefetchCache.emptyCache()]);

  Stream<dynamic> requestJson(String path, {bool allowFromCache = true}) =>
      offlineStorage.get(_baseUri.replace(path: path),
          allowFromCache: allowFromCache);

  Stream<List<Comic>> getComicsList() =>
      requestJson('comics').cast<List<dynamic>>().map((comics) => comics
          .map((dynamic comic) =>
              serializers.deserializeWith(Comic.serializer, comic))
          .where((comic) => comic.firstStripRenders == true)
          .toList());

  Stream<List<String>> getStoryStripsList(Comic comic) =>
      requestJson('comics/${comic.id}/strips').map((dynamic data) =>
          List<String>.from((data as Map<String, dynamic>)['storyStrips']
              as Iterable<dynamic>));

  Stream<ComicStrip> getStrip(
    Comic comic,
    String stripId, {
    bool allowFromCache = true,
    List<String> prefetch = const [],
  }) async* {
    unawaited(() async {
      // Wait a little before prefetching, so that the strip we are currently
      // trying to fetch gets all the bandwidth.
      await Future<void>.delayed(const Duration(seconds: 3));

      offlineStorage.prefetch(prefetch.map((prefetchStripId) => _baseUri
          .replace(path: 'comics/${comic.id}/strips/$prefetchStripId')));
      prefetchCache.prefetch(prefetch.map((prefetchStripId) => _baseUri.replace(
          path: 'comics/${comic.id}/strips/$prefetchStripId/render')));
    }());

    final stripMetaPath = 'comics/${comic.id}/strips/$stripId';
    await for (final stripJson
        in requestJson(stripMetaPath, allowFromCache: allowFromCache)) {
      final strip =
          serializers.deserializeWith(ComicStrip.serializer, stripJson);
      final stripRenderPath = '$stripMetaPath/render';
      try {
        final params = <String, String>{};
        if (!allowFromCache) {
          params['refresh'] = '1';
        }
        await for (final imageBytes in prefetchCache.get(
            _baseUri.replace(
              path: stripRenderPath,
              // Must pass null, otherwise Uri.toString() will have '?' at the
              // end, invalidating cache.
              queryParameters: params.isEmpty ? null : params,
            ),
            allowFromCache: allowFromCache)) {
          yield strip.rebuild((b) => b.imageBytes = imageBytes);
        }
      } on HttpException catch (e) {
        debugPrint('HttpException getting strip: $e');
        yield strip.rebuild((b) => b.title ??= e.message);
      } catch (e) {
        debugPrint('Unclassified error getting strip: $e');
        yield strip;
      }
    }
  }
}

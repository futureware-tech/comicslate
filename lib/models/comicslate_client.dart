import 'dart:convert';
import 'dart:io';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'serializers.dart';

@immutable
class ComicslateClient {
  final String language;
  final BaseCacheManager cache;

  static final Uri _baseUri = Uri.parse('https://app.comicslate.org/');

  const ComicslateClient({
    @required this.language,
    @required this.cache,
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
      cache.putFile(path, utf8.encode(body));
    } on SocketException {
      final fileInfo = await cache.getFileFromCache(path);
      if (fileInfo == null) {
        rethrow;
      }
      body = fileInfo.file.readAsStringSync();
    }
    return json.decode(body);
  }

  Future<List<Comic>> getComicsList([String filter = '']) async {
    final List comics = await requestJson('comics/$filter');
    return comics
        .map((comic) => serializers.deserializeWith(Comic.serializer, comic))
        .toList();
  }

  Future<List<String>> getStoryStripsList(Comic comic) async =>
      List<String>.from(
          (await requestJson('comics/${comic.id}/strips'))['storyStrips']);

  Future<ComicStrip> getStrip(Comic comic, String stripId) async {
    var strip = serializers.deserializeWith(ComicStrip.serializer,
        await requestJson('comics/${comic.id}/strips/$stripId'));
    try {
      final imageBytes =
          (await request('comics/${comic.id}/strips/$stripId/render'))
              .bodyBytes;
      strip = strip.rebuild((b) => b.imageBytes = imageBytes);
    } catch (e) {
      print(e);
    }

    return strip;
  }
}

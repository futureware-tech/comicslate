import 'dart:convert';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'serializers.dart';

// TODO(dotdoom): return real data instead of mocks.
@immutable
class ComicslateClient {
  final String language;

  static final Uri _baseUri = Uri.parse('https://app.comicslate.org/');

  const ComicslateClient({@required this.language});

  Future<http.Response> request(String path) =>
      http.get(_baseUri.replace(path: path).toString());

  Future<dynamic> requestJson(String path) async {
    final response = await request(path);
    if (response.statusCode != 200) {
      try {
        throw Exception('$path: ${json.decode(response.body)}');
      } on FormatException catch (e) {
        throw Exception('$path: $e: ${response.body}');
      }
    }
    return json.decode(response.body);
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

  Future<ComicStrip> renderStrip(Comic comic, String stripId) async {
    final stripResponse =
        await request('comics/${comic.id}/strips/$stripId/render');
    if (stripResponse.statusCode == 200) {
      return serializers
          .deserializeWith(ComicStrip.serializer,
              await requestJson('comics/${comic.id}/strips/$stripId'))
          .rebuild((b) => b.imageBytes = stripResponse.bodyBytes);
    } else {
      throw Exception(json.decode(stripResponse.body));
    }
  }
}

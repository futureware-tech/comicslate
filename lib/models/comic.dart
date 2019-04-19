import 'dart:convert';

import 'package:comicslate/models/comic_strip.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

@immutable
class Comic {
  final String id;
  final String name;
  final String category;
  final int numberOfStrips;
  final Uri homePageURL;
  final Uri thumbnailURL;
  final bool isActive;

  const Comic({
    @required this.id,
    @required this.name,
    @required this.category,
    @required this.numberOfStrips,
    @required this.homePageURL,
    @required this.isActive,
    @required this.thumbnailURL,
  });

  Future<Iterable<String>> getStoryStripsList() async {
    final Map<String, dynamic> json = jsonDecode(
        (await http.get('https://app.comicslate.org/comics/$id/strips')).body);
    return List<String>.from(json['storyStrips']);
  }

  Future<ComicStrip> getComicsStrip(String stripId) async {
    final stripResponse = await http
        .get('https://app.comicslate.org/comics/$id/strips/$stripId/render');
    return ComicStrip(
      url: Uri.parse('https://comicslate.org/ru/sci-fi/freefall/0002'),
      imageBytes: stripResponse.bodyBytes,
    );
  }
}

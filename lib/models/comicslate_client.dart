import 'dart:convert';

import 'package:comicslate/models/comic.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

// TODO(dotdoom): return real data instead of mocks.
@immutable
class ComicslateClient {
  final String language;

  const ComicslateClient({@required this.language});

  Future<List<Comic>> getComicsList() async {
    final List<dynamic> json =
        jsonDecode((await http.get('https://app.comicslate.org/comics')).body);

    return json
        .map((json) => Comic(
              id: json['id'],
              homePageURL: Uri.parse(json['homePageURL']),
              category: json['category'],
              isActive: json['isActive'],
              name: json['name'],
              numberOfStrips: json['numberOfStrips'],
              thumbnailURL: json['thumbnailURL'] == null
                  ? null
                  : Uri.parse(json['thumbnailURL']),
            ))
        .toList();
  }
}

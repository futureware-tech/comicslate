import 'dart:io';

import 'package:comicslate/models/comics_strip.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

@immutable
class Comics {
  final String id;
  final String name;
  final int numberOfStrips;
  final Uri homePageURL;
  final Uri thumbnailURL;
  final int rating;
  final DateTime updatedAt;

  const Comics({
    @required this.id,
    @required this.name,
    @required this.numberOfStrips,
    @required this.homePageURL,
    @required this.rating,
    @required this.updatedAt,
    @required this.thumbnailURL,
  });

  Future<Iterable<String>> getStoryStripsList() async {
    switch (id) {
      case 'sci-fi:freefall':
        final format4digits = NumberFormat('0000');
        return Iterable.generate(3500).map(format4digits.format);
      case 'sci-fi:commander-kitty':
        return Iterable.generate(115).map((x) => x.toString());
    }
    return [];
  }

  Future<ComicsStrip> getComicsStrip(String stripId) async {
    final stripResponse = (await (await HttpClient().getUrl(Uri.parse(
            'http://pix.academ.info/images/img/2016/02/04/d6a8ce6c13151c9c3b7c8e782d400806.png')))
        .close());
    final stripData = <int>[];
    await for (final chunk in stripResponse) {
      stripData.addAll(chunk);
    }
    return ComicsStrip(
      url: Uri.parse('https://comicslate.org/ru/sci-fi/freefall/0002'),
      imageFormat: ImageFormat.PNG,
      imageBytes: stripData,
    );
  }
}

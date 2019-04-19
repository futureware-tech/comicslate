import 'package:comicslate/models/comics_strip.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    switch (id) {
      case 'sci-fi:freefall':
        final format4digits = NumberFormat('0000');
        return Iterable.generate(3500)
            .map(format4digits.format)
            .where((x) => x != '0000');
      case 'sci-fi:commander-kitty':
        return Iterable.generate(115).map((x) => x.toString());
    }
    return [];
  }

  Future<ComicsStrip> getComicsStrip(String stripId) async {
    final stripResponse =
        await http.get('https://app.comicslate.org/strips/$id:$stripId/render');
    return ComicsStrip(
      url: Uri.parse('https://comicslate.org/ru/sci-fi/freefall/0002'),
      imageBytes: stripResponse.bodyBytes,
    );
  }
}

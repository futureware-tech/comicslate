import 'package:comicslate/models/comic.dart';
import 'package:meta/meta.dart';

// TODO(dotdoom): return real data instead of mocks.
@immutable
class ComicslateClient {
  final String language;

  const ComicslateClient({@required this.language});

  Future<List<Comic>> getComicsList() async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}

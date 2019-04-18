import 'package:comicslate/models/comics.dart';
import 'package:meta/meta.dart';

@immutable
class ComicsCategory {
  final String name;
  final String id;
  final List<Comics> comicses;

  ComicsCategory({
    @required this.name,
    @required this.id,
    @required this.comicses,
  });
}

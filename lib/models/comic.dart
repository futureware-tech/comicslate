import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comic.g.dart';

abstract class Comic implements Built<Comic, ComicBuilder> {
  String get id;

  Uri get homePageURL;

  @nullable
  String get name;

  @nullable
  String get category;

  @nullable
  int get numberOfStrips;

  @nullable
  Uri get thumbnailURL;

  @nullable
  bool get isActive;

  static Serializer<Comic> get serializer => _$comicSerializer;
  factory Comic([void Function(ComicBuilder) updates]) = _$Comic;
  Comic._();
}

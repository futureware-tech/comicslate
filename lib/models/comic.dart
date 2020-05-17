import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comic.g.dart';

class ComicRatingColor extends EnumClass {
  @BuiltValueEnumConst(wireName: 'PUST')
  static const ComicRatingColor empty = _$empty;

  @BuiltValueEnumConst(wireName: 'BRNZ')
  static const ComicRatingColor bronze = _$bronze;

  @BuiltValueEnumConst(wireName: 'SILV')
  static const ComicRatingColor silver = _$silver;

  @BuiltValueEnumConst(wireName: 'GOLD')
  static const ComicRatingColor gold = _$gold;

  static Serializer<ComicRatingColor> get serializer =>
      _$comicRatingColorSerializer;
  const ComicRatingColor._(String name) : super(name);
  static BuiltSet<ComicRatingColor> get values => _$values;
  static ComicRatingColor valueOf(String name) => _$valueOf(name);
}

abstract class Comic implements Built<Comic, ComicBuilder> {
  String get id;

  Uri get homePageURL;

  @nullable
  String get name;

  @nullable
  String get categoryName;

  @nullable
  Uri get thumbnailURL;

  @nullable
  bool get isActive;

  @nullable
  ComicRatingColor get ratingColor;

  @nullable
  bool get firstStripRenders;

  static Serializer<Comic> get serializer => _$comicSerializer;
  factory Comic([void Function(ComicBuilder) updates]) = _$Comic;
  Comic._();
}

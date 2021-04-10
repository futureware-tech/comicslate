import 'dart:typed_data';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comic_strip.g.dart';

abstract class ComicStrip implements Built<ComicStrip, ComicStripBuilder> {
  Uri get displayUrl;
  Uri get shareUrl;

  @nullable
  String get title;

  @nullable
  DateTime get lastModified;

  @nullable
  DateTime get lastRendered;

  @nullable
  String get author;

  @nullable
  int get version;

  @nullable
  Uint8List get imageBytes;

  static Serializer<ComicStrip> get serializer => _$comicStripSerializer;
  factory ComicStrip([void Function(ComicStripBuilder) updates]) = _$ComicStrip;
  ComicStrip._();
}

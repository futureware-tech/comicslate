// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComicRatingColor _$empty = const ComicRatingColor._('empty');
const ComicRatingColor _$bronze = const ComicRatingColor._('bronze');
const ComicRatingColor _$silver = const ComicRatingColor._('silver');
const ComicRatingColor _$gold = const ComicRatingColor._('gold');

ComicRatingColor _$valueOf(String name) {
  switch (name) {
    case 'empty':
      return _$empty;
    case 'bronze':
      return _$bronze;
    case 'silver':
      return _$silver;
    case 'gold':
      return _$gold;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ComicRatingColor> _$values =
    new BuiltSet<ComicRatingColor>(const <ComicRatingColor>[
  _$empty,
  _$bronze,
  _$silver,
  _$gold,
]);

Serializer<ComicRatingColor> _$comicRatingColorSerializer =
    new _$ComicRatingColorSerializer();
Serializer<Comic> _$comicSerializer = new _$ComicSerializer();

class _$ComicRatingColorSerializer
    implements PrimitiveSerializer<ComicRatingColor> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'empty': 'PUST',
    'bronze': 'BRNZ',
    'silver': 'SILV',
    'gold': 'GOLD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUST': 'empty',
    'BRNZ': 'bronze',
    'SILV': 'silver',
    'GOLD': 'gold',
  };

  @override
  final Iterable<Type> types = const <Type>[ComicRatingColor];
  @override
  final String wireName = 'ComicRatingColor';

  @override
  Object serialize(Serializers serializers, ComicRatingColor object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComicRatingColor deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComicRatingColor.valueOf(_fromWire[serialized] ?? serialized as String);
}

class _$ComicSerializer implements StructuredSerializer<Comic> {
  @override
  final Iterable<Type> types = const [Comic, _$Comic];
  @override
  final String wireName = 'Comic';

  @override
  Iterable<Object> serialize(Serializers serializers, Comic object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'homePageURL',
      serializers.serialize(object.homePageURL,
          specifiedType: const FullType(Uri)),
    ];
    Object value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.categoryName;
    if (value != null) {
      result
        ..add('categoryName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.thumbnailURL;
    if (value != null) {
      result
        ..add('thumbnailURL')
        ..add(serializers.serialize(value, specifiedType: const FullType(Uri)));
    }
    value = object.isActive;
    if (value != null) {
      result
        ..add('isActive')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.ratingColor;
    if (value != null) {
      result
        ..add('ratingColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ComicRatingColor)));
    }
    value = object.firstStripRenders;
    if (value != null) {
      result
        ..add('firstStripRenders')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Comic deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ComicBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'homePageURL':
          result.homePageURL = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'categoryName':
          result.categoryName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'thumbnailURL':
          result.thumbnailURL = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
        case 'isActive':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'ratingColor':
          result.ratingColor = serializers.deserialize(value,
                  specifiedType: const FullType(ComicRatingColor))
              as ComicRatingColor;
          break;
        case 'firstStripRenders':
          result.firstStripRenders = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Comic extends Comic {
  @override
  final String id;
  @override
  final Uri homePageURL;
  @override
  final String name;
  @override
  final String categoryName;
  @override
  final Uri thumbnailURL;
  @override
  final bool isActive;
  @override
  final ComicRatingColor ratingColor;
  @override
  final bool firstStripRenders;

  factory _$Comic([void Function(ComicBuilder) updates]) =>
      (new ComicBuilder()..update(updates)).build();

  _$Comic._(
      {this.id,
      this.homePageURL,
      this.name,
      this.categoryName,
      this.thumbnailURL,
      this.isActive,
      this.ratingColor,
      this.firstStripRenders})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Comic', 'id');
    BuiltValueNullFieldError.checkNotNull(homePageURL, 'Comic', 'homePageURL');
  }

  @override
  Comic rebuild(void Function(ComicBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComicBuilder toBuilder() => new ComicBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Comic &&
        id == other.id &&
        homePageURL == other.homePageURL &&
        name == other.name &&
        categoryName == other.categoryName &&
        thumbnailURL == other.thumbnailURL &&
        isActive == other.isActive &&
        ratingColor == other.ratingColor &&
        firstStripRenders == other.firstStripRenders;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), homePageURL.hashCode),
                            name.hashCode),
                        categoryName.hashCode),
                    thumbnailURL.hashCode),
                isActive.hashCode),
            ratingColor.hashCode),
        firstStripRenders.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Comic')
          ..add('id', id)
          ..add('homePageURL', homePageURL)
          ..add('name', name)
          ..add('categoryName', categoryName)
          ..add('thumbnailURL', thumbnailURL)
          ..add('isActive', isActive)
          ..add('ratingColor', ratingColor)
          ..add('firstStripRenders', firstStripRenders))
        .toString();
  }
}

class ComicBuilder implements Builder<Comic, ComicBuilder> {
  _$Comic _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  Uri _homePageURL;
  Uri get homePageURL => _$this._homePageURL;
  set homePageURL(Uri homePageURL) => _$this._homePageURL = homePageURL;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _categoryName;
  String get categoryName => _$this._categoryName;
  set categoryName(String categoryName) => _$this._categoryName = categoryName;

  Uri _thumbnailURL;
  Uri get thumbnailURL => _$this._thumbnailURL;
  set thumbnailURL(Uri thumbnailURL) => _$this._thumbnailURL = thumbnailURL;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  ComicRatingColor _ratingColor;
  ComicRatingColor get ratingColor => _$this._ratingColor;
  set ratingColor(ComicRatingColor ratingColor) =>
      _$this._ratingColor = ratingColor;

  bool _firstStripRenders;
  bool get firstStripRenders => _$this._firstStripRenders;
  set firstStripRenders(bool firstStripRenders) =>
      _$this._firstStripRenders = firstStripRenders;

  ComicBuilder();

  ComicBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _homePageURL = $v.homePageURL;
      _name = $v.name;
      _categoryName = $v.categoryName;
      _thumbnailURL = $v.thumbnailURL;
      _isActive = $v.isActive;
      _ratingColor = $v.ratingColor;
      _firstStripRenders = $v.firstStripRenders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Comic other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Comic;
  }

  @override
  void update(void Function(ComicBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Comic build() {
    final _$result = _$v ??
        new _$Comic._(
            id: BuiltValueNullFieldError.checkNotNull(id, 'Comic', 'id'),
            homePageURL: BuiltValueNullFieldError.checkNotNull(
                homePageURL, 'Comic', 'homePageURL'),
            name: name,
            categoryName: categoryName,
            thumbnailURL: thumbnailURL,
            isActive: isActive,
            ratingColor: ratingColor,
            firstStripRenders: firstStripRenders);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

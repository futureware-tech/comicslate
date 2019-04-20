// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Comic> _$comicSerializer = new _$ComicSerializer();

class _$ComicSerializer implements StructuredSerializer<Comic> {
  @override
  final Iterable<Type> types = const [Comic, _$Comic];
  @override
  final String wireName = 'Comic';

  @override
  Iterable serialize(Serializers serializers, Comic object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'homePageURL',
      serializers.serialize(object.homePageURL,
          specifiedType: const FullType(Uri)),
    ];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.category != null) {
      result
        ..add('category')
        ..add(serializers.serialize(object.category,
            specifiedType: const FullType(String)));
    }
    if (object.numberOfStrips != null) {
      result
        ..add('numberOfStrips')
        ..add(serializers.serialize(object.numberOfStrips,
            specifiedType: const FullType(int)));
    }
    if (object.thumbnailURL != null) {
      result
        ..add('thumbnailURL')
        ..add(serializers.serialize(object.thumbnailURL,
            specifiedType: const FullType(Uri)));
    }
    if (object.isActive != null) {
      result
        ..add('isActive')
        ..add(serializers.serialize(object.isActive,
            specifiedType: const FullType(bool)));
    }

    return result;
  }

  @override
  Comic deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ComicBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
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
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'numberOfStrips':
          result.numberOfStrips = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'thumbnailURL':
          result.thumbnailURL = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
        case 'isActive':
          result.isActive = serializers.deserialize(value,
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
  final String category;
  @override
  final int numberOfStrips;
  @override
  final Uri thumbnailURL;
  @override
  final bool isActive;

  factory _$Comic([void Function(ComicBuilder) updates]) =>
      (new ComicBuilder()..update(updates)).build();

  _$Comic._(
      {this.id,
      this.homePageURL,
      this.name,
      this.category,
      this.numberOfStrips,
      this.thumbnailURL,
      this.isActive})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Comic', 'id');
    }
    if (homePageURL == null) {
      throw new BuiltValueNullFieldError('Comic', 'homePageURL');
    }
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
        category == other.category &&
        numberOfStrips == other.numberOfStrips &&
        thumbnailURL == other.thumbnailURL &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), homePageURL.hashCode),
                        name.hashCode),
                    category.hashCode),
                numberOfStrips.hashCode),
            thumbnailURL.hashCode),
        isActive.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Comic')
          ..add('id', id)
          ..add('homePageURL', homePageURL)
          ..add('name', name)
          ..add('category', category)
          ..add('numberOfStrips', numberOfStrips)
          ..add('thumbnailURL', thumbnailURL)
          ..add('isActive', isActive))
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

  String _category;
  String get category => _$this._category;
  set category(String category) => _$this._category = category;

  int _numberOfStrips;
  int get numberOfStrips => _$this._numberOfStrips;
  set numberOfStrips(int numberOfStrips) =>
      _$this._numberOfStrips = numberOfStrips;

  Uri _thumbnailURL;
  Uri get thumbnailURL => _$this._thumbnailURL;
  set thumbnailURL(Uri thumbnailURL) => _$this._thumbnailURL = thumbnailURL;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  ComicBuilder();

  ComicBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _homePageURL = _$v.homePageURL;
      _name = _$v.name;
      _category = _$v.category;
      _numberOfStrips = _$v.numberOfStrips;
      _thumbnailURL = _$v.thumbnailURL;
      _isActive = _$v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Comic other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
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
            id: id,
            homePageURL: homePageURL,
            name: name,
            category: category,
            numberOfStrips: numberOfStrips,
            thumbnailURL: thumbnailURL,
            isActive: isActive);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

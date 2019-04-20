// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_strip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ComicStrip> _$comicStripSerializer = new _$ComicStripSerializer();

class _$ComicStripSerializer implements StructuredSerializer<ComicStrip> {
  @override
  final Iterable<Type> types = const [ComicStrip, _$ComicStrip];
  @override
  final String wireName = 'ComicStrip';

  @override
  Iterable serialize(Serializers serializers, ComicStrip object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(Uri)),
    ];
    if (object.title != null) {
      result
        ..add('title')
        ..add(serializers.serialize(object.title,
            specifiedType: const FullType(String)));
    }
    if (object.lastModified != null) {
      result
        ..add('lastModified')
        ..add(serializers.serialize(object.lastModified,
            specifiedType: const FullType(DateTime)));
    }
    if (object.author != null) {
      result
        ..add('author')
        ..add(serializers.serialize(object.author,
            specifiedType: const FullType(String)));
    }
    if (object.version != null) {
      result
        ..add('version')
        ..add(serializers.serialize(object.version,
            specifiedType: const FullType(int)));
    }
    if (object.imageBytes != null) {
      result
        ..add('imageBytes')
        ..add(serializers.serialize(object.imageBytes,
            specifiedType: const FullType(Uint8List)));
    }

    return result;
  }

  @override
  ComicStrip deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ComicStripBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'lastModified':
          result.lastModified = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'imageBytes':
          result.imageBytes = serializers.deserialize(value,
              specifiedType: const FullType(Uint8List)) as Uint8List;
          break;
      }
    }

    return result.build();
  }
}

class _$ComicStrip extends ComicStrip {
  @override
  final Uri url;
  @override
  final String title;
  @override
  final DateTime lastModified;
  @override
  final String author;
  @override
  final int version;
  @override
  final Uint8List imageBytes;

  factory _$ComicStrip([void Function(ComicStripBuilder) updates]) =>
      (new ComicStripBuilder()..update(updates)).build();

  _$ComicStrip._(
      {this.url,
      this.title,
      this.lastModified,
      this.author,
      this.version,
      this.imageBytes})
      : super._() {
    if (url == null) {
      throw new BuiltValueNullFieldError('ComicStrip', 'url');
    }
  }

  @override
  ComicStrip rebuild(void Function(ComicStripBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComicStripBuilder toBuilder() => new ComicStripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComicStrip &&
        url == other.url &&
        title == other.title &&
        lastModified == other.lastModified &&
        author == other.author &&
        version == other.version &&
        imageBytes == other.imageBytes;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, url.hashCode), title.hashCode),
                    lastModified.hashCode),
                author.hashCode),
            version.hashCode),
        imageBytes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ComicStrip')
          ..add('url', url)
          ..add('title', title)
          ..add('lastModified', lastModified)
          ..add('author', author)
          ..add('version', version)
          ..add('imageBytes', imageBytes))
        .toString();
  }
}

class ComicStripBuilder implements Builder<ComicStrip, ComicStripBuilder> {
  _$ComicStrip _$v;

  Uri _url;
  Uri get url => _$this._url;
  set url(Uri url) => _$this._url = url;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  DateTime _lastModified;
  DateTime get lastModified => _$this._lastModified;
  set lastModified(DateTime lastModified) =>
      _$this._lastModified = lastModified;

  String _author;
  String get author => _$this._author;
  set author(String author) => _$this._author = author;

  int _version;
  int get version => _$this._version;
  set version(int version) => _$this._version = version;

  Uint8List _imageBytes;
  Uint8List get imageBytes => _$this._imageBytes;
  set imageBytes(Uint8List imageBytes) => _$this._imageBytes = imageBytes;

  ComicStripBuilder();

  ComicStripBuilder get _$this {
    if (_$v != null) {
      _url = _$v.url;
      _title = _$v.title;
      _lastModified = _$v.lastModified;
      _author = _$v.author;
      _version = _$v.version;
      _imageBytes = _$v.imageBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComicStrip other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ComicStrip;
  }

  @override
  void update(void Function(ComicStripBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ComicStrip build() {
    final _$result = _$v ??
        new _$ComicStrip._(
            url: url,
            title: title,
            lastModified: lastModified,
            author: author,
            version: version,
            imageBytes: imageBytes);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

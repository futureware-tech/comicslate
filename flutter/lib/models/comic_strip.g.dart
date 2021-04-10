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
  Iterable<Object> serialize(Serializers serializers, ComicStrip object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'displayUrl',
      serializers.serialize(object.displayUrl,
          specifiedType: const FullType(Uri)),
      'shareUrl',
      serializers.serialize(object.shareUrl,
          specifiedType: const FullType(Uri)),
    ];
    Object value;
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.lastModified;
    if (value != null) {
      result
        ..add('lastModified')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.lastRendered;
    if (value != null) {
      result
        ..add('lastRendered')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.author;
    if (value != null) {
      result
        ..add('author')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.version;
    if (value != null) {
      result
        ..add('version')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.imageBytes;
    if (value != null) {
      result
        ..add('imageBytes')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(Uint8List)));
    }
    return result;
  }

  @override
  ComicStrip deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ComicStripBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'displayUrl':
          result.displayUrl = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
        case 'shareUrl':
          result.shareUrl = serializers.deserialize(value,
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
        case 'lastRendered':
          result.lastRendered = serializers.deserialize(value,
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
  final Uri displayUrl;
  @override
  final Uri shareUrl;
  @override
  final String title;
  @override
  final DateTime lastModified;
  @override
  final DateTime lastRendered;
  @override
  final String author;
  @override
  final int version;
  @override
  final Uint8List imageBytes;

  factory _$ComicStrip([void Function(ComicStripBuilder) updates]) =>
      (new ComicStripBuilder()..update(updates)).build();

  _$ComicStrip._(
      {this.displayUrl,
      this.shareUrl,
      this.title,
      this.lastModified,
      this.lastRendered,
      this.author,
      this.version,
      this.imageBytes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        displayUrl, 'ComicStrip', 'displayUrl');
    BuiltValueNullFieldError.checkNotNull(shareUrl, 'ComicStrip', 'shareUrl');
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
        displayUrl == other.displayUrl &&
        shareUrl == other.shareUrl &&
        title == other.title &&
        lastModified == other.lastModified &&
        lastRendered == other.lastRendered &&
        author == other.author &&
        version == other.version &&
        imageBytes == other.imageBytes;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, displayUrl.hashCode), shareUrl.hashCode),
                            title.hashCode),
                        lastModified.hashCode),
                    lastRendered.hashCode),
                author.hashCode),
            version.hashCode),
        imageBytes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ComicStrip')
          ..add('displayUrl', displayUrl)
          ..add('shareUrl', shareUrl)
          ..add('title', title)
          ..add('lastModified', lastModified)
          ..add('lastRendered', lastRendered)
          ..add('author', author)
          ..add('version', version)
          ..add('imageBytes', imageBytes))
        .toString();
  }
}

class ComicStripBuilder implements Builder<ComicStrip, ComicStripBuilder> {
  _$ComicStrip _$v;

  Uri _displayUrl;
  Uri get displayUrl => _$this._displayUrl;
  set displayUrl(Uri displayUrl) => _$this._displayUrl = displayUrl;

  Uri _shareUrl;
  Uri get shareUrl => _$this._shareUrl;
  set shareUrl(Uri shareUrl) => _$this._shareUrl = shareUrl;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  DateTime _lastModified;
  DateTime get lastModified => _$this._lastModified;
  set lastModified(DateTime lastModified) =>
      _$this._lastModified = lastModified;

  DateTime _lastRendered;
  DateTime get lastRendered => _$this._lastRendered;
  set lastRendered(DateTime lastRendered) =>
      _$this._lastRendered = lastRendered;

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
    final $v = _$v;
    if ($v != null) {
      _displayUrl = $v.displayUrl;
      _shareUrl = $v.shareUrl;
      _title = $v.title;
      _lastModified = $v.lastModified;
      _lastRendered = $v.lastRendered;
      _author = $v.author;
      _version = $v.version;
      _imageBytes = $v.imageBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComicStrip other) {
    ArgumentError.checkNotNull(other, 'other');
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
            displayUrl: BuiltValueNullFieldError.checkNotNull(
                displayUrl, 'ComicStrip', 'displayUrl'),
            shareUrl: BuiltValueNullFieldError.checkNotNull(
                shareUrl, 'ComicStrip', 'shareUrl'),
            title: title,
            lastModified: lastModified,
            lastRendered: lastRendered,
            author: author,
            version: version,
            imageBytes: imageBytes);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

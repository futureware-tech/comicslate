import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class Storage {
  Future<Uint8List> operator [](String key);
  void operator []=(String key, Uint8List value);
}

class FlutterCacheStorage implements Storage {
  final BaseCacheManager _manager;

  FlutterCacheStorage(this._manager);

  @override
  Future<Uint8List> operator [](String key) async =>
      (await _manager.getFileFromCache(key))?.file?.readAsBytesSync();

  @override
  void operator []=(String key, Uint8List value) =>
      _manager.putFile(key, value);
}

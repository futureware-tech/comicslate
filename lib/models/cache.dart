import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class Cache {
  Future<Uint8List> operator [](String key);
  void operator []=(String key, Uint8List value);
}

class FlutterCache implements Cache {
  final BaseCacheManager _manager;

  FlutterCache(this._manager);

  @override
  Future<Uint8List> operator [](String key) async =>
      (await _manager.getFileFromCache(key))?.file?.readAsBytesSync();

  @override
  void operator []=(String key, Uint8List value) =>
      _manager.putFile(key, value);
}

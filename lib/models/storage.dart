import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class Storage {
  Future<Uint8List> operator [](String key);
  Future<void> store(String key, Uint8List value);
  void operator []=(String key, Uint8List value);
}

/*
Clear cache:
$ adb shell sqlite3 \
    /data/data/org.dasfoo.comicslate/databases/libCachedImageData.db \
    'delete\ from\ cacheObject;'
$ adb shell rm -rf /data/data/org.dasfoo.comicslate/cache/libCachedImageData
*/

class FlutterCacheStorage implements Storage {
  final BaseCacheManager _manager;

  FlutterCacheStorage(this._manager);

  @override
  Future<Uint8List> operator [](String key) async {
    final list =
        await (await _manager.getFileFromCache(key))?.file?.readAsBytes();
    if (list == null) {
      return null;
    }
    return Uint8List.fromList(list);
  }

  @override
  Future<void> store(String key, Uint8List value) =>
      _manager.putFile(key, value);

  @override
  void operator []=(String key, Uint8List value) => store(key, value);
}

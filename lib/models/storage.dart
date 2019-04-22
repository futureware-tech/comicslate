import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/collection.dart';

// TODO(dotdoom): parse HTTP response also for correct encoding.
typedef ResponseParser<T> = T Function(Uint8List response);

abstract class CachingAPIClient<T> {
  Stream<T> get(
    Uri url, {
    bool allowFromCache = true,
    Map<String, String> headers,
  });

  void prefetch(List<Uri> urls, {Map<String, String> headers});
}

abstract class Storage {
  Future<Uint8List> fetch(String key);
  Future<void> store(String key, Uint8List value);
}

/*
Clear cache:
$ adb shell sqlite3 \
    /data/data/org.dasfoo.comicslate/databases/libCachedImageData.db \
    'delete\ from\ cacheObject;'
$ adb shell rm -rf /data/data/org.dasfoo.comicslate/cache/libCachedImageData
*/

class FlutterCachingAPIClient<T> extends BaseCacheManager
    implements CachingAPIClient<T> {
  final String cacheName;
  final ResponseParser<T> responseParser;
  final _currentlyPrefetching = <Uri, Stream<T>>{};
  final _memoryCache = LruMap<Uri, Stream<T>>(maximumSize: 20);

  FlutterCachingAPIClient({
    this.responseParser,
    this.cacheName,
  }) : super(cacheName);

  Stream<T> get(
    Uri url, {
    bool allowFromCache = true,
    Map<String, String> headers,
  }) async* {
    if (allowFromCache) {
      final memoryCacheEntry = _memoryCache.remove(url);
      if (memoryCacheEntry != null) {
        yield* memoryCacheEntry;
        return;
      }
      await for (final fileInfo in getFile(url.toString(), headers: headers)) {
        yield responseParser(await fileInfo.file.readAsBytes());
      }
    } else {
      yield responseParser(await (await downloadFile(url.toString(),
              authHeaders: headers, force: true))
          .file
          .readAsBytes());
    }
  }

  void prefetch(List<Uri> urls, {Map<String, String> headers}) {
    for (final url in urls) {
      if (!_memoryCache.containsKey(url)) {
        _memoryCache[url] = _currentlyPrefetching.putIfAbsent(
            url,
            () => get(url, headers: headers).map((value) {
                  // Remove immediately once prefetching is finished.
                  _currentlyPrefetching.remove(url);
                  return value;
                }));
      }
    }
  }

  @override
  Future<String> getFilePath() async =>
      '${await getTemporaryDirectory()}/$cacheName';
}

class FlutterCacheStorage implements Storage {
  final BaseCacheManager _manager;

  FlutterCacheStorage(this._manager);

  @override
  Future<Uint8List> fetch(String key) async {
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
}

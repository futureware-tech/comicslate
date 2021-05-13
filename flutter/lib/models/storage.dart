import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

// TODO(dotdoom): parse HTTP response also for correct encoding.
typedef ResponseParser<T> = T Function(Uint8List response);

abstract class CachingAPIClient<T> {
  Stream<T> get(
    Uri url, {
    bool allowFromCache = true,
    Map<String, String> headers,
  });

  void prefetch(Iterable<Uri> urls, {Map<String, String> headers});
  Future<void> emptyCache();
}

/*
Clear cache:
$ adb shell sqlite3 \
    /data/data/org.dasfoo.comicslate/databases/libCachedImageData.db \
    'delete\ from\ cacheObject;'
$ adb shell rm -rf /data/data/org.dasfoo.comicslate/cache/libCachedImageData
*/

class FlutterCachingAPIClient<T> implements CachingAPIClient<T> {
  final CacheManager cache;
  final ResponseParser<T> responseParser;
  final _currentlyPrefetching = <Uri, Future<void>>{};

  FlutterCachingAPIClient({
    @required this.responseParser,
    @required this.cache,
  });

  @override
  Stream<T> get(
    Uri url, {
    bool allowFromCache = true,
    Map<String, String> headers,
  }) async* {
    await _currentlyPrefetching[url];
    yield* _get(url, allowFromCache: allowFromCache, headers: headers);
  }

  Stream<T> _get(
    Uri url, {
    bool allowFromCache = true,
    Map<String, String> headers,
  }) async* {
    debugPrint('Downloading $url, allowFromCache: $allowFromCache');
    if (allowFromCache) {
      // TODO(dotdoom): handle HTTP error codes.
      await for (final fileInfo
          in cache.getFileStream(url.toString(), headers: headers)) {
        if (fileInfo is FileInfo) {
          debugPrint('>> [from:${fileInfo.source}] $url');
          yield responseParser(await fileInfo.file.readAsBytes());
        }
      }
    } else {
      yield responseParser(await (await cache.downloadFile(url.toString(),
              authHeaders: headers, force: true))
          .file
          .readAsBytes());
    }
  }

  @override
  void prefetch(Iterable<Uri> urls, {Map<String, String> headers}) {
    for (final url in urls) {
      _currentlyPrefetching.putIfAbsent(url, () async {
        try {
          await _get(url, headers: headers)
              .last
              .timeout(const Duration(seconds: 10));
        } finally {
          unawaited(_currentlyPrefetching.remove(url));
        }
      });
    }
  }

  @override
  Future<void> emptyCache() => cache.emptyCache();
}

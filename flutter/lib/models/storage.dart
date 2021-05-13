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
    debugPrint('$url: download, allowFromCache: $allowFromCache');
    if (allowFromCache) {
      // TODO(dotdoom): handle HTTP error codes.
      await for (final fileInfo
          in cache.getFileStream(url.toString(), headers: headers)) {
        if (fileInfo is FileInfo) {
          final response = await fileInfo.file.readAsBytes();
          debugPrint('$url: from ${fileInfo.source}');
          yield responseParser(response);
        }
      }
    } else {
      final response = await (await cache.downloadFile(url.toString(),
              authHeaders: headers, force: true))
          .file
          .readAsBytes();
      debugPrint('$url: finished, from online as required');
      yield responseParser(response);
    }
  }

  @override
  void prefetch(Iterable<Uri> urls, {Map<String, String> headers}) {
    for (final url in urls) {
      _currentlyPrefetching.putIfAbsent(url, () async {
        final prefetchQueueId = hashCode.toRadixString(16).padLeft(10, '0');
        try {
          debugPrint('Prefetch queue $prefetchQueueId: '
              '${_currentlyPrefetching.length}');
          await _get(url, headers: headers)
              .last
              .timeout(const Duration(seconds: 10));
        } finally {
          unawaited(_currentlyPrefetching.remove(url));
          debugPrint('Prefetch queue $prefetchQueueId: '
              '${_currentlyPrefetching.length}');
        }
      });
    }
  }

  @override
  Future<void> emptyCache() => cache.emptyCache();
}

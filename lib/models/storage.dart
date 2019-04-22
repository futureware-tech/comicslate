import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

// TODO(dotdoom): parse HTTP response also for correct encoding.
typedef ResponseParser<T> = T Function(Uint8List response);

abstract class CachingAPIClient<T> {
  Stream<T> get(
    Uri url, {
    bool allowFromCache = true,
    Map<String, String> headers,
  });

  void prefetch(Iterable<Uri> urls, {Map<String, String> headers});
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
  final _currentlyPrefetching = <Uri, Future<void>>{};

  FlutterCachingAPIClient({
    @required this.responseParser,
    @required this.cacheName,
  }) : super(cacheName);

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
    if (allowFromCache) {
      // TODO(dotdoom): handle HTTP error codes.
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

  void prefetch(Iterable<Uri> urls, {Map<String, String> headers}) {
    for (final url in urls) {
      _currentlyPrefetching.putIfAbsent(url, () async {
        try {
          await _get(url, headers: headers)
              .last
              .timeout(const Duration(seconds: 5));
        } finally {
          _currentlyPrefetching.remove(url);
        }
      });
    }
  }

  @override
  Future<String> getFilePath() async =>
      '${(await getTemporaryDirectory()).path}/$cacheName';
}

import 'dart:async';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comicslate_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:pedantic/pedantic.dart';

class ComicListBloc {
  List<Comic> _comicList;

  ComicListBloc(ComicslateClient client) {
    _getComicList(client);

    _onComicSearchController.stream.listen((word) async {
      Map<String, List<Comic>> comics;
      comics = _comicList.fold<Map<String, List<Comic>>>({}, (map, comic) {
        if (comic.name.toLowerCase().contains(word.toLowerCase())) {
          (map[comic.categoryName] ??= []).add(comic);
        }
        return map;
      });
      _doComicListByCategoryController.add(comics);
    });

    _onEmptyCache.stream.listen((_) async {
      await client.emptyCache();
      await _getComicList(client);
    });
  }

  final _doComicListByCategoryController =
      StreamController<Map<String, List<Comic>>>();
  Stream<Map<String, List<Comic>>> get doComicListByCategory =>
      _doComicListByCategoryController.stream;

  final _onComicSearchController = StreamController<String>();
  Sink<String> get onComicSearch => _onComicSearchController.sink;

  final _onEmptyCache = StreamController<void>();
  Sink<void> get onEmptyCache => _onEmptyCache.sink;

  void dispose() {
    _doComicListByCategoryController.close();
    _onComicSearchController.close();
    _onEmptyCache.close();
  }

  Future<void> _getComicList(ComicslateClient client) async {
    _comicList = await client.getComicsList().first;
    unawaited(FirebaseAnalytics().logViewItemList(itemCategory: ''));

    Map<String, List<Comic>> comics;
    comics = _comicList.fold<Map<String, List<Comic>>>({}, (map, comic) {
      (map[comic.categoryName] ??= []).add(comic);
      return map;
    });
    _doComicListByCategoryController.add(comics);
  }
}

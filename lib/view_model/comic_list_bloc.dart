import 'dart:async';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comicslate_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ComicListBloc {
  ComicListBloc(ComicslateClient client) {
    _getComicList(client);
  }

  final _doComicListByCategoryController =
      StreamController<Map<String, List<Comic>>>();
  Stream<Map<String, List<Comic>>> get doComicListByCategory =>
      _doComicListByCategoryController.stream;

  void dispose() {
    _doComicListByCategoryController.close();
  }

  Future<void> _getComicList(ComicslateClient client) async {
    final comicList = await client.getComicsList().first;
    FirebaseAnalytics().logViewItemList(itemCategory: '');

    Map<String, List<Comic>> comics;
    comics = comicList.fold<Map<String, List<Comic>>>({}, (map, comic) {
      (map[comic.categoryName] ??= []).add(comic);
      return map;
    });
    _doComicListByCategoryController.add(comics);
  }
}

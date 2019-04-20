import 'dart:async';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comicslate_client.dart';

class ComicListBloc {
  ComicListBloc() {
    _getComicList();
  }

  final _doComicListByCategoryController =
      StreamController<Map<String, List<Comic>>>();
  Stream<Map<String, List<Comic>>> get doComicListByCategory =>
      _doComicListByCategoryController.stream;

  void dispose() {
    _doComicListByCategoryController.close();
  }

  Future<void> _getComicList() async {
    final comicList =
        await const ComicslateClient(language: 'ru').getComicsList();

    Map<String, List<Comic>> comics;
    comics = comicList.fold<Map<String, List<Comic>>>({}, (map, comic) {
      (map[comic.category] ??= []).add(comic);
      return map;
    });
    _doComicListByCategoryController.add(comics);
  }
}
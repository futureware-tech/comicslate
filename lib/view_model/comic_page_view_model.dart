import 'package:comicslate/models/comic.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComicPageViewModel {
  Comic comic;

  ComicPageViewModel({@required this.comic}) : assert(comic != null);

  Future<int> getLastSeenPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(comic.id) ?? 0;
  }

  Future<bool> setLastSeenPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(comic.id, page);
  }
}

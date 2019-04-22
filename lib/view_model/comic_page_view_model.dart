import 'dart:async';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComicPageViewModel {
  Comic comic;
  List<String> stripIds;
  ComicStrip currentStrip;
  String currentStripId;

  ComicPageViewModel({@required this.comic}) : assert(comic != null) {
    _onGoToPageController.stream.listen((stripId) {
      final page = stripIds.indexWhere((id) => id == stripId);
      if (page != -1) {
        _doGoToPageController.add(page);
      } else {
        // TODO(ksheremet): show to user that page doesn't exist
        print('Couldn\'t find $stripId');
      }
    });
    _onRefreshStripController.stream.listen((_) {
      _doRefreshStripController.add(null);
    });
  }

  final _onGoToPageController = StreamController<String>();
  Sink<String> get onGoToPage => _onGoToPageController.sink;

  final _doGoToPageController = StreamController<int>();
  Stream<int> get doGoToPage => _doGoToPageController.stream;

  final _onRefreshStripController = StreamController<void>();
  Sink<void> get onRefreshStrip => _onRefreshStripController.sink;

  final _doRefreshStripController = StreamController<void>();
  Stream<void> get doRefreshStrip => _doRefreshStripController.stream;

  Future<int> getLastSeenPage() async {
    final prefs = await SharedPreferences.getInstance();
    final page = prefs.getInt(comic.id) ?? 0;
    return page;
  }

  Future<bool> setLastSeenPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(comic.id, page);
  }

  // TODO(ksheremet): Call somewhere to dispose
  void dispose() {
    _onGoToPageController.close();
    _doGoToPageController.close();
    _onRefreshStripController.close();
    _doRefreshStripController.close();
  }
}

import 'dart:math';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/view/comic_page.dart';
import 'package:comicslate/view/helpers/comic_card.dart';
import 'package:comicslate/view/helpers/comic_page_view_model_iw.dart';
import 'package:comicslate/view/helpers/comicslate_client.dart';
import 'package:comicslate/view_model/comic_list_bloc.dart';
import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class _ComicslateTitleWidget extends StatelessWidget {
  static const _numberOfLogos = 9;
  final _logoId = Random();

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child:
            Image.asset('images/logo${_logoId.nextInt(_numberOfLogos)}.webp'),
      );
}

class ComicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: _ComicslateTitleWidget()),
        body: _ComicListBody(),
      );
}

class _ComicListBody extends StatefulWidget {
  @override
  _ComicListBodyState createState() => _ComicListBodyState();
}

class _ComicListBodyState extends State<_ComicListBody> {
  ComicListBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= ComicListBloc(ComicslateClientWidget.of(context).client);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Map<String, List<Comic>>>(
        stream: _bloc.doComicListByCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                if (!await DiskCache().clear()) {
                  print('report a problem with cleaning cache');
                }
                setState(() {
                  imageCache.clear();
                });
              },
              child: CustomScrollView(
                primary: true,
                slivers: _buildComicList(snapshot.data, context),
              ),
            );
          } else {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
        },
      );

  List<Widget> _buildComicList(
      Map<String, List<Comic>> comicMap, BuildContext context) {
    final sliverList = <Widget>[];
    comicMap.forEach((category, comicList) => sliverList
      ..add(SliverList(
        delegate: SliverChildListDelegate(<Widget>[
          Container(
            color: Theme.of(context).primaryColorLight,
            child: ListTile(
              title: Text(
                category,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ]),
      ))
      ..add(SliverGrid(
        delegate: SliverChildBuilderDelegate(
            (context, i) => ComicCard(
                  imageUrl: comicList[i].thumbnailURL,
                  title: comicList[i].name,
                  ratingColor: comicList[i].ratingColor,
                  isActive: comicList[i].isActive,
                  callback: () {
                    _openComics(context, comicList[i]);
                  },
                ),
            childCount: comicList.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 4),
      )));

    return sliverList;
  }

  void _openComics(BuildContext context, Comic comics) {
    // Initialize VM with another context. With initialization in Navigator
    // it will be rebuild all the time.
    FirebaseAnalytics().logViewItemList(itemCategory: comics.id);
    final root = ComicPageViewModelWidget(
      viewModel: ComicPageViewModel(comic: comics),
      child: ComicPage(),
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: '/read-comics'),
            builder: (context) => root));
  }
}

import 'dart:math';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/view/comic_page.dart';
import 'package:comicslate/view/helpers/comic_card.dart';
import 'package:comicslate/view/helpers/comic_page_view_model_iw.dart';
import 'package:comicslate/view/helpers/navigation_drawer.dart';
import 'package:comicslate/view/helpers/search_bar.dart';
import 'package:comicslate/view_model/comic_list_bloc.dart';
import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    // TODO(ksheremet): Create Inherited widget for bloc. Consider to try
    // ScopedModel, Provide
    final bloc = ComicListBloc(context.read<ComicslateClient>());
    return Scaffold(
      appBar: SearchBarWidget(
          title: _ComicslateTitleWidget(),
          search: (text) {
            bloc.onComicSearch.add(text);
          }),
      body: _ComicListBody(bloc: bloc),
      drawer: NavigationDrawer(),
      //drawer: NavigationDrawer(),
    );
  }
}

class _ComicListBody extends StatefulWidget {
  final ComicListBloc bloc;

  const _ComicListBody({@required this.bloc}) : assert(bloc != null);

  @override
  _ComicListBodyState createState() => _ComicListBodyState();
}

class _ComicListBodyState extends State<_ComicListBody> {
  @override
  Widget build(BuildContext context) => StreamBuilder<Map<String, List<Comic>>>(
        stream: widget.bloc.doComicListByCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                widget.bloc.onEmptyCache.add(null);
                imageCache.clear();
              },
              child: snapshot.data.isEmpty
                  ? const Center(
                      child: Text('Нет комиксов во Вашему запросу'),
                    )
                  : CustomScrollView(
                      primary: true,
                      slivers: _buildComicList(snapshot.data, context),
                    ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
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
                style: const TextStyle(fontSize: 20),
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
        MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/read-comics'),
            builder: (context) => root));
  }
}

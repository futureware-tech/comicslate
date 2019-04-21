import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/view/comic_page.dart';
import 'package:comicslate/view/helpers/comic_card.dart';
import 'package:comicslate/view_model/comic_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// TODO(ksheremet): Refresh Indicator, clear cache and get updated comics covers
class ComicList extends StatelessWidget {
  final String title;
  final ComicslateClient client;
  final ComicListBloc _bloc;

  ComicList({
    @required this.title,
    // TODO(ksheremet): get rid of "client" parameter - it's in InheritedWidget
    @required this.client,
  })  : assert(title != null),
        _bloc = ComicListBloc(client);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: StreamBuilder<Map<String, List<Comic>>>(
          stream: _bloc.doComicListByCategory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                primary: true,
                slivers: _buildComicList(snapshot.data, context),
              );
            } else {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
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
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: '/read-comics'),
            builder: (context) => ComicPage(comic: comics)));
  }
}

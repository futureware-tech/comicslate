import 'package:comicslate/models/comic.dart';
import 'package:comicslate/view/comic_page.dart';
import 'package:comicslate/view/helpers/comics_card.dart';
import 'package:comicslate/view_model/comic_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ComicList extends StatelessWidget {
  final String title;

  final ComicListBloc _bloc = ComicListBloc();

  ComicList({@required this.title}) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    print('Build list was called');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
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
  }

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
            (context, i) => ComicsCard(
                  imageUrl: comicList[i].thumbnailURL.toString(),
                  title: comicList[i].name,
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

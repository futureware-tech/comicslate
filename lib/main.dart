import 'package:comicslate/view/comic_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Comicslate',
        theme: ThemeData(
            fontFamily: 'DatFestComic',
            primaryColorDark: const Color(0xFF00796B),
            primaryColor: const Color(0xFF009688),
            accentColor: const Color(0xFFFFEB3B),
            primaryColorLight: const Color(0xFFB2DFDB),
            dividerColor: const Color(0xFFBDBDBD),
            textTheme: Theme.of(context).textTheme.apply(
                displayColor: const Color(0xFF212121),
                decorationColor: const Color(0xFF757575))),
        home: MyHomePage(title: 'Comicslate'),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => ComicList(
        title: widget.title,
      );
}

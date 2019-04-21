import 'package:comicslate/models/comicslate_client.dart';
import 'package:flutter/material.dart';

@immutable
class ComicslateClientWidget extends InheritedWidget {
  final ComicslateClient client;

  ComicslateClientWidget({
    @required this.client,
    @required Widget child,
  })  : assert(client != null),
        super(child: child);

  static ComicslateClientWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ComicslateClientWidget);

  @override
  bool updateShouldNotify(ComicslateClientWidget oldWidget) =>
      oldWidget.client != client;
}

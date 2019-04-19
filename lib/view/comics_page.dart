import 'dart:typed_data';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:flutter/material.dart';

class ComicsPage extends StatelessWidget {
  final Comic comics;

  ComicsPage({@required this.comics}) : assert(comics != null);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(comics.name)),
        // Get a list of stripsId
        body: FutureBuilder<Iterable<String>>(
          future: comics.getStoryStripsList(),
          builder: (context, stripListSnapshot) {
            if (stripListSnapshot.hasData) {
              // Load image
              return FutureBuilder<ComicStrip>(
                  future: comics
                      .getComicsStrip(stripListSnapshot.data.elementAt(0)),
                  builder: (context, stripSnapshot) {
                    if (stripSnapshot.hasData) {
                      return Image.memory(
                          Uint8List.fromList(stripSnapshot.data.imageBytes));
                    } else {
                      return Center(child: const CircularProgressIndicator());
                    }
                  });
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      );
}

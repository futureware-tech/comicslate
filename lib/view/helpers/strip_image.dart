import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:flutter/material.dart';

class StripImage extends StatelessWidget {
  final ComicPageViewModel viewModel;
  const StripImage({@required this.viewModel}) : assert(viewModel != null);

  @override
  Widget build(BuildContext context) {
    var aboutStrip =
        '${viewModel.currentStripId} / ${viewModel.stripIds.length}  ';
    if (viewModel.currentStrip.title != null) {
      aboutStrip = aboutStrip + viewModel.currentStrip.title;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(aboutStrip),
        ),
        Image.memory(
          viewModel.currentStrip.imageBytes,
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}

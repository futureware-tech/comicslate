import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:flutter/material.dart';

class StripImage extends StatelessWidget {
  final ComicPageViewModel viewModel;

  const StripImage({
    @required this.viewModel,
  }) : assert(viewModel != null);

  @override
  Widget build(BuildContext context) => InteractiveViewer(
        minScale: 0.1,
        maxScale: 5,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${viewModel.currentStripId} / ${viewModel.stripIds.length}',
                ),
                if (viewModel.currentStrip.title != null)
                  Text(viewModel.currentStrip.title),
              ],
            ),
          ),
          Expanded(child: Image.memory(viewModel.currentStrip.imageBytes)),
        ]),
      );
}

import 'dart:math';
import 'dart:typed_data';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:comicslate/view/helpers/comicslate_client.dart';
import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ComicPage extends StatelessWidget {
  final Comic comic;
  final ComicPageViewModel _viewModel;

  ComicPage({@required this.comic})
      : assert(comic != null),
        _viewModel = ComicPageViewModel(comic: comic);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(comic.name),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                Share.share(_viewModel.currentStrip.shareUrl.toString());
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: (context) => _buildComicInfo());
              },
            )
          ],
        ),
        // Get a list of stripsId
        body: FutureBuilder<Iterable<String>>(
          future: ComicslateClientWidget.of(context)
              .client
              .getStoryStripsList(comic),
          builder: (context, stripListSnapshot) {
            if (stripListSnapshot.hasData) {
              // Load image
              _viewModel.stripIds = stripListSnapshot.data.toList();
              return StripPage(
                viewModel: _viewModel,
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      );

  Widget _buildComicInfo() => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Автор:  ${_viewModel.currentStrip.author}',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 10,
            ),
            Text(
              'Дата последнего изменения:  '
              '${DateFormat.yMMMd().add_jm().format(_viewModel.currentStrip.lastModified)}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
}

class StripPage extends StatefulWidget {
  final ComicPageViewModel viewModel;

  StripPage({@required this.viewModel}) : assert(viewModel != null);

  @override
  _StripPageState createState() => _StripPageState();
}

class _StripPageState extends State<StripPage> {
  PageController _controller;
  bool _isOrientationSetup = false;

  @override
  Widget build(BuildContext context) => FutureBuilder<int>(
        future: widget.viewModel.getLastSeenPage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controller = PageController(initialPage: snapshot.data);
            return PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: widget.viewModel.stripIds.length,
              itemBuilder: (context, i) => FutureBuilder<ComicStrip>(
                  future: ComicslateClientWidget.of(context).client.getStrip(
                        widget.viewModel.comic,
                        widget.viewModel.stripIds.elementAt(i),
                        prefetch: widget.viewModel.stripIds.sublist(
                          max(0, i - 2),
                          min(widget.viewModel.stripIds.length - 1, i + 5),
                        ),
                      ),
                  builder: (context, stripSnapshot) {
                    if (stripSnapshot.hasData) {
                      if (stripSnapshot.data.imageBytes == null) {
                        return WebView(
                          initialUrl: stripSnapshot.data.displayUrl.toString(),
                          javascriptMode: JavascriptMode.unrestricted,
                        );
                      } else {
                        if (!_isOrientationSetup) {
                          setUpOrientation(stripSnapshot.data.imageBytes);
                        }
                        widget.viewModel.currentStrip = stripSnapshot.data;
                        widget.viewModel.currentStripId =
                            widget.viewModel.stripIds.elementAt(i);
                        // TODO(ksheremet): Zoomable widget doesn't work
                        //  in Column
                        return StripImage(viewModel: widget.viewModel);
                      }
                    } else {
                      return Center(child: const CircularProgressIndicator());
                    }
                  }),
              onPageChanged: (index) {
                widget.viewModel.setLastSeenPage(index);
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );

  // TODO(ksheremet): Consider more elegant solution, doesnt' work on iOS
  void setUpOrientation(Uint8List imageBytes) {
    final image = MemoryImage(imageBytes);
    image
        .resolve(createLocalImageConfiguration(context))
        .addListener((imageInfo, error) {
      _isOrientationSetup = true;
      if (imageInfo.image.width > imageInfo.image.height) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      } else {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
    });
  }

  @override
  void dispose() {
    // When we leave the screen enable screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}

class StripImage extends StatefulWidget {
  final ComicPageViewModel viewModel;

  StripImage({@required this.viewModel}) : assert(viewModel != null);

  @override
  _StripImageState createState() => _StripImageState();
}

class _StripImageState extends State<StripImage> {
  @override
  Widget build(BuildContext context) => ZoomableWidget(
      enableRotate: false,
      maxScale: 3,
      zoomSteps: 2,
      multiFingersPan: true,
      singleFingerPan: false,
      minScale: 1,
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
              '${widget.viewModel.currentStripId} / ${widget.viewModel.stripIds.length}  '
              '${widget.viewModel.currentStrip.title}'),
        ),
        Image.memory(widget.viewModel.currentStrip.imageBytes),
      ]));
}

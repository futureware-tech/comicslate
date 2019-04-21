import 'dart:typed_data';

import 'package:comicslate/models/comic.dart';
import 'package:comicslate/models/comic_strip.dart';
import 'package:comicslate/view/helpers/comicslate_client.dart';
import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ComicPage extends StatelessWidget {
  final Comic comic;

  ComicPage({@required this.comic}) : assert(comic != null);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(comic.name)),
        // Get a list of stripsId
        body: FutureBuilder<Iterable<String>>(
          future: ComicslateClientWidget.of(context)
              .client
              .getStoryStripsList(comic),
          builder: (context, stripListSnapshot) {
            if (stripListSnapshot.hasData) {
              // Load image
              return StripPage(
                comic: comic,
                stripIds: stripListSnapshot.data,
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      );
}

class StripPage extends StatefulWidget {
  final Iterable<String> stripIds;
  final Comic comic;

  StripPage({@required this.comic, @required this.stripIds})
      : assert(stripIds != null && stripIds.isNotEmpty),
        assert(comic != null);

  @override
  _StripPageState createState() => _StripPageState();
}

class _StripPageState extends State<StripPage> {
  PageController _controller;
  ComicPageViewModel _viewModel;
  bool _isOrientationSetup = false;

  @override
  void initState() {
    _viewModel = ComicPageViewModel(comic: widget.comic);
    super.initState();
  }

  // TODO(ksheremet): Cache images
  @override
  Widget build(BuildContext context) => FutureBuilder<int>(
        future: _viewModel.getLastSeenPage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controller = PageController(initialPage: snapshot.data);
            return PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: widget.stripIds.length,
              itemBuilder: (context, i) => FutureBuilder<ComicStrip>(
                  future: ComicslateClientWidget.of(context)
                      .client
                      .getStrip(widget.comic, widget.stripIds.elementAt(i)),
                  builder: (context, stripSnapshot) {
                    if (stripSnapshot.hasData) {
                      if (stripSnapshot.data.imageBytes == null) {
                        return WebView(
                          initialUrl: stripSnapshot.data.url.toString(),
                          javascriptMode: JavascriptMode.unrestricted,
                        );
                      } else {
                        if (!_isOrientationSetup) {
                          setUpOrientation(stripSnapshot.data.imageBytes);
                        }
                        return StripImage(
                            imageBytes: stripSnapshot.data.imageBytes);
                      }
                      // TODO(ksheremet): Zoomable widget doesn't work in Column
                      /*return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${widget.stripIds.elementAt(i)}/'
                              '${widget.stripIds.length}'
                              '${stripSnapshot.data.title}'),
                          StripImage(imageBytes: stripSnapshot.data.imageBytes),
                          Text('${stripSnapshot.data.author}: '
                              '${stripSnapshot.data.lastModified}'),
                        ],
                      );*/
                    } else {
                      return Center(child: const CircularProgressIndicator());
                    }
                  }),
              onPageChanged: (index) {
                _viewModel.setLastSeenPage(index);
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
  final Uint8List imageBytes;

  StripImage({@required this.imageBytes}) : assert(imageBytes != null);

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
      child: Image.memory(widget.imageBytes));
}

import 'dart:math';
import 'dart:typed_data';

import 'package:comicslate/models/comic_strip.dart';
import 'package:comicslate/models/comicslate_client.dart';
import 'package:comicslate/view/helpers/comic_page_view_model_iw.dart';
import 'package:comicslate/view/helpers/strip_image.dart';
import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:wakelock/wakelock.dart';

enum StripAction { refresh, about }

class ComicPage extends StatelessWidget {
  final _pageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ComicPageViewModelWidget.of(context).viewModel;
    return Scaffold(
      // When keyboard appears it is breaks layout if it is not scrollable.
      // This property helps to appear the keyboard above the screen.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(viewModel.comic.name),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(8),
            icon: const Icon(Icons.input),
            onPressed: () {
              _pageTextController.text = viewModel.currentStripId;
              final allStrips = viewModel.stripIds.length;
              final onGoToPage = viewModel.onGoToPage;
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) =>
                    _showGoToPageDialog(context, allStrips, onGoToPage),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(viewModel.currentStrip.shareUrl.toString());
            },
          ),
          PopupMenuButton<StripAction>(
            onSelected: (action) {
              switch (action) {
                case StripAction.refresh:
                  viewModel.onRefreshStrip.add(null);
                  break;
                case StripAction.about:
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => _buildComicInfo(viewModel),
                  );
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<StripAction>>[
              const PopupMenuItem<StripAction>(
                value: StripAction.refresh,
                child: Text('Обновить'),
              ),
              const PopupMenuItem<StripAction>(
                value: StripAction.about,
                child: Text('О стрипе'),
              ),
            ],
          ),
        ],
      ),
      // Get a list of stripsId
      body: FutureBuilder<Iterable<String>>(
        future: context
            .read<ComicslateClient>()
            .getStoryStripsList(
                ComicPageViewModelWidget.of(context).viewModel.comic)
            .first,
        builder: (context, stripListSnapshot) {
          if (stripListSnapshot.hasData) {
            // Load image
            ComicPageViewModelWidget.of(context).viewModel.stripIds =
                stripListSnapshot.data.toList();
            return StripPage(
              viewModel: ComicPageViewModelWidget.of(context).viewModel,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _showGoToPageDialog(
      BuildContext context, int allStrips, Sink onGoToPage) {
    final focusNode = FocusNode();
    FocusScope.of(context).requestFocus(focusNode);
    return AlertDialog(
      title: const Text('Перейти на страницу'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              focusNode: focusNode,
              controller: _pageTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onSubmitted: (page) {
                onGoToPage.add(page);
                Navigator.of(context).pop();
              },
            ),
          ),
          Text(' / $allStrips'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Перейти',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            onGoToPage.add(_pageTextController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildComicInfo(ComicPageViewModel viewModel) {
    final lastModifiedString = DateFormat.yMMMd()
        .add_jm()
        .format(viewModel.currentStrip.lastModified.toLocal());
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Автор: ${viewModel.currentStrip.author}',
            style: const TextStyle(fontSize: 20),
          ),
          Container(
            height: 10,
          ),
          Text(
            'Дата последнего изменения: $lastModifiedString',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class StripPage extends StatefulWidget {
  final ComicPageViewModel viewModel;

  const StripPage({@required this.viewModel}) : assert(viewModel != null);

  @override
  _StripPageState createState() => _StripPageState();
}

class _StripPageState extends State<StripPage> {
  PageController _controller;
  bool _isOrientationSetup = false;
  Future<int> _lastSeenStrip;
  bool _allowCache = true;

  @override
  void initState() {
    // Do not allow the screen to go to sleep when dislaying a comic strip.
    Wakelock.enable();

    widget.viewModel.doGoToPage.listen((page) {
      _controller.jumpToPage(page);
    });

    widget.viewModel.doRefreshStrip.listen((_) {
      setState(() {
        _allowCache = false;
      });
    });

    _lastSeenStrip = widget.viewModel.getLastSeenPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<int>(
        future: _lastSeenStrip,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controller = PageController(initialPage: snapshot.data);
            return PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: widget.viewModel.stripIds.length,
              itemBuilder: (context, i) => FutureBuilder<ComicStrip>(
                  future: context
                      .read<ComicslateClient>()
                      .getStrip(
                        widget.viewModel.comic,
                        widget.viewModel.stripIds.elementAt(i),
                        allowFromCache: _allowCache,
                        prefetch: widget.viewModel.stripIds.sublist(
                          max(0, i - 2),
                          min(widget.viewModel.stripIds.length - 1, i + 5),
                        ),
                      )
                      .first,
                  builder: (context, stripSnapshot) {
                    if (stripSnapshot.hasData) {
                      _allowCache = true;
                      if (stripSnapshot.data.imageBytes == null) {
                        var title = stripSnapshot.data.title ?? 'n/a';
                        if (stripSnapshot.hasError) {
                          title += ' (${stripSnapshot.error})';
                        }
                        return Center(
                          child: Text(
                            'Данная страница '
                            '${widget.viewModel.stripIds.elementAt(i)} еще не '
                            'поддерживается мобильным приложением: $title.',
                          ),
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
                        return StripImage(
                          viewModel: widget.viewModel,
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              onPageChanged: (index) {
                FirebaseAnalytics().logViewItem(
                  itemCategory: widget.viewModel.comic.id,
                  itemId: index.toString(),
                  itemName: index.toString(),
                );

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
        .addListener(ImageStreamListener((imageInfo, synchronousCall) {
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
    }));
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
    Wakelock.disable();
    super.dispose();
  }
}

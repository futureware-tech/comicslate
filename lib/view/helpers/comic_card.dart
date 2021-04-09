import 'package:cached_network_image/cached_network_image.dart';
import 'package:comicslate/models/comic.dart';
import 'package:flutter/material.dart';

@immutable
class ComicsRatingWidget extends StatefulWidget {
  final ComicRatingColor ratingColor;
  final bool isActive;

  const ComicsRatingWidget({
    @required this.ratingColor,
    @required this.isActive,
  });

  @override
  _ComicsRatingWidgetState createState() => _ComicsRatingWidgetState();
}

class _ComicsRatingWidgetState extends State<ComicsRatingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  static const ratingColorMap = {
    ComicRatingColor.empty: Color.fromARGB(0xFF, 0xEA, 0xEA, 0xEA),
    ComicRatingColor.bronze: Color.fromARGB(0xFF, 0xCD, 0x7F, 0x32),
    ComicRatingColor.silver: Color.fromARGB(0xFF, 0xC0, 0xC0, 0xC0),
    ComicRatingColor.gold: Color.fromARGB(0xFF, 0xFF, 0xDF, 0x00),
  };

  Icon _buildStar() => Icon(
        Icons.star,
        color: ratingColorMap[widget.ratingColor],
      );

  @override
  Widget build(BuildContext context) {
    if (widget.ratingColor == null) {
      return Container();
    }
    if (widget.isActive == true) {
      return RotationTransition(child: _buildStar(), turns: _starController);
    } else {
      return _buildStar();
    }
  }

  @override
  void dispose() {
    _starController
      ..stop()
      ..dispose();
    super.dispose();
  }
}

@immutable
class ComicCard extends StatelessWidget {
  final Uri imageUrl;
  final String title;
  final ComicRatingColor ratingColor;
  final bool isActive;
  final Function callback;

  const ComicCard(
      {@required this.imageUrl,
      @required this.title,
      @required this.callback,
      @required this.isActive,
      @required this.ratingColor})
      : assert(title != null),
        assert(callback != null);

  static String splitInTheMiddle(String input) {
    final parts = input.split(' ');
    final partsToJoin = parts.length ~/ 2;
    return [
      parts.sublist(0, partsToJoin).join(' '),
      parts.sublist(partsToJoin).join(' '),
    ].join('\n').trim();
  }

  @override
  Widget build(BuildContext context) {
    Widget cover;
    if (imageUrl == null) {
      cover = Column(children: [
        Expanded(
            child: FittedBox(
                child: Container(
          padding: const EdgeInsets.all(5),
          child: Text(splitInTheMiddle(title), textAlign: TextAlign.center),
        ))),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: ComicsRatingWidget(
            isActive: isActive,
            ratingColor: ratingColor,
          ),
        ),
      ]);
    } else {
      cover = Column(children: [
        Expanded(
          child: CachedNetworkImage(
            imageUrl: imageUrl.toString(),
            placeholder: (context, url) => Image.asset('images/favicon.webp'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ComicsRatingWidget(
                isActive: isActive,
                ratingColor: ratingColor,
              ),
            ],
          ),
        )
      ]);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: callback,
        splashColor: Theme.of(context).splashColor,
        child: cover,
      ),
    );
  }
}

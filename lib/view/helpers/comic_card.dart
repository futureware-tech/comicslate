import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final Uri imageUrl;
  final String title;
  final Function callback;

  ComicCard(
      {@required this.imageUrl, @required this.title, @required this.callback})
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
    final cover = imageUrl == null
        ? FittedBox(
            child: Text(splitInTheMiddle(title), textAlign: TextAlign.center))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  image: imageUrl.toString(),
                  placeholder: 'images/favicon.png',
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ))
            ],
          );

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

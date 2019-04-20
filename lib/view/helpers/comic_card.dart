import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final Uri imageUrl;
  final String title;
  final Function callback;

  ComicCard(
      {@required this.imageUrl, @required this.title, @required this.callback})
      : assert(imageUrl != null),
        assert(title != null),
        assert(callback != null);

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: callback,
          splashColor: Theme.of(context).splashColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: imageUrl == null
                    ? Image.asset(
                        'images/logo2.png',
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        image: imageUrl.toString(),
                        placeholder: 'images/logo2.png',
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
          ),
        ),
      );
}

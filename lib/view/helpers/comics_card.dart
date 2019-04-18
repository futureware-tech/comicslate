import 'package:flutter/material.dart';

class ComicsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Function callback;

  ComicsCard(
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
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  image: imageUrl,
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

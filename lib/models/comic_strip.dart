import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class ComicStrip {
  final Uri url;
  final Uint8List imageBytes;

  const ComicStrip({
    @required this.url,
    @required this.imageBytes,
  });
}

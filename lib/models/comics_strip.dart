import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class ComicsStrip {
  final Uri url;
  final Uint8List imageBytes;

  const ComicsStrip({
    @required this.url,
    @required this.imageBytes,
  });
}

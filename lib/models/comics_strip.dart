import 'package:meta/meta.dart';

enum ImageFormat {
  PNG,
  JPEG,
}

@immutable
class ComicsStrip {
  final Uri url;
  final List<int> imageBytes;
  final ImageFormat imageFormat;

  ComicsStrip({
    @required this.url,
    @required this.imageBytes,
    @required this.imageFormat,
  });
}

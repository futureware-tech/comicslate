import 'package:meta/meta.dart';

@immutable
class ComicsStrip {
  final Uri url;
  final List<int> imageBytes;

  const ComicsStrip({
    @required this.url,
    @required this.imageBytes,
  });
}

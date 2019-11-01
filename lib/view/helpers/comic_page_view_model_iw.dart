import 'package:comicslate/view_model/comic_page_view_model.dart';
import 'package:flutter/material.dart';

@immutable
class ComicPageViewModelWidget extends InheritedWidget {
  final ComicPageViewModel viewModel;

  const ComicPageViewModelWidget({
    @required this.viewModel,
    @required Widget child,
  })  : assert(viewModel != null),
        super(child: child);

  static ComicPageViewModelWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ComicPageViewModelWidget);

  @override
  bool updateShouldNotify(ComicPageViewModelWidget oldWidget) =>
      oldWidget.viewModel != viewModel;
}

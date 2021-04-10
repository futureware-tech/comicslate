import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String input);

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final SearchCallback search;

  const SearchBarWidget({this.title, this.search});

  @override
  State<StatefulWidget> createState() => SearchBarWidgetState();

  // Flutter documentation for AppBar.preferredSize says:
  // "the sum of kToolbarHeight and the bottom widget's preferred height".
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchMode = false;

  void _searchTextChanged() {
    if (_isSearchMode) {
      widget.search(_searchController.text);
    } else {
      widget.search(null);
    }
  }

  @override
  void initState() {
    _searchController.addListener(_searchTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_searchTextChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle;
    Icon actionIcon;

    if (_isSearchMode) {
      actionIcon = const Icon(Icons.close);
      appBarTitle = TextField(
        autofocus: true,
        controller: _searchController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Поиск ...',
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 19,
            )),
      );
    } else {
      appBarTitle = widget.title;
      actionIcon = const Icon(Icons.search);
    }

    return AppBar(
      title: appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (_isSearchMode) {
                // TODO(ksheremet): would the user always want to clear it?
                _searchController.clear();
                _isSearchMode = false;
              } else {
                _isSearchMode = true;
              }
            });
          },
        )
      ],
    );
  }
}

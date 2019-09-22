import 'package:flutter/material.dart';
import 'package:fab_hub/src/blocs/search_posts_block.dart';


class SearchPostsBlockProvider extends InheritedWidget {
  final SearchPostsBlock bloc;

  SearchPostsBlockProvider({Key key, Widget child})
      : bloc = SearchPostsBlock(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static SearchPostsBlock of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SearchPostsBlockProvider)
    as SearchPostsBlockProvider)
        .bloc;
  }
}
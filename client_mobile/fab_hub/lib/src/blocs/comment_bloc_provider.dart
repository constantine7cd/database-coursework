import 'package:flutter/material.dart';
import 'package:fab_hub/src/blocs/comment_block.dart';


class CommentsBlockProvider extends InheritedWidget {
  final CommentsBlock bloc;

  CommentsBlockProvider({Key key, Widget child})
      : bloc = CommentsBlock(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static CommentsBlock of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CommentsBlockProvider)
    as CommentsBlockProvider)
        .bloc;
  }
}

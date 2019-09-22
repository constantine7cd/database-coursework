import 'package:flutter/material.dart';
import 'package:fab_hub/src/blocs/post_bloc.dart';
import 'package:fab_hub/src/ui/post.dart';


class PostBlockProvider extends InheritedWidget {
  final PostBlock bloc;

  PostBlockProvider(int postId, String username, List<String> likes, int likesCount,
      {Key key, Widget child})
      : bloc = PostBlock(postId, username, likes, likesCount),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static PostBlock of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PostBlockProvider)
    as PostBlockProvider)
        .bloc;
  }
}

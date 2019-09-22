import 'package:flutter/material.dart';
import "dart:async";

import 'package:fab_hub/src/models/comment_model.dart';
import 'package:fab_hub/src/ui/comment.dart';

import 'package:fab_hub/src/blocs/comment_bloc_provider.dart';
import 'package:fab_hub/src/blocs/comment_block.dart';


class CommentPage extends StatefulWidget {

  final postId;

  const CommentPage({this.postId});

  @override
  CommentPageState createState() => CommentPageState(
    postId: this.postId,
  );
}

class CommentPageState extends State<CommentPage> {

  final postId;
  CommentsBlock bloc;

  final TextEditingController _commentController = TextEditingController();

  CommentPageState({this.postId});

  @override
  void didChangeDependencies() {
    bloc = CommentsBlockProvider.of(context);
    bloc.fetchCommentsByPostId(postId);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  _onPostButtonPressed() {
    print("on pressed button: " + _commentController.text);

    Future<bool> res = bloc.addComment(postId, _commentController.text);

    res.then((value) {
      bloc.fetchCommentsByPostId(postId);
      _commentController.clear();
    });

    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {

    // TODO: onRefresh should work!
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Comments",
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: buildPage()
      )
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        Expanded(
          child:
          buildComments(),
        ),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Write a comment...'),
            //onFieldSubmitted: _addCommentHandler(),
          ),
          trailing: OutlineButton(onPressed: _onPostButtonPressed, borderSide: BorderSide.none, child: Text("Post"),),
        ),
      ],
    );

  }

  Widget buildComments() {
    return StreamBuilder(
      stream: bloc.comments,
      builder: (context,
          AsyncSnapshot<Future<CommentModel>> snapshot) {
        if (snapshot.hasData) {

          return FutureBuilder(
            future: snapshot.data,
            builder: (context, AsyncSnapshot<CommentModel> commentSnapshot) {

              if (commentSnapshot.hasData) {

                List<CommentItem> comments = commentSnapshot.data.comments.cast<CommentItem>();

                List<Comment> widgetComments = comments.map( (i) => Comment(
                  username: i.username,
                  avatarUrl: i.avatarUrl,
                  body: i.body,
                  createdAt: i.createdAt,
                )).toList();

                return ListView(
                  children: widgetComments,
                );

              } else {
                return noComments();
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }

  Widget noComments() {
    return Center(
      child: Container(
        child: Text("No comments for this post."),
      ),
    );
  }


}

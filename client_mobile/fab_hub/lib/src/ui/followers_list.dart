import 'package:flutter/material.dart';
import "dart:async";

import 'package:fab_hub/src/models/comment_model.dart';
import 'package:fab_hub/src/ui/comment.dart';

import 'package:fab_hub/src/blocs/comment_bloc_provider.dart';
import 'package:fab_hub/src/blocs/comment_block.dart';

/*
class CommentPage extends StatefulWidget {

  final profileId;

  const CommentPage({this.profileId});

  @override
  CommentPageState createState() => CommentPageState(
    profileId: this.profileId,
  );
}

class CommentPageState extends State<CommentPage> {

  final profileId;

  CommentPageState({this.profileId});

  @override
  void didChangeDependencies() {
    //bloc = CommentsBlockProvider.of(context);
    //bloc.fetchCommentsByPostId(postId);
    //print("recreated");

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //bloc.dispose();
    super.dispose();
  }

  _onPostButtonPressed() {
    /*Future<bool> res = bloc.addComment(postId, _commentController.text);

    res.then((value) {
      bloc.fetchCommentsByPostId(postId);
      _commentController.clear();
    });

    FocusScope.of(context).requestFocus(new FocusNode());*/
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
            "Followers",
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
                return noFollowers();
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }

  Widget noFollowers() {
    return Center(
      child: Container(
        child: Text("No followers"),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String body;
  final String createdAt;

  Comment({
    this.username,
    this.avatarUrl,
    this.body,
    this.createdAt
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(body),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        Divider(),
      ],
    );
  }
}
*/
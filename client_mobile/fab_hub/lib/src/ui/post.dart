import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fab_hub/src/ui/comment_screen.dart';
import 'package:fab_hub/src/ui/profile_screen.dart';

import 'package:fab_hub/src/blocs/comment_bloc_provider.dart';
import 'package:fab_hub/src/blocs/profile_bloc_provider.dart';
import 'package:fab_hub/src/blocs/post_bloc_provider.dart';
import 'package:fab_hub/src/blocs/post_bloc.dart';


class Post extends StatefulWidget {

  final ownerId;
  final profileId;
  final postId;
  final mediaUrl;
  final avatarUrl;
  final username;
  final location;
  final description;

  const Post({this.ownerId, this.profileId, this.postId, this.mediaUrl,
              this.avatarUrl, this.username, this.location,
              this.description});

  PostState createState() {
    return PostState(
        ownerId: this.ownerId,
        profileId: this.profileId,
        postId: this.postId,
        mediaUrl: this.mediaUrl,
        avatarUrl: this.avatarUrl,
        username: this.username,
        location: this.location,
        description: this.description,
    );
  }
}

class PostState extends State<Post> {

  final int postId;
  final int profileId;
  final int ownerId;
  final String mediaUrl;
  final String avatarUrl;
  final String username;
  final String location;
  final String description;

  bool showHeart = false;

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  PostState({
    this.ownerId,
    this.profileId,
    this.postId,
    this.mediaUrl,
    this.avatarUrl,
    this.username,
    this.location,
    this.description,
  });

  PostBlock postBloc;

  @override
  void didChangeDependencies() {
    postBloc = PostBlockProvider.of(context);

    super.didChangeDependencies();
  }

  _likeButtonHandler() {
    postBloc.likePost();
  }

  _likeDoubleTapHandler() {
    postBloc.likePostAndShowHeart();
  }

  _toCommentsPage(BuildContext context) async {
    final page = CommentsBlockProvider(
      child: CommentPage(
        postId: postId,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }

  _toProfilePage() {

    print("RPFILE ID " + profileId.toString());

    final page = ProfileBlockProvider(
      child: ProfilePage(
        profileId: profileId,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }

  GestureDetector buildLikeIcon(liked) {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.red;
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return GestureDetector(
      child: Icon(
        icon,
        size: 25.0,
        color: color,
      ),
      onTap: () {
        _likeButtonHandler();
      },
    );
  }

  GestureDetector buildLikeableImage(bool showHeart) {
    return GestureDetector(
      onDoubleTap: () {
        _likeDoubleTapHandler();
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => loadingPlaceHolder(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          showHeart
              ? Positioned(
            child: Opacity(
                opacity: 0.85,
                child: Icon(
                  Icons.favorite,
                  size: 80.0,
                  color: Colors.white,
                )),
          )
              : Container()
        ],
      ),
    );
  }

  buildPostHeader({int ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return ListTile(
      leading: GestureDetector(
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(this.avatarUrl),
          backgroundColor: Colors.grey,
        ),
        onTap: () => _toProfilePage(),
      ),
      title: Text(this.username, style: boldStyle),
      subtitle: Text(this.location),

      trailing: const Icon(Icons.more_vert),
    );
  }

  Container loadingPlaceHolder() {
    return Container(
      height: 400.0,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //
        buildPostHeader(ownerId: ownerId),
        //

        StreamBuilder(
          stream: postBloc.showHeart,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return buildLikeableImage(snapshot.data);
            } else {
              return Container();
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            //
            StreamBuilder(
              stream: postBloc.isLiked,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return buildLikeIcon(snapshot.data);
                } else {
                  return Container();
                }
              },
            ),

            Padding(padding: const EdgeInsets.only(right: 20.0)),
            GestureDetector(
                child: const Icon(
                  Icons.comment,
                  size: 25.0,
                ),
                onTap: () { _toCommentsPage(context); }
                ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: StreamBuilder(
                stream: postBloc.likesCount,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    String count = snapshot.data.toString();

                    return Text(
                      "$count likes",
                      style: boldStyle,
                    );
                  } else {
                    return Container();
                  }
                })
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "$username ",
                  style: boldStyle,
                )),
            Expanded(child: Text(description)),
          ],
        )
      ],
    );
  }
}

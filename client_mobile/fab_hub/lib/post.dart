import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Post extends StatefulWidget {

  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final likes;
  final String postId;
  final String ownerId;

  const Post(
      {this.mediaUrl,
        this.username,
        this.location,
        this.description,
        this.likes,
        this.postId,
        this.ownerId});

  int getLikeCount(var likes) {

    if (likes == null) {
      return 0;
    }

    // issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  PostState createState() => PostState(
    mediaUrl: this.mediaUrl,
    username: this.username,
    location: this.location,
    description: this.description,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),
    ownerId: this.ownerId,
    postId: this.postId,
  );
}

class PostState extends State<Post> {

  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  Map likes;
  int likeCount;
  bool liked;
  final String postId;
  final String ownerId;

  bool showHeart = false;

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );


  PostState(
      {this.mediaUrl,
        this.username,
        this.location,
        this.description,
        this.likes,
        this.postId,
        this.likeCount,
        this.ownerId});

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
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
      onTap: () {}
    );
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () => () {},//_likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
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

  String getUrlById(String ownerId) {
    if (ownerId == "1") {
      return "https://fabhub-ui-test.s3.eu-west-2.amazonaws.com/beyonce.jpg";
    }
    else if (ownerId == "2") {
      return "https://fabhub-ui-test.s3.eu-west-2.amazonaws.com/diCaprio.jpg";
    }
    else {
      return "https://fabhub-ui-test.s3.eu-west-2.amazonaws.com/grande.jpg";
    }
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    String imageUrl = getUrlById(ownerId);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageUrl),
        backgroundColor: Colors.grey,
      ),
      title: GestureDetector(
        child: Text(username, style: boldStyle),
        onTap: () {
          //openProfile(context, ownerId);
        },
      ),
      subtitle: Text(this.location),
      trailing: const Icon(Icons.more_vert),
    );
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  Widget build(BuildContext context) {

    liked = true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //
        buildPostHeader(ownerId: ownerId),
        //
        buildLikeableImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            //
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            GestureDetector(
                child: const Icon(
                  Icons.comment,
                  size: 25.0,
                ),
                onTap: () { }
                ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: boldStyle,
              ),
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

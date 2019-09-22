import 'package:fab_hub/src/ui/post.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fab_hub/src/blocs/post_bloc_provider.dart';

class ImageTile extends StatelessWidget {

  final PostBlockProvider post;

  ImageTile(this.post);

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Photo',
              style: TextStyle(color: Colors.white)),
          ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                ),
              ],
            )),
      );
    }));
  }

  String _mediaUrl(Post widget) {
    return widget.mediaUrl;
  }

  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () => clickedImage(context),
        child: CachedNetworkImage(imageUrl: _mediaUrl(post.child), fit: BoxFit.cover)
    );
  }
}
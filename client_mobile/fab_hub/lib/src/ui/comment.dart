import 'package:flutter/material.dart';


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
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:fab_hub/src/ui/post.dart';
import 'package:fab_hub/src/ui/image_tile.dart';

import 'package:fab_hub/src/models/post_model.dart';

import 'package:fab_hub/src/blocs/search_posts_block.dart';
import 'package:fab_hub/src/blocs/search_posts_bloc_provider.dart';
import 'package:fab_hub/src/blocs/post_bloc_provider.dart';


class SearchPage extends StatefulWidget {

  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {

  SearchPostsBlock bloc;


  @override
  void didChangeDependencies() {
    bloc = SearchPostsBlockProvider.of(context);
    bloc.fetchPosts();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();

    super.dispose();
  }


  Widget noPosts() {
    return Center(
      child: Container(
        child: Text("Waiting for posts."),
      ),
    );
  }

  Widget posts() {
    return StreamBuilder(
      stream: bloc.allPosts,
      builder: (context, AsyncSnapshot<PostModel>postSnapshot) {
        if (postSnapshot.hasData) {

          var widgetPosts = postSnapshot.data.posts.map( (i) => PostBlockProvider(
              i.postId, i.username, i.likes, i.likesCount,
              child: Post(
                  ownerId: i.ownerId, profileId: i.profileId,
                  postId: i.postId, mediaUrl: i.mediaUrl,
                  avatarUrl: i.avatarUrl, username: i.username,
                  location: i.location, description: i.description
              )
          )).toList();

          List<StaggeredTile> _staggeredTiles = List<StaggeredTile>();

          for (int i = 0; i < postSnapshot.data.posts.length; i += 1) {
            if ((i + 1) % 10 == 0) {
              _staggeredTiles.add(StaggeredTile.count(2, 2));
            } else {
              _staggeredTiles.add(StaggeredTile.count(1, 1));
            }
          }

          return StaggeredGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: widgetPosts.map((PostBlockProvider imagePost) {
              return GridTile(child: ImageTile(imagePost));
            }).toList(),
            staggeredTiles: _staggeredTiles
          );

        } else {
          return noPosts();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "Explore something new",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: ListView(
            children: <Widget>[
              posts()
            ],
          )
      );
  }
}


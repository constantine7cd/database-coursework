import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:fab_hub/src/ui/post.dart';
import 'package:fab_hub/src/ui/upload_post.dart';
import 'package:fab_hub/src/ui/profile_screen.dart';
import 'package:fab_hub/src/ui/search_screen.dart';
import 'package:fab_hub/src/models/post_model.dart';
import 'package:fab_hub/src/blocs/posts_block.dart';
import 'package:fab_hub/src/blocs/post_bloc_provider.dart';
import 'package:fab_hub/src/blocs/profile_bloc_provider.dart';
import 'package:fab_hub/src/blocs/search_posts_bloc_provider.dart';
import 'package:fab_hub/src/blocs/login_register_bloc.dart';


class Feed extends StatefulWidget {

  @override
  FeedState createState() => FeedState();
}


class FeedState extends State<Feed> {

  final TextStyle logoStyle = TextStyle(fontSize: 25, fontFamily: 'Aclonica', color: Colors.white);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  int profileId;

  @override
  void initState() {
    bloc.fetchPosts();

    var _profileId = loginRegBloc.profileId;

    _profileId.then((value) {
      profileId = int.parse(value);
    });

    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      // TODO: exit button and correct exit for user
      appBar:  AppBar(
        title:  Text(
          'FubHub',
          style: logoStyle,
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(key: _refreshIndicatorKey, child: buildFeed(),
          onRefresh: _refresh),

      floatingActionButton: bottomBarButton(),
      bottomNavigationBar: bottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _refresh() {
    return bloc.fetchPosts().then((_){});
  }

  Widget buildFeed() {
    return StreamBuilder(
      stream: bloc.allPosts,
      builder: (context, AsyncSnapshot<PostModel> snapshot) {
        if (snapshot.hasData) {

          var widgetPosts = snapshot.data.posts.map( (i) => PostBlockProvider(
            i.postId, i.username, i.likes, i.likesCount,
            child: Post(
              postId: i.postId,
              profileId: i.profileId,
              ownerId: i.ownerId,
              mediaUrl: i.mediaUrl,
              avatarUrl: i.avatarUrl,
              username: i.username,
              location: i.location,
              description: i.description,
            ),
          )).toList();

          return ListView(
            children: widgetPosts,
          );

        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget bottomBarButton() {
    return FloatingActionButton(
      onPressed: () => _toUploadImage(),
      tooltip: 'Increment',
      backgroundColor : Color(0xFF974F4F),
      child: new Icon(Icons.add),
      elevation: 4.0,
    );
  }

  _toUploadImage() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {

                  final page = UploadPage(profileId,
                      ImageSource.camera);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return page;
                    }),
                  ).then((_){
                    Navigator.pop(context);
                  });

                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {

                  final page = UploadPage(profileId,
                      ImageSource.gallery);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return page;
                    }),
                  ).then((_){
                    Navigator.pop(context);
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  _toProfilePage() async {

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

  _toSearchPage() async {

    final page = SearchPostsBlockProvider(
      child: SearchPage(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }

  Widget bottomBar() {
    //TODO: bottom bar for whole page set
    return BottomAppBar(
      child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: IconButton(icon: Icon(Icons.home, size: 28,), onPressed: () {},), ),
          Expanded(child: IconButton(icon: Icon(Icons.search, size: 28,), onPressed: () => _toSearchPage(),),),
          Expanded(child: new Text('')),
          Expanded(child: IconButton(icon: Icon(Icons.favorite_border, size: 28), onPressed: (){},),),
          Expanded(child: IconButton(icon: Icon(Icons.person, size: 28), onPressed: () => _toProfilePage(),),),
        ],
      ),
    );
  }
}

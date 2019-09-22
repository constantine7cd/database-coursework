import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:fab_hub/src/ui/post.dart';
import 'package:fab_hub/src/ui/image_tile.dart';
import 'package:fab_hub/src/ui/edit_profile_screen.dart';

import 'package:fab_hub/src/models/profile_model.dart';
import 'package:fab_hub/src/models/post_model.dart';

import 'package:fab_hub/src/blocs/profile_bloc.dart';
import 'package:fab_hub/src/blocs/profile_bloc_provider.dart';
import 'package:fab_hub/src/blocs/login_register_bloc.dart';
import 'package:fab_hub/src/blocs/post_bloc_provider.dart';
import 'package:fab_hub/src/blocs/edit_profile_bloc_provider.dart';


class ProfilePage extends StatefulWidget {

  const ProfilePage({this.profileId});

  final int profileId;

  ProfilePageState createState() => ProfilePageState(this.profileId);
}

class ProfilePageState extends State<ProfilePage> {

  int currentProfileId;

  String view = "grid";

  final int profileId;
  ProfileBlock profileBloc;

  ProfilePageState(this.profileId);

  @override
  void initState() {

    var _profileId = loginRegBloc.profileId;

    _profileId.then((value) {
      currentProfileId = int.parse(value);
    });

    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    profileBloc = ProfileBlockProvider.of(context);
    profileBloc.fetchProfileById(profileId);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    profileBloc.dispose();
    super.dispose();
  }

  _changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  _toEditProfile() {
    final page = EditProfileBlockProvider(

      //TODO: issue with avatar url
      child: EditProfile(profileId),
    );

    Navigator.push(
      context, MaterialPageRoute(builder: (context) => page),
    );//.then(profileBloc.fetchProfileById(profileId));
  }

  _followProfile() async {
    try {
      await profileBloc.followProfile(profileId);
    } catch(e) {
      _failedAlert(e.toString());
    }
  }

  _unfollowProfile() async {
    try {
      await profileBloc.unfollowProfile(profileId);
    } catch(e) {
      _failedAlert(e.toString());
    }
  }

  _failedAlert(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Follow error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
                Text('Try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container followButtonSkeleton({String text, Color backgroundColor,
    Color textColor, Color borderColor, Function function})
  {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5.0)
          ),
          alignment: Alignment.center,
          child: Text(text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold
            )
          ),
          width: 250.0,
          height: 27.0,
        )
      ),
    );
  }

  Container followButton(bool isFollowing) {
    // viewing your own profile - should show edit button
    if (currentProfileId == profileId) {
      return followButtonSkeleton(
        text: "Edit Profile", backgroundColor: Colors.white,
        textColor: Colors.black, borderColor: Colors.grey,
        function: () => _toEditProfile()
      );
    }

    // already following user - should show unfollow button
    if (isFollowing) {
      return followButtonSkeleton(
          text: "Unfollow", backgroundColor: Colors.white,
          textColor: Colors.black, borderColor: Colors.grey,
          function: () => _unfollowProfile()
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return followButtonSkeleton(
          text: "Follow", backgroundColor: Colors.blue,
          textColor: Colors.white, borderColor: Colors.blue,
          function: () => _followProfile()
      );
    }

    return Container();
  }

  Column statColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400),
            ))
      ],
    );
  }

  Widget profileHeader(AsyncSnapshot<ProfileModel> snapshot) {
    print('avatar url ' + snapshot.data.profile.avatarUrl);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(snapshot.data.profile.avatarUrl),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              StreamBuilder(
                                stream: profileBloc.postsCount,
                                builder: (context, AsyncSnapshot<int> st) {
                                  return statColumn(
                                      "posts", st.hasData ? st.data : 0);
                                },
                              ),
                              StreamBuilder(
                                stream: profileBloc.followersCount,
                                builder: (context, AsyncSnapshot<int> st) {
                                  return statColumn(
                                      "followers", st.hasData ? st.data : 0);
                                },
                              ),
                              StreamBuilder(
                                stream: profileBloc.followingCount,
                                builder: (context, AsyncSnapshot<int> st) {
                                  return statColumn(
                                      "following", st.hasData ? st.data : 0);
                                },
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                StreamBuilder(
                                  stream: profileBloc.isFollowing,
                                  builder: (context, AsyncSnapshot<bool> st) {
                                    return followButton(st.hasData ? st.data : false);
                                  },
                                ),
                              ]),
                        ],
                      ),
                  )
                ],
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    snapshot.data.profile.username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                //bio
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(snapshot.data.profile.bio),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row imageViewButtonBar() {
    Color isActiveButtonColor(String viewName) {
      if (view == viewName) {
        return Colors.blueAccent;
      } else {
        return Colors.black26;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on, color: isActiveButtonColor("grid")),
          onPressed: () {
            _changeView("grid");
          },
        ),
        IconButton(
          icon: Icon(Icons.list, color: isActiveButtonColor("feed")),
          onPressed: () {
            _changeView("feed");
          },
        ),
      ],
    );
  }

  Widget noPosts() {
    return Center(
      child: Container(
        child: Text("No posts for this profile."),
      ),
    );
  }

  Widget profilePosts() {
    return StreamBuilder(
      stream: profileBloc.posts,
      builder: (context, AsyncSnapshot<Future<PostModel>> futurePostSnapshot) {
        if (futurePostSnapshot.hasData) {
          return FutureBuilder(
            future: futurePostSnapshot.data,
            builder: (context, AsyncSnapshot<PostModel> postSnapshot) {

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

                if (view == 'grid') {
                  return GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 1.5,
                    crossAxisSpacing: 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: widgetPosts.map((PostBlockProvider imagePost) {
                      return GridTile(child: ImageTile(imagePost));
                    }).toList());
                } else {
                  return Column(
                    children: widgetPosts.map((PostBlockProvider imagePost) {
                      return imagePost;
                    }).toList());
                }
              } else {
                return noPosts();
              }
            },
          );
        } else {
          return Container(
              alignment: FractionalOffset.center,
              padding: const EdgeInsets.only(top: 10.0),
              child: CircularProgressIndicator());
        }
      },
    );
  }
  
  Widget profileSkeleton(AsyncSnapshot<ProfileModel> profileSnapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          profileSnapshot.data.profile.username,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          profileHeader(profileSnapshot),
          Divider(),
          imageViewButtonBar(),
          Divider(height: 0.0),
          profilePosts(),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: profileBloc.profile,
      builder: (context, AsyncSnapshot<Future<ProfileModel>> profileFutureSnapshot) {

        if (profileFutureSnapshot.hasData) {
          return FutureBuilder(
            future: profileFutureSnapshot.data,
            builder: (context, AsyncSnapshot<ProfileModel> profileSnapshot) {
              if (profileSnapshot.hasData) {
                return profileSkeleton(profileSnapshot);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}


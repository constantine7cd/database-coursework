import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fab_hub/src/blocs/edit_profile_bloc_provider.dart';
import 'package:fab_hub/src/blocs/edit_profile_bloc.dart';
import "package:fab_hub/src/blocs/login_register_bloc.dart";

import "package:fab_hub/src/models/profile_model.dart";
import "package:fab_hub/src/ui/custom_widgets.dart";
import "package:fab_hub/src/ui/upload_avatar_screen.dart";


class EditProfile extends StatefulWidget {

  final int profileId;

  const EditProfile(this.profileId);
  
  @override
  EditProfileState createState() => EditProfileState(profileId);
}

class EditProfileState extends State<EditProfile> {
  final TextEditingControllerWorkaroud usernameController = TextEditingControllerWorkaroud();
  final TextEditingControllerWorkaroud bioController = TextEditingControllerWorkaroud();
  final TextEditingControllerWorkaroud firstNameController = TextEditingControllerWorkaroud();
  final TextEditingControllerWorkaroud lastNameController = TextEditingControllerWorkaroud();
  final TextEditingControllerWorkaroud websiteController = TextEditingControllerWorkaroud();

  final profileId;
  //final avatarUrl;

  EditProfileBlock editBloc;
  
  EditProfileState(this.profileId);/* {

    /*usernameController.setTextAndPosition(username);
    firstNameController.setTextAndPosition(firstName);
    lastNameController.setTextAndPosition(lastName);
    bioController.setTextAndPosition(bio);
    websiteController.setTextAndPosition(website);*/
  }*/

  @override
  void didChangeDependencies() {
    editBloc = EditProfileBlockProvider.of(context);
    editBloc.fetchProfileById(profileId);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    editBloc.dispose();
    super.dispose();
  }

  _changeProfilePhoto(BuildContext parentContext) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Change profile photo'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {

                  final page = UploadAvatarPage(profileId, ImageSource.camera);

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

                  final page = UploadAvatarPage(profileId, ImageSource.gallery);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return page;
                    }),
                  ).then((_){
                    Navigator.pop(context);
                  });
                }),
            /*SimpleDialogOption(
                child: const Text('Remove profile photo'),
                onPressed: () async {

                }),*/
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

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  Widget buildEdit(ProfileModel profile) {

    usernameController.setTextAndPosition(profile.profile.username);
    firstNameController.setTextAndPosition(profile.profile.firstName);
    lastNameController.setTextAndPosition(profile.profile.lastName);
    bioController.setTextAndPosition(profile.profile.bio);
    websiteController.setTextAndPosition(profile.profile.website);

    return Container(
      child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(profile.profile.avatarUrl),
            radius: 50.0,
          ),
        ),
        FlatButton(
            onPressed: () {
              _changeProfilePhoto(context);
            },
          child: Text(
            "Change Photo",
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              buildTextField(name: "Name", controller: usernameController),
              buildTextField(name: "Bio", controller: bioController),
              buildTextField(name: "First Name", controller: firstNameController),
              buildTextField(name: "Last Name", controller: lastNameController),
              buildTextField(name: "Website", controller: websiteController),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            onPressed: () => _logout(context),
            child: Text("Logout")
          )
        )
      ],
      )
    );
  }

  _submitAndPop() {
    Future<void> future = editBloc.editProfile(profileId: profileId,
      uname: usernameController.text, fName: firstNameController.text,
      lName: lastNameController.text, bio: bioController.text,
      wsite: websiteController.text);

    future.then((model) {
      Navigator.pop(context);
    });
  }

  Widget buildSkeleton() {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Edit Profile',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _submitAndPop();
                })
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: editBloc.profile,
                builder: (context, AsyncSnapshot<Future<ProfileModel>> futureSnapshot) {
                  if (futureSnapshot.hasData) {
                    return FutureBuilder(
                      future: futureSnapshot.data,
                      builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
                        if (snapshot.hasData) {
                          return buildEdit(snapshot.data);
                        } else {
                          return Center(child: Text("loading..."));
                        }
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return buildSkeleton();
  }

  void _logout(BuildContext context) async {

    try {
      loginRegBloc.logout().then((_) {
        Navigator.pushReplacementNamed(context, "/");
      });
    } catch(e) {
      throw(e);
    }

  }
}
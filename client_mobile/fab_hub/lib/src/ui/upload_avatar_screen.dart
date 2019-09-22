import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fab_hub/src/blocs/upload_image_bloc.dart';
import 'package:fab_hub/src/blocs/profile_info_bloc.dart';


class UploadAvatarPage extends StatefulWidget {

  final profileId;
  final ImageSource imgSource;

  UploadAvatarPage(this.profileId, this.imgSource);

  UploadAvatarPageState createState() => UploadAvatarPageState(profileId, imgSource);
}

class UploadAvatarPageState extends State<UploadAvatarPage> {


  bool uploading = false;

  final ImageSource imgSource;
  final profileId;

  UploadAvatarPageState(this.profileId, this.imgSource);

  @override
  initState() {
    uploadBloc.pickImage(imgSource);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    profileInfoBloc.fetchProfile(profileId);

    super.didChangeDependencies();
  }

  @override
  dispose() {
    uploadBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    //TODO: if back button pressed when in choose image from gallery or in camera
    //TODO: then we come up with Circular Indicator, but we need to pop page.
    return StreamBuilder(stream: uploadBloc.file,
        builder: (context, AsyncSnapshot<File> fileSnapshot) {
          if (fileSnapshot.hasData) {
            return Scaffold(
                resizeToAvoidBottomPadding: true,
                appBar: AppBar(
                  title: const Text(
                    'New avatar',
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => _postImage(fileSnapshot.data),
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ))
                  ],
                ),
                body: ListView(
                    children: <Widget>[
                      postForm(fileSnapshot.data),
                    ]
                )
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  Widget postForm(File imageFile) {


    return Column(
      children: <Widget>[
        uploading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: FileImage(imageFile),
              )
            ),
        ),
        Divider(),
      ]
    );
  }

  _postImage(imageFile) async {

    setState(() {
      uploading = true;
    });

    try {
      await uploadBloc.uploadAvatar(imageFile);

      setState(() {
        uploading = true;
      });

      _avatarAdded().then((_){
        Navigator.pop(this.context);
      });
    } catch (e) {
      _failedAlert(e.toString()).then((_){
        Navigator.pop(this.context);
      });
    }
  }

  Future<void> _avatarAdded() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Avatar was added!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Pretty good choice!'),
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

  Future<void> _failedAlert(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add avatar error'),
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
}

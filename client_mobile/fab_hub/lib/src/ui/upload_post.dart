import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoder/geocoder.dart';

import 'package:fab_hub/src/blocs/upload_image_bloc.dart';
import 'package:fab_hub/src/blocs/profile_info_bloc.dart';
import 'package:fab_hub/src/ui/custom_widgets.dart';
import 'package:fab_hub/src/models/profile_model.dart';


class UploadPage extends StatefulWidget {

  final ImageSource imgSource;
  final int profileId;
  
  UploadPage(this.profileId, this.imgSource);

  UploadPageState createState() => UploadPageState(this.profileId, this.imgSource);
}

class UploadPageState extends State<UploadPage> {

  Address address;

  TextEditingControllerWorkaroud descriptionController = TextEditingControllerWorkaroud();
  TextEditingControllerWorkaroud locationController = TextEditingControllerWorkaroud();

  bool uploading = false;

  final ImageSource imgSource;
  final int profileId;

  UploadPageState(this.profileId, this.imgSource);

  @override
  initState() {
    uploadBloc.pickImage(imgSource);
    uploadBloc.getUserLocation();
    profileInfoBloc.fetchProfile(profileId);
    super.initState();
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
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: const Text(
              'Post to',
              style: const TextStyle(color: Colors.white),
              ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => _postImage(fileSnapshot.data),
                  child: Text(
                    "Post",
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
                      Divider(),
                      StreamBuilder(
                        stream: uploadBloc.location,
                        builder: (context, AsyncSnapshot<Address> addrSnapshot) {
                          if (addrSnapshot.hasData) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  buildLocationButton(addrSnapshot.data.featureName),
                                  buildLocationButton(addrSnapshot.data.subLocality),
                                  buildLocationButton(addrSnapshot.data.locality),
                                  buildLocationButton(addrSnapshot.data.subAdminArea),
                                  buildLocationButton(addrSnapshot.data.adminArea),
                                  buildLocationButton(addrSnapshot.data.countryName),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }
                      ),
                    ]
                  )
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget postForm(imageFile) {
    return Column(
      children: <Widget>[
        uploading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.center,
                    image: FileImage(imageFile),
                  )),
            ),
          ),
        ),
        Divider(),
        Row(
          children: <Widget>[

            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: StreamBuilder(
                stream: profileInfoBloc.profile,
                builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data.profile.avatarUrl),
                    );
                  } else {
                    return Container();
                  }
                }
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
          ]
        ),
        Container(
          child: ListTile(
            leading: Icon(Icons.pin_drop),
            title: Container(
              //width: MediaQuery.of(context).size.width
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    hintText: "Where was this photo taken?",
                    border: InputBorder.none
                ),
              ),
            ),
          ),
        )
        //Divider(),
      ],
    );
  }

  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {

          String coma = locationController.text == "" ? "" : ", ";

          setState(() {
            locationController.setTextAndPosition(locationController.text + coma + locationName);
          });
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _postImage(imageFile) async {

    setState(() {
      uploading = true;
    });

    try {
      await uploadBloc.uploadPost(imageFile, descriptionController.text,
          locationController.text);

      setState(() {
        uploading = true;
      });

      _postAdded().then((_){
        Navigator.pop(this.context);
      });
    } catch (e) {
      _failedAlert(e.toString()).then((_){
        Navigator.pop(this.context);
      });

    }
  }

  Future<void> _postAdded() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post was added!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('It\'s time to wait for likes and comments!'),
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
          title: Text('Post error'),
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

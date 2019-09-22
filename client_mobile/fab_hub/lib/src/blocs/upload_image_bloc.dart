import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fab_hub/src/resources/repository.dart';
import 'package:fab_hub/src/models/profile_model.dart';


class UploadBlock {
  final _repository = Repository();
  final _locationFetcher = BehaviorSubject<Address>();
  final _imageFetcher = BehaviorSubject<File>();

  //To show profile avatar and other necessary information for profile
  final _profileInfoFetcher = BehaviorSubject<ProfileModel>();

  Observable<Address> get location => _locationFetcher.stream;
  Observable<File> get file => _imageFetcher.stream;
  Observable<ProfileModel> get profile => _profileInfoFetcher.stream;
  
  fetchAvatar(profileId) async {
    var _profile = await _repository.fetchProfile(profileId);

    _profileInfoFetcher.sink.add(_profile);
  }
  
  Future<void> uploadPost(File file, String description, String location) async {

    try {
      var res = await _repository.uploadPost(file, description, location);
      return res;

    } catch(e) {
      throw(e);
    }
  }

  Future<void> uploadAvatar(File file) async {

    try {
      var res = await _repository.uploadImage(file);
      return res;

    } catch(e) {
      throw(e);
    }
  }

  Future<void> getUserLocation() async {
    LocationData currentLocation;
    String error;
    Location location = Location();
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {

      //TODO: correct exception handling
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      currentLocation = null;
    }
    final coordinates = Coordinates(
        currentLocation.latitude, currentLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    _locationFetcher.sink.add(first);

    return;
  }

  pickImage(imgSource) async {
    File _file = await ImagePicker.pickImage(source: imgSource, maxWidth: 1920, maxHeight: 1350);

    _imageFetcher.sink.add(_file);
  }

  void dispose() async {
    _profileInfoFetcher.close();
    
    await _locationFetcher.drain();
    _locationFetcher.close();

    await _imageFetcher.drain();
    _imageFetcher.close();
  }

}

final uploadBloc = UploadBlock();
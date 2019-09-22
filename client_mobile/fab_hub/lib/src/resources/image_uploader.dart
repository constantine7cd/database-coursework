import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';


import '../../settings.dart';


class ImageUploader {

  Client client = Client();

  Future <void> uploadPost(File file, String description, String location)  async {

    if (Platform.isAndroid) {
      var image = await FlutterExifRotation.rotateImage(path: file.path);
      file = image;
    }

    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    String ext = extension(file.path);


    Response response;

    var body = {
      'image' : base64Image,
      'extension' : ext.substring(1),
      'description' : description,
      'location' : location
    };

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.post(_settings.uploadPostUrl, headers: header, body: body);


    if (response.statusCode == 200)
      return;

    throw Exception("Failed to upload post");

  }

  Future <void> uploadImage(File file)  async {

    if (Platform.isAndroid) {
      var image = await FlutterExifRotation.rotateImage(path: file.path);
      file = image;
    }

    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    String ext = extension(file.path);


    Response response;

    var body = {
      'image' : base64Image,
      'extension' : ext.substring(1),
    };

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.post(_settings.uploadAvatarUrl, headers: header, body: body);

    if (response.statusCode == 200)
      return;

    throw Exception("Failed to upload avatar");

  }
}
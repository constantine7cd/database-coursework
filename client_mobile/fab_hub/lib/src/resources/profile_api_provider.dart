import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:http/http.dart' as http;

import 'package:fab_hub/src/models/profile_model.dart';

import '../../settings.dart';


class ProfileApiProvider {

  Client client = Client();

  Future <ProfileModel> fetchProfile(int profileId)  async {

    Response response;

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.get(_settings.profileUrl + profileId.toString(), headers: header);

    if (response.statusCode == 200) {

      var res = ProfileModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

      return res;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future <void> editProfile({String username, String fName, String lName,
    String bio, String website, String avatarUrl}) async {

    Response response;

    var body = {
      "username": username,
      "first_name": fName,
      "last_name": lName,
      "bio" : bio ?? "",
      "website_url": website ?? "",
      "avatar_url" : avatarUrl ?? "",
    };

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.post(_settings.editProfileUrl,
        headers: header, body: body);

    if (response.statusCode == 200) {
      return;

    } else if (response.statusCode == 409) {
      throw Exception("This username uses another user!");
    } else {
      throw Exception("Failed to edit profile");
    }
  }

  Future<Response> postRequest(url, data, headers) async {
    var body = json.encode(data);

    Response response = await http.post(url,
      headers: headers,
      body: body,
    );

    return response;
  }

  Future <void> followProfile(int subscribingProfileId) async {
    Response response;

    var body = {
      "subscribing_profile_id" : subscribingProfileId
    };

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await postRequest(_settings.followProfile, body, header);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to follow");
    }
  }

  Future <void> unfollowProfile(int subscribingProfileId) async {
    Response response;

    var body = {
      "subscribing_profile_id" : subscribingProfileId
    };

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await postRequest(_settings.unfollowProfile, body, header);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to unfollow");
    }
  }
}

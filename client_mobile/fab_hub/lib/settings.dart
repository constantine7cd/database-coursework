import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import "package:fab_hub/src/blocs/login_register_bloc.dart";

class Settings {

  final String baseUrl;

  final String loginUrl;

  final String logoutUrl;

  final String registerUrl;

  final String postsUrl;

  final String searchPostsUrl;

  final String likeUrl;

  final String unLikeUrl;

  final String addCommentUrl;

  final String profileItemsUrl;

  final String commentsOfPost;

  final String profileUrl;

  final String editProfileUrl;

  final String followProfile;

  final String unfollowProfile;

  final String uploadPostUrl;

  final String uploadAvatarUrl;

  final int responseStatusOK;

  final int responseStatusCreated;

  final int responseBadRequest;

  Settings(this.baseUrl, this.loginUrl, this.logoutUrl,
      this.registerUrl, this.postsUrl, this.searchPostsUrl, this.likeUrl, this.unLikeUrl,
      this.addCommentUrl, this.profileItemsUrl, this.commentsOfPost,
      this.profileUrl, this.editProfileUrl, this.followProfile,
      this.unfollowProfile, this.uploadPostUrl, this.uploadAvatarUrl,
      this.responseStatusOK, this.responseStatusCreated, this.responseBadRequest);

  factory Settings.fromJsonFile(Map fileContent) {

    var _baseUrl = fileContent['base'];

    var _loginUrl = _baseUrl + fileContent['login'];

    var _logoutUrl = _baseUrl + fileContent['logout'];

    var _registerUrl = _baseUrl + fileContent['register'];

    var _postsUrl = _baseUrl + fileContent['posts'];

    var _searchPostsUrl = _baseUrl + fileContent['search_posts'];

    var _likeUrl = _baseUrl + fileContent['like'];

    var _unLikeUrl = _baseUrl + fileContent['unlike'];

    var _addCommentUrl = _baseUrl + fileContent['add_comment'];

    var _profileItemsUrl = _baseUrl + fileContent['profile_items'];

    var _commentsOfPost = _baseUrl + fileContent['comments_of_post'];

    var _profileUrl = _baseUrl + fileContent['profile'];

    var _editProfileUrl = _baseUrl + fileContent['edit_profile'];

    var _followProfile = _baseUrl + fileContent['follow_profile'];

    var _unfollowProfile = _baseUrl + fileContent['unfollow_profile'];

    var _uploadPostUrl = _baseUrl + fileContent['upload_post'];

    var _uploadAvatarUrl = _baseUrl + fileContent['upload_avatar'];

    var _responseStatusOK = fileContent['response_ok'];

    var _responseStatusCreated = fileContent['response_created'];

    var _responseBadRequest = fileContent['response_bad_request'];

    return Settings(_baseUrl, _loginUrl, _logoutUrl, _registerUrl, _postsUrl,
        _searchPostsUrl,
        _likeUrl, _unLikeUrl, _addCommentUrl, _profileItemsUrl,
        _commentsOfPost, _profileUrl, _editProfileUrl, _followProfile,
        _unfollowProfile, _uploadPostUrl, _uploadAvatarUrl,
        _responseStatusOK, _responseStatusCreated, _responseBadRequest);
  }

  Map<String, String> get headerContentTypeJson => {"Content-Type": "application/json"};

  Future<Map<String, String>> get headerContentAndAuth async {

    String token = await loginRegBloc.token();

    var res = {
      "Authorization": "Token " + token
    };

    return res;
  }

  Future<Map<String, String>> get headerContentAndAuthJson async {

    String token = await loginRegBloc.token();

    var res = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };

    return res;
  }
}

Future<Settings> loadConfig(String jsonPath) async {

  String jsonString = await rootBundle.loadString(jsonPath);
  final jsonResponse = json.decode(jsonString);

  return Settings.fromJsonFile(jsonResponse);
}

Future<Settings> settings = loadConfig('assets/config.json');
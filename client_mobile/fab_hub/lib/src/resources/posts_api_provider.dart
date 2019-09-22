import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;

import 'package:fab_hub/src/models/post_model.dart';

import '../../settings.dart';


class PostApiProvider {

  Client client = Client();

  Future <PostModel> fetchPostList()  async {

    Response response;

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.get(_settings.postsUrl, headers: header);

    if (response.statusCode == 200) {

      print(json.decode(response.body));

      List<Map<String, dynamic>> data = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();

      var res = PostModel.fromJson(data);

      print(res.toString());

      return res;
    } else {
      throw Exception('Failed to load posts');
    }
  }


  Future <PostModel> fetchSearchPostList()  async {

    Response response;

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.get(_settings.searchPostsUrl, headers: header);

    if (response.statusCode == 200) {

      print(json.decode(response.body));

      List<Map<String, dynamic>> data = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();

      var res = PostModel.fromJson(data);

      print(res.toString());

      return res;
    } else {
      throw Exception('Failed to load posts');
    }
  }


  Future <PostModel> fetchPostsProfile(int profileId)  async {

    Response response;

    var body = {
      "profile_id" : profileId.toString()
    };

    print(body);

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.post(_settings.profileItemsUrl, headers: header, body: body);

    if (response.statusCode == 200) {

      print(json.decode(response.body));

      List<Map<String, dynamic>> data = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();

      var res = PostModel.fromJson(data);

      print(res.toString());

      return res;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

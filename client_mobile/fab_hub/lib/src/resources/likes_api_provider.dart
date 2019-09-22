import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Response;
import 'package:http/http.dart' as http;

import '../../settings.dart';


class LikesApiProvider {

  Future <void> likeItem(postId)  async {

    Response response;

    var body = {
      'item_id' : postId.toString(),
    };

    var bodyEncoded = json.encode(body);

    var _settings = await settings;

    var headers = await _settings.headerContentAndAuth;

    response = await http.post(_settings.likeUrl,
      headers: headers,
      body: bodyEncoded,
    );

    if (response.statusCode == 200)
      return;

    throw Exception("Failed to like post.");
  }

  Future <void> unlikeItem(postId)  async {

    Response response;

    var body = {
      'item_id' : postId.toString(),
    };

    var bodyEncoded = json.encode(body);

    var _settings = await settings;

    var headers = await _settings.headerContentAndAuth;

    response = await http.post(_settings.unLikeUrl,
      headers: headers,
      body: bodyEncoded,
    );

    if (response.statusCode == 200)
      return;

    throw Exception("Failed to unlike post.");
  }
}
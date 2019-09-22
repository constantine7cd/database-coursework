import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;

//import '../models/comment_model.dart';
import 'package:fab_hub/src/models/comment_model.dart';
import 'package:fab_hub/src/resources/auth_storage.dart';
import '../../settings.dart';


class CommentApiProvider {

  Client client = Client();

  Future <CommentModel> fetchCommentList(int postId)  async {

    Response response;

    var body = {
      "post_id" : postId.toString()
    };

    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.post(_settings.commentsOfPost, headers: header, body: body);

    print(response.statusCode.runtimeType);

    if (response.statusCode == 200) {


      List<Map<String, dynamic>> data = json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();

      return CommentModel.fromJson(data);

    } else {
      throw Exception('Failed to load posts');
    }

  }


  Future <bool> addComment(postId, commentBody)  async {

    Response response;

    var body = {
      'item_id' : postId.toString(),
      'body' : commentBody
    };

    print("item id " + postId.toString());
    print("body " + commentBody);


    var _settings = await settings;

    var header = await _settings.headerContentAndAuth;

    response = await client.post(_settings.addCommentUrl, headers: header, body: body);


    if (response.statusCode == 200)
      return true;

    return false;

  }
}
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Response;
import 'package:http/http.dart' as http;


import '../../settings.dart';


class Logger {

  Future<Response> postRequest(url, data, headers) async {
    var body = json.encode(data);

    print("we are here");

    Response response = await http.post(url,
      headers: headers,
      body: body,
    );

    return response;
  }

  Future<Map<String, dynamic>> register(String email, String username, String password,
      String firstName, String lastName) async {
    var body = {
      'email': email,
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName
    };

    var _settings = await settings;

    Response response = await postRequest(
        _settings.registerUrl, body, _settings.headerContentTypeJson);

    if (response.statusCode == _settings.responseStatusCreated) {
      return json.decode(response.body);

    } else {
      Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("email"))
        throw Exception("This email is in use. Please choose another email.");

      if (data.containsKey("username"))
        throw Exception("This username is in use. Please choose another username.");

      throw Exception("Failed to register.");

    }
  }

  Future<Map<String, dynamic>>login(String email, String password) async {
    var body = {
      'email': email,
      'password': password,
    };


    var bodyEncoded = json.encode(body);

    var _settings = await settings;

    Response response = await http.post(_settings.loginUrl,
      headers: _settings.headerContentTypeJson,
      body: bodyEncoded,
    );

    if (response.statusCode == _settings.responseStatusOK) {
      print("yeeeepp");

      return json.decode(response.body);
    } else {
      print("not yeepp");

      throw Exception("Failed login");
    }
  }

  Future<void> logout() async {

    var _settings = await settings;

    var headers = await _settings.headerContentAndAuth;

    Response response = await http.post(_settings.logoutUrl, headers: headers);

    if (response.statusCode == _settings.responseStatusOK) {
      return;
    } else {
      throw Exception("Failed to logout");
    }

  }
}
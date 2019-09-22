import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {

  final _storage = FlutterSecureStorage();

  final _keys = ['Token', 'username', 'userId', 'profileId'];

  bool _isAuthenticated = false;

  bool get isAuthenticated  => _isAuthenticated;

  set isAuthenticated(value)  {_isAuthenticated = value;}


  Future<String> getItem(key) async {

    print("Is Authenticated: " + _isAuthenticated.toString());
    print("keys contains: " + _keys.contains(key).toString());

    if (_isAuthenticated && _keys.contains(key)) {
      String item = await _storage.read(key: key);

      return item;
    } else {
      throw Exception("Check if you're authentificated and your key!");
    }
  }

  Future<void> addItem(String key, String value) async {
    if (!_isAuthenticated && _keys.contains(key)) {
      await _storage.write(key: key, value: value);

      return;
    } else {
      throw Exception("Check if you're not authentificated and your key!");
    }
  }

  Future<void> deleteItem(String key) async {
    if (_isAuthenticated && _keys.contains(key)) {
      await _storage.delete(key: key);

      return;
    } else {
      throw Exception("Check if you're authentificated and your key!");
    }
  }

  Future<void> deleteAll() async {
    if (_isAuthenticated ) {
      await _storage.deleteAll();
      return;
    } else {
      throw Exception("Check if you're authentificated!");
    }
  }
}

AuthStorage authStorage = AuthStorage();
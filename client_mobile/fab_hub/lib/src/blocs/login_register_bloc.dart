import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import 'package:fab_hub/src/resources/auth_storage.dart';


class LoginRegisterBloc {
  final _repository = Repository();
  final _authStorage = AuthStorage();

  Future<Map<String, dynamic>> register(String email, String username, String password, String firstName, String lastName) async {

    try {
      var data = await _repository.register(email, username, password, firstName, lastName);

      return data;
    } catch (e){
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    var data = await _repository.login(email, password);

    //TODO Exceptions login

    _authStorage.addItem("Token", data['auth_token']);
    _authStorage.addItem("username", data['user']['username']);
    _authStorage.addItem("userId", data['user']['id'].toString());
    _authStorage.addItem("profileId", data['user']['profile']['id'].toString());

    _authStorage.isAuthenticated = true;

    return;
  }

  Future<void> logout() async {

    try {
      await _repository.logout();
      await _authStorage.deleteAll();
      _authStorage.isAuthenticated = false;
    } catch(e) {
      throw(e);
    }
  }


  Future<String> token() async {
    var res = await _authStorage.getItem("Token");

    //TODO: Exceptions token

    return res;
  }

  Future<String> get username async => await _authStorage.getItem("username");
  Future<String> get userId async => await _authStorage.getItem("userId");
  Future<String> get profileId async => await _authStorage.getItem("profileId");
  get isAuthenticated => _authStorage.isAuthenticated;


  dispose() {

  }


}

final loginRegBloc = LoginRegisterBloc();
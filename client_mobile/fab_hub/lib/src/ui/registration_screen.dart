import 'package:flutter/material.dart';
import '../../credentials_validate.dart';

import 'package:fab_hub/src/blocs/login_register_bloc.dart';

class Registration extends StatefulWidget {
  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {

  final _formKey = GlobalKey<FormState>();
  final TextStyle logoStyle = TextStyle(fontSize: 82, fontFamily: 'Aclonica', color: Color(0xFF974F4F));
  final TextStyle inputStyle = TextStyle(fontFamily: 'ReemKufi', fontSize: 21.0, color: Colors.white);
  final TextStyle bottomStyle = TextStyle(fontSize: 23, fontFamily: 'ReemKufi', color: Colors.white);

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    loginRegBloc.dispose();
    super.dispose();
  }

  _registerAndLogin() async {

    try {
      var response = await loginRegBloc.register(_emailController.text,
          _usernameController.text, _passwordController.text,
          _firstNameController.text, _lastNameController.text);

      await loginRegBloc.login(response['email'], response['password']);

      Navigator.of(context).pushReplacementNamed('/feed');

      _successAlert("Enjoy our fabulous hub!");

    } catch (e) {
      _failedAlert(e.toString());
    }
  }

  _failedAlert(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
                Text('Try again'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _successAlert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration complete!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget inputField({validator, controller, text, obscureText=false}) {
    return Container(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 5),
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          style: inputStyle,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
              fillColor: Color(0xFFC4C4C4),
              filled: true,
              hintText: text,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
        )
    );
  }

  Widget credentialsInput() {
    
    Widget emailField = inputField(validator: CredentialsValidate.validateEmail,
        controller: _emailController, text: "Email");

    //TODO: appropriate validator for username
    Widget usernameField = inputField(validator: CredentialsValidate.validateName,
        controller: _usernameController, text: "Username");

    Widget passwordField = inputField(validator: CredentialsValidate.validatePassword,
        controller: _passwordController, text: "Password", obscureText: true);

    Widget passwordAgainField = inputField(text: "Password again",
        validator: (value) => CredentialsValidate.validatePasswordEqual(value,
        _passwordController.text), obscureText: true);

    Widget firstNameField = inputField(validator: CredentialsValidate.validateName,
        controller: _firstNameController, text: "First Name");

    Widget lastNameField = inputField(validator: CredentialsValidate.validateName,
        controller: _lastNameController, text: "Last Name");

    Widget regButton = Container(
      padding: EdgeInsets.fromLTRB(40, 18, 40, 5),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(6.0),
        color: Color(0xFFA35555),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _registerAndLogin();
            }
          },
          child: Text("Register",
            textAlign: TextAlign.center,
            style: inputStyle.copyWith(fontSize: 25),
          ),
        ),
      )
    );

    return Container(
      padding: EdgeInsets.fromLTRB(0, 140, 0, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            emailField,
            usernameField,
            passwordField,
            passwordAgainField,
            firstNameField,
            lastNameField,
            regButton,
          ],
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          credentialsInput(),
        ],
      ),
      backgroundColor: Color(0xFFE5E5E5),
    );
  }
}


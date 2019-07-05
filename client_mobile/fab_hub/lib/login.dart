import 'package:flutter/material.dart';

class LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final TextStyle logoStyle = TextStyle(fontSize: 82, fontFamily: 'Aclonica', color: Color(0xFF974F4F));
  final TextStyle inputStyle = TextStyle(fontFamily: 'ReemKufi', fontSize: 21.0, color: Colors.white);
  final TextStyle bottomStyle = TextStyle(fontSize: 23, fontFamily: 'ReemKufi', color: Colors.white);

  Widget Logo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 250, 30, 10),
      child: Text(
        'FabHub',
        textAlign: TextAlign.center,
        style: logoStyle,
      ),
    );
  }

  Widget LoginInput() {

    Widget emailField = Container(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 5),
        child: TextFormField(
          validator: LoginValidate.validateEmail,
          obscureText: false,
          style: inputStyle,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              fillColor: Color(0xFFC4C4C4),
              filled: true,
              hintText: "Email",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
        )
    );

    Widget passwordField = Container(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
        child: TextFormField(
          validator: LoginValidate.validatePassword,
          obscureText: true,
          style: inputStyle,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
              fillColor: Color(0xFFC4C4C4),
              hintText: "Password",
              filled: true,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
        )
    );

    Widget loginButton = Container(
        padding: EdgeInsets.fromLTRB(40, 18, 40, 5),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(6.0),
          color: Color(0xFFA35555),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {

              //This is a mock for our authentication systen
              if (_formKey.currentState.validate()) {
                print("Oh yeah!");
              }
            },
            child: Text("Log In",
              textAlign: TextAlign.center,
              style: inputStyle.copyWith(fontSize: 25),
            ),
          ),
        )
    );

    return Container(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            emailField,
            passwordField,
            loginButton,
          ],
        ),
      ),
    );
  }

  Widget Bottom() {
    Widget divider = Divider(color:  Color(0xFF9F8787) );

    Widget signUpRef = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'If you don’t have an account just ',
          textAlign: TextAlign.center,
          style: bottomStyle,
        ),
        Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style: bottomStyle.copyWith(color: Color(0xFFA35555)),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.fromLTRB(5, 180, 5, 5),
      child: Column(
        children: <Widget>[
          divider,
          signUpRef
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Logo(),
          LoginInput(),
          Bottom(),
        ],
      ),
      backgroundColor: Color(0xFFE5E5E5),
    );
  }
}

class Login extends StatefulWidget {

  @override
  LoginState createState() => LoginState();
}

class LoginValidate {
  static String validatePassword(String value) {
    if (value.length < 3)
      return 'Password must be more than 2 charater';

    return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';

    return null;
  }
}
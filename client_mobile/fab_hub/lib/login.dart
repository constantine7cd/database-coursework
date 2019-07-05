import 'package:flutter/material.dart';

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {

    TextStyle inputStyle = TextStyle(fontFamily: 'ReemKufi', fontSize: 21.0, color: Colors.white);

    Widget logo = Container(
      padding: const EdgeInsets.fromLTRB(30, 250, 30, 10),
      child: Text(
        'FabHub',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 82, fontFamily: 'Aclonica', color: Color(0xFF974F4F)),
      ),
    );

    Widget emailField = Container(
      padding: EdgeInsets.fromLTRB(40, 100, 40, 5),
      child: TextField(
        obscureText: false,
        style: inputStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            fillColor: Color(0xFFE2E1E1),
            filled: true,
            hintText: "Email",
            border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
      )
    );

    Widget passwordField = Container(
      padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
      child: TextField(
        obscureText: false,
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
      padding: EdgeInsets.fromLTRB(40, 18, 40, 10),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(6.0),
        color: Color(0xFFA35555),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {},
          child: Text("Log In",
            textAlign: TextAlign.center,
            style: inputStyle.copyWith(fontSize: 25),
          ),
        ),
      )
    );

    Widget divider = Divider(color:  Color(0xFF9F8787) );

    Widget signUpRef = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'If you don’t have an account just ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontFamily: 'ReemKufi', color: Color(0xFFFFFFFF)),
        ),
        Text(
          'Sing Up',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontFamily: 'ReemKufi', color: Color(0xFFA35555)),
        ),
      ],
    );

    Widget bottom = Container(
      padding: EdgeInsets.fromLTRB(5, 180, 5, 5),
      child: Column(
        children: <Widget>[
          divider,
          signUpRef
        ],
      ),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          logo,
          emailField,
          passwordField,
          loginButton,
          bottom,
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
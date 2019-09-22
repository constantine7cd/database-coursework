import 'package:flutter/material.dart';
import 'ui/login_screen.dart';
import 'ui/registration_screen.dart';
import 'ui/feed_screen.dart';
import 'package:fab_hub/src/ui/profile_screen.dart';

import 'package:fab_hub/src/blocs/login_register_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Color(0xFF974F4F),
      ),
      //home: Login(),

      initialRoute: loginRegBloc.isAuthenticated ? '/feed' : '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => Login(),
        '/registration': (context) => Registration(),
        '/feed' : (context) => Feed(),
        //'/profile' : (context) => ProfilePage()
      },

    );
  }
}
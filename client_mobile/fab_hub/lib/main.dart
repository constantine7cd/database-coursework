import 'package:flutter/material.dart';
import 'login.dart';
import 'registration.dart';
import 'feed.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Color(0xFF974F4F),
      ),
      home: Feed(),
    );
  }
}

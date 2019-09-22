import 'package:flutter/material.dart';

import 'feed_screen.dart';
import 'profile_screen.dart';

/*
class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}


class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {


  final List<Widget> pages = [
    Feed(
      key: PageStorageKey('Feed'),
    ),
    ProfilePage(
      key: PageStorageKey('Profile'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: bottomBarButton(),
      bottomNavigationBar: bottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }

  Widget bottomBarButton() {
    return FloatingActionButton(
      onPressed: () => _toUploadImage(),
      tooltip: 'Increment',
      backgroundColor : Color(0xFF974F4F),
      child: new Icon(Icons.add),
      elevation: 4.0,
    );
  }

  Widget bottomBar() {

    //TODO: bottom bar for whole page set
    return BottomAppBar(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: IconButton(icon: Icon(Icons.home, size: 28,), onPressed: () {},), ),
          Expanded(child: IconButton(icon: Icon(Icons.search, size: 28,), onPressed: () {},),),
          Expanded(child: new Text('')),
          Expanded(child: IconButton(icon: Icon(Icons.favorite_border, size: 28), onPressed: (){},),),
          Expanded(child: IconButton(icon: Icon(Icons.person, size: 28), onPressed: () => _toProfilePage(),),),
        ],
      ),
    );
  }
}

*/
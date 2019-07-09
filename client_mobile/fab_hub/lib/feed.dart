//Flutter lib import
import 'package:flutter/material.dart';

//Project files import
import 'post.dart';

//Temporary files import
import 'posts_test.dart';


class FeedState extends State<Feed> {

  final TextStyle logoStyle = TextStyle(fontSize: 25, fontFamily: 'Aclonica', color: Colors.white);

  List<Post> postItems;


  @override
  Widget build(BuildContext context) {
    //super.build(context);

    postItems = PostsShow.postItems;

    return new Scaffold(
      appBar:  AppBar(
        title:  Text(
          'FubHub',
          style: logoStyle,
        ),
        centerTitle: true,
      ),

      //NOTE! onRefresh should use another method
      //body: RefreshIndicator(child: buildFeed(), onRefresh: buildFeed()),

      body: buildFeed(),

      floatingActionButton: bottomBarButton(),
      bottomNavigationBar: bottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildFeed() {
    if (postItems != null) {
      return ListView(
        children: postItems,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  Widget bottomBarButton() {
    return FloatingActionButton(
      onPressed: () {},//pushAddTodoScreen,
      tooltip: 'Increment',
      backgroundColor : Color(0xFF974F4F),
      child: new Icon(Icons.add),
      elevation: 4.0,
    );
  }

  Widget bottomBar() {
    return BottomAppBar(
      child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: IconButton(icon: Icon(Icons.home, size: 28,), onPressed: () {},), ),
          Expanded(child: IconButton(icon: Icon(Icons.search, size: 28,), onPressed: () {},),),
          Expanded(child: new Text('')),
          Expanded(child: IconButton(icon: Icon(Icons.favorite_border, size: 28), onPressed: (){},),),
          Expanded(child: IconButton(icon: Icon(Icons.person, size: 28), onPressed: (){},),),
        ],
      ),
    );
  }
}

class Feed extends StatefulWidget {

  @override
  FeedState createState() => FeedState();
}
import 'package:flutter/material.dart';
import 'package:jchatapp/helper/authenticate.dart';
import 'package:jchatapp/helper/helperFunction.dart';
import 'package:jchatapp/views/chatScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getLogin().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jChatApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.purple,
        fontFamily: 'Montserrat',
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn ? Chatroom() : Authenticate()
          : Container(
              child: Center(
                child: Authenticate(),
              ),
            ),
    );
  }
}

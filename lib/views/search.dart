import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jchatapp/helper/constants.dart';
import 'package:jchatapp/services/database.dart';
import 'package:jchatapp/views/conversationScreen.dart';
import 'package:jchatapp/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchte = new TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.documents[index].data["name"],
                userEmail: searchSnapshot.documents[index].data["email"],
              );
            },
          )
        : Container();
  }

  initiateSearch() {
    databaseMethods.getUserByUserName(searchte.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoom({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {"users": users, "cid": chatRoomId};
      DatabaseMethods().createChatroom(chatRoomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId),
        ),
      );
    } else {
      print("You cannot send a message to yourself");
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName, style: simpleTextInput()),
              Text(userEmail, style: simpleTextInput()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoom(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message"),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black54,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchte,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search Username",
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 30,
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

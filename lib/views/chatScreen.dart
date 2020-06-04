import 'package:flutter/material.dart';
import 'package:jchatapp/helper/constants.dart';
import 'package:jchatapp/helper/helperFunction.dart';
import 'package:jchatapp/services/auth.dart';
import 'package:jchatapp/helper/authenticate.dart';
import 'package:jchatapp/views/conversationScreen.dart';
import 'package:jchatapp/views/search.dart';
import 'package:jchatapp/services/database.dart';
import 'package:jchatapp/widgets/widget.dart';

class Chatroom extends StatefulWidget {
  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  AuthenticationMethod authenticationMethod = new AuthenticationMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    snapshot.data.documents[index].data['cid']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    snapshot.data.documents[index].data["cid"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserName();
    databaseMethods.getChatrooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                authenticationMethod.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Authenticate(),
                  ),
                );
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.purple),
              child: Text("${userName.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              userName,
              style: simpleTextInput(),
            ),
          ],
        ),
      ),
    );
  }
}

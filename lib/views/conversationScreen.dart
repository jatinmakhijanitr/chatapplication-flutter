import 'package:flutter/material.dart';
import 'package:jchatapp/helper/constants.dart';
import 'package:jchatapp/services/database.dart';
import 'package:jchatapp/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messagete = new TextEditingController();

  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTiles(
                      snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sentby"] ==
                          Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messagete.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messagete.text,
        "sentby": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      databaseMethods.getConversationMessages(widget.chatRoomId, messageMap);
      messagete.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.addConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messagete,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Message", border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 30,
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTiles extends StatelessWidget {

  final String message;
  final bool isSendByMe;

  MessageTiles(this.message, this.isSendByMe);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.purple : Colors.black,
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: simpleTextInput(),
        ),
      ),
    );
  }
}

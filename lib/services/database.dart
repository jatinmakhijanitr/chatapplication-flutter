import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUserName(String userName) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: userName)
        .getDocuments();
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  createChatroom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("chatroom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("chatroom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("chatroom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatrooms(String userName) async {
    return await Firestore.instance
        .collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}

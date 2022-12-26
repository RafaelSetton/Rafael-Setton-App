import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/services/firebase/usersDB.dart';
import 'package:sql_treino/shared/models/chatModel.dart';
import 'package:sql_treino/shared/models/userModel.dart';

import '../../shared/models/messageModel.dart';

class ChatAppDB {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("chats");

  static Future postChat(ChatModel chat) async {
    debugPrint("ChatAppDB: Posting $chat");
    DocumentReference document = collection.doc(chat.id);
    if (!(await document.get()).exists) {
      for (String email in chat.users) {
        UserModel user = (await UserDB.show(email))!;
        user.data.chats.add(chat.id);
        await UserDB.post(user);
      }
    }
    await document.set(chat.toMap());
  }

  static Future<ChatModel> getChat(String id) async {
    debugPrint("ChatAppDB: Getting chat (id: $id)");
    return ChatModel.fromMap(
        (await collection.doc(id).get()).data() as Map<String, dynamic>);
  }

  static Future postMessage(String chatID, MessageModel message) async {
    debugPrint("ChatAppDB: Posting $message in chat (chatID: $chatID)");
    ChatModel chat = await getChat(chatID);
    chat.messages.add(message);
    await postChat(chat);
  }

  static listUserChats(String userEmail) async {
    debugPrint("ChatAppDB: Listing chats for user (email: $userEmail)");
    return (await UserDB.show(userEmail))!.data.chats;
  }

  static Future deleteChat(String chatID) async {
    debugPrint("ChatAppDB: Deleting chat (id: $chatID)");
    ChatModel chat = await getChat(chatID);
    await collection.doc(chatID).delete();
    for (String email in chat.users) {
      UserModel user = (await UserDB.show(email))!;
      user.data.chats.remove(chatID);
      await UserDB.post(user);
    }
  }
}

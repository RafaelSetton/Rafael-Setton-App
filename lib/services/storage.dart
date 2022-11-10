import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sql_treino/shared/models/chatModel.dart';
import 'package:sql_treino/shared/models/messageModel.dart';
import 'package:sql_treino/shared/models/score.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class DB {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("users");
}

class UserDB extends DB {
  static Future post(UserModel user, {bool create = false}) async {
    if (user.password.contains(RegExp(r"[^a-zA-Z0-9 .()!@#$%&]"))) {
      return "senha";
    } else if (create) {
      final check = await show(user.email);
      if (check != null) {
        return "e-mail";
      }
    }

    await DB.collection.doc(user.email).set(user.toMap());
  }

  static Future<List<String>> list() async {
    final response = await DB.collection.get();
    return response.docs.map((e) => e.id).toList();
  }

  static Future<UserModel?> show(String email) async {
    final document = await DB.collection.doc(email).get();
    return document.exists
        ? UserModel.fromMap(document.data() as Map<String, dynamic>)
        : null;
  }

  static Future delete(String email) async {
    await DB.collection.doc(email).delete();
  }
}

class WorkoutDB extends DB {
  static late String userEmail;

  static CollectionReference get collection =>
      DB.collection.doc(userEmail).collection("workouts");

  static Future post(String name, WorkoutModel data) async {
    final postData = Map.fromIterables(
        List<String>.generate(data.workouts.length, (i) => i.toString()),
        data.workouts.map((e) => e.toMap()));
    await collection.doc(name).set(postData);
  }

  static Future<List<String>> list() async {
    QuerySnapshot snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  static Future<WorkoutModel> show(String name) async {
    final LinkedHashMap data =
        (await collection.doc(name).get()).data() as LinkedHashMap;
    final workouts = data.values.map((e) => ExerciseModel.fromMap(e)).toList();
    return WorkoutModel(workouts: workouts);
  }

  static Future delete(String name) async {
    return await collection.doc(name).delete();
  }
}

class ChatAppDB {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("chats");

  static Future postChat(ChatModel chat) async {
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
    return ChatModel.fromMap(
        (await collection.doc(id).get()).data() as Map<String, dynamic>);
  }

  static Future postMessage(String chatID, MessageModel message) async {
    ChatModel chat = await getChat(chatID);
    chat.messages.add(message);
    await postChat(chat);
  }

  static listUserChats(String userEmail) async {
    return (await UserDB.show(userEmail))!.data.chats;
  }

  static Future deleteChat(String chatID) async {
    ChatModel chat = await getChat(chatID);
    await collection.doc(chatID).delete();
    for (String email in chat.users) {
      UserModel user = (await UserDB.show(email))!;
      user.data.chats.remove(chatID);
      await UserDB.post(user);
    }
  }
}
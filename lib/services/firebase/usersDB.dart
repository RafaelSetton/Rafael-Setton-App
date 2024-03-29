import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/shared/enums/registerErrors.dart';
import 'package:sql_treino/shared/models/userModel.dart';

class UserDB {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("users");

  static Future<RegisterErrors> post(UserModel user,
      {bool create = false}) async {
    debugPrint("UserDB: Posting $user");
    if (user.password.contains(RegExp(r"[^a-zA-Z0-9 .()!@#$%&]"))) {
      return RegisterErrors.invalidCharacter;
    } else if (create) {
      final check = await show(user.email);
      if (check != null) {
        return RegisterErrors.emailExists;
      }
    }

    await collection.doc(user.email).set(user.toMap());
    return RegisterErrors.none;
  }

  static Future<List<String>> list() async {
    debugPrint("UserDB: Listing all Users");
    final response = await collection.get();
    return response.docs.map((e) => e.id).toList();
  }

  static Future<UserModel?> show(String email) async {
    debugPrint("UserDB: Showing User (email: $email)");
    final document = await collection.doc(email).get();
    return document.exists
        ? UserModel.fromMap(document.data() as Map<String, dynamic>)
        : null;
  }

  static Future delete(String email) async {
    debugPrint("UserDB: Deleting User (email: $email)");
    await collection.doc(email).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sql_treino/shared/models/userModel.dart';

class UserDB {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection("users");

  static Future post(UserModel user, {bool create = false}) async {
    if (user.password.contains(RegExp(r"[^a-zA-Z0-9 .()!@#$%&]"))) {
      return "senha";
    } else if (create) {
      final check = await show(user.email);
      if (check != null) {
        return "e-mail";
      }
    }

    await collection.doc(user.email).set(user.toMap());
  }

  static Future<List<String>> list() async {
    final response = await collection.get();
    return response.docs.map((e) => e.id).toList();
  }

  static Future<UserModel?> show(String email) async {
    final document = await collection.doc(email).get();
    return UserModel.fromMap(document.data() as Map<String, dynamic>);
  }

  static Future delete(String email) async {
    await collection.doc(email).delete();
  }
}

class WorkoutDB {
  static late String userEmail;

  static CollectionReference get collection => FirebaseFirestore.instance
      .collection("users")
      .doc(userEmail)
      .collection("workouts");

  static Future post(String name, Map<String, int> data) async {
    // data: {"name1": int, "name2": int}
    await collection.doc(name).set(data);
  }

  static Future<List<String>> list() async {
    // ["name1", "name2", "name3"]
    final response = await collection.get();
    return response.docs.map((e) => e.id).toList();
  }

  static Future<Map<String, int>> show(String name) async {
    // {"name1": int, "name2": int}
    final response = await collection.doc(name).get();
    return Map<String, int>.from(response.data() as Map);
  }

  static Future delete(String name) async {
    await collection.doc(name).delete();
  }
}

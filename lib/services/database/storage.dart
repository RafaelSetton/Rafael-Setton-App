import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';
import 'package:sql_treino/shared/models/workoutSetModel.dart';

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
    return document.exists
        ? UserModel.fromMap(document.data() as Map<String, dynamic>)
        : null;
  }

  static Future delete(String email) async {
    await collection.doc(email).delete();
  }
}

class WorkoutDB {
  static late String userEmail;

  static Future<UserModel> get user async => (await UserDB.show(userEmail))!;

  static Future post(String name, List<WorkoutModel> data) async {
    UserModel? user = await UserDB.show(userEmail);
    if (user == null) return;
    user.data.workouts[name] = WorkoutSetModel(workouts: data);
    await UserDB.post(user);
  }

  static Future<List<String>> list() async {
    // ["name1", "name2", "name3"]
    return (await user).data.workouts.keys.toList();
  }

  static Future<List<WorkoutModel>> show(String name) async {
    final response = await UserDB.show(userEmail);
    return response!.data.workouts[name]!.workouts;
  }

  static Future delete(String name) async {
    final userData = await user;
    userData.data.workouts.remove(name);
  }
}

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class WorkoutDB {
  static late String userEmail;

  static CollectionReference get collection => FirebaseFirestore.instance
      .collection("users")
      .doc(userEmail)
      .collection("workouts");

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

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class WorkoutDB {
  static late String userEmail;

  static CollectionReference get collection => FirebaseFirestore.instance
      .collection("users")
      .doc(userEmail)
      .collection("workouts");

  static Future post(String name, WorkoutModel data) async {
    debugPrint("WorkoutDB: Posting workout $name $data");
    final postData = Map.fromIterables(
        List<String>.generate(data.workouts.length, (i) => i.toString()),
        data.workouts.map((e) => e.toMap()));
    await collection.doc(name).set(postData);
  }

  static Future<List<String>> list() async {
    debugPrint("WorkoutDB: Listing Workouts");
    QuerySnapshot snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  static Future<WorkoutModel> show(String name) async {
    debugPrint("WorkoutDB: Showing workout $name");
    final LinkedHashMap data =
        (await collection.doc(name).get()).data() as LinkedHashMap;
    final workouts = data.values.map((e) => ExerciseModel.fromMap(e)).toList();
    return WorkoutModel(workouts: workouts);
  }

  static Future delete(String name) async {
    debugPrint("WorkoutDB: Deleting workout $name");
    return await collection.doc(name).delete();
  }
}

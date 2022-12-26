import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/shared/models/ScoreModel.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class ScoresDB {
  static CollectionReference get collection => FirebaseFirestore.instance
      .collection("users")
      .doc(globals.userEmail)
      .collection("scores");

  static Future<List<ScoreModel>> get(String game) async {
    debugPrint("ScoresDB: Getting scores for $game");
    final doc = await collection.doc(game).get();
    final LinkedHashMap? data = doc.data() as LinkedHashMap?;

    if (data == null) return [];
    final List<ScoreModel> response = data.keys
        .map<ScoreModel>((k) => ScoreModel.fromMap(int.parse(k), data[k]))
        .toList();
    return response;
  }

  Future set(String game, ScoreModel newScore) async {
    debugPrint("ScoresDB: Setting new score for $game; $newScore");
    final doc = collection.doc(game);

    final data = newScore.toMap();

    if ((await doc.get()).exists) return doc.update(data);
    return doc.set(data);
  }
}

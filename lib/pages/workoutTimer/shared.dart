import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class Section {
  TextEditingController name;
  TextEditingController time;

  Key key;

  Section(this.name, this.time, this.key);

  Map<String, int> toMap() {
    String timeText = time.text != "" ? time.text : "1";

    return <String, int>{name.text: int.parse(timeText)};
  }

  List<String> toList() {
    return <String>[name.text, time.text];
  }

  int getTime() {
    return int.parse(time.text);
  }
}

Future<List<WorkoutModel>> readWorkout(String name) async {
  String? read = await RAM.read(name);
  if (read == null) return [];
  List<Map<String, dynamic>> maps =
      List<Map<String, dynamic>>.from(jsonDecode(read));
  return maps.map((e) => WorkoutModel.fromMap(e)).toList();
}

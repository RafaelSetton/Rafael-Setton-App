import 'package:flutter/material.dart';
import 'package:sql_treino/services/local/RAM.dart';

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

Future<List> loadRAM() async {
  RAM ram = await RAM().load();
  List workout = (await ram.readData())['currentWorkout'];
  if (workout == null) {
    workout = [];
  }
  return workout != null ? workout : [];
}

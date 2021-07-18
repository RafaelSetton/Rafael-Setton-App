import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class RAM {
  File file;

  RAM();

  Future<RAM> load() async {
    final directory = await getApplicationDocumentsDirectory();
    file = File(directory.path + "RAM.json");
    if (!(await file.exists())) {
      await file.create();
    }

    return this;
  }

  Future<Map> readData() async {
    String dataString = await file.readAsString();

    return dataString.isNotEmpty ? jsonDecode(dataString) : Map();
  }

  Future editData(String id, dynamic data) async {
    final previous = await readData();
    previous[id] = data;
    String dataString = jsonEncode(previous);
    await file.writeAsString(dataString);
  }

  Future deleteData(id) async {
    Map all = await readData();
    all.removeWhere((k, v) => k == id);
    file.writeAsString(jsonEncode(all));
  }
}

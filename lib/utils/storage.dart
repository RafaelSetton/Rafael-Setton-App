import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sql_treino/utils/functions.dart';

class Users {
  Users();

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File(directory.path + "users.json");
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

  Future<List> readData() async {
    File file = await getFile();

    String dataString = await file.readAsString();

    return jsonDecode(dataString);
  }

  Future addData(Map data) async {
    if (data['password'].contains(RegExp(r"[^a-zA-Z0-9 .()!@#$%&]"))) {
      return "senha";
    } else if (await readData().then((res) =>
        res.where((el) => el['email'] == data['email']).toList().length > 0)) {
      return "e-mail";
    } else {
      data['password'] = Cryptography.encrypt(data['password']);

      File file = await getFile();
      final previous = await readData();
      previous.add(data);
      String dataString = jsonEncode(previous);
      file.writeAsString(dataString);
    }
  }

  Future editData(Map data, {String identifierName = 'id'}) async {
    List all = await readData();
    all.removeWhere((e) => e[identifierName] == data[identifierName]);
    all.add(data);
    File file = await getFile();
    file.writeAsString(jsonEncode(all));
  }

  Future deleteData(identifier, {String identifierName = 'id'}) async {
    List all = await readData();
    all.removeWhere((e) => e[identifierName] == identifier);
    File file = await getFile();
    file.writeAsString(jsonEncode(all));
  }
}

class RAM {
  RAM();

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File(directory.path + "RAM.json");
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode(Map()));
    }
    return file;
  }

  Future<Map> readData() async {
    File file = await getFile();

    String dataString = await file.readAsString();

    return jsonDecode(dataString);
  }

  Future editData(String id, dynamic data) async {
    File file = await getFile();
    final previous = await readData();
    previous[id] = data;
    String dataString = jsonEncode(previous);
    file.writeAsString(dataString);
  }

  Future deleteData(id) async {
    File file = await getFile();
    Map all = await readData();
    all.removeWhere((k, v) => k == id);
    file.writeAsString(jsonEncode(all));
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sql_treino/utils/functions.dart';

class RAM {
  File file;

  RAM();

  Future<RAM> load() async {
    final directory = await getApplicationDocumentsDirectory();
    file = File(directory.path + "RAM.json");
    if (!(await file.exists())) {
      await file.create();
    }
    if ((await file.readAsString()) == "") {
      await file.writeAsString(jsonEncode(Map()));
    }
    return this;
  }

  Future<Map> readData() async {
    String dataString = await file.readAsString();

    return jsonDecode(dataString);
  }

  Future editData(String id, dynamic data) async {
    final previous = await readData();
    previous[id] = data;
    String dataString = jsonEncode(previous);
    file.writeAsString(dataString);
  }

  Future deleteData(id) async {
    Map all = await readData();
    all.removeWhere((k, v) => k == id);
    file.writeAsString(jsonEncode(all));
  }
}

class Database {
  Future post(Map data, {bool create = false}) async {
    if (data['password'].contains(RegExp(r"[^a-zA-Z0-9 .()!@#$%&]"))) {
      return "senha";
    } else if (create) {
      final user = await show(data['email']);
      if (user != null) {
        return "e-mail";
      }
    }
    data['password'] = Cryptography.encrypt(data['password']);
    await Firestore.instance
        .collection("users")
        .document(data['email'])
        .setData(data);
  }

  Future<List<Map>> list() async {
    // {birthday: str, data: {colorgamepts: int, todos: [{ok: bool, title: str}]}, email: str, name: str, password: str}
    final response =
        await Firestore.instance.collection("users").getDocuments();
    return response.documents.map((e) => e.data).toList();
  }

  Future<Map> show(String email) async {
    final all = await list();
    return all.where((user) => user['email'] == email).first;
  }

  Future delete(String email) async {
    Firestore.instance.collection("users").document(email).delete();
  }
}

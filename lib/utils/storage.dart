import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sql_treino/utils/functions.dart';
import 'package:http/http.dart' as http;

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

class Database {
  static const _baseUrl = "https://rafael-setton-project.firebaseio.com/";

  Future<String> create(Map data) async {
    if (data['password'].contains(RegExp(r"[^a-zA-Z0-9 .()!@#$%&]"))) {
      return "senha";
    } else if ((await show(data['email'])) != null) {
      return "e-mail";
    } else {
      data['password'] = Cryptography.encrypt(data['password']);
      final response =
          await http.post(_baseUrl + "users.json", body: jsonEncode(data));

      return jsonDecode(response.body)['name'];
    }
  }

  Future edit(Map data) async {
    String id = await _idFromEmail(data['email']);

    http.patch(_baseUrl + "users/$id.json", body: jsonEncode(data));
  }

  Future<List<Map>> list() async {
    final response = await http.get(_baseUrl + "users.json");

    final map = jsonDecode(response.body);
    if (map == null) {
      return [];
    }

    List list = <Map>[];
    map.forEach((k, v) {
      list.add(v);
    });
    return list;
  }

  Future<Map> show(String email) async {
    Map finalUser;
    (await list()).forEach((user) {
      if (user['email'] == email) {
        finalUser = user;
      }
    });

    return finalUser;
  }

  Future delete(String email) async {
    final key = _idFromEmail(email);

    http.delete(_baseUrl + "users/$key.json");
  }

  Future<String> _idFromEmail(String email) async {
    final response = await http.get(_baseUrl + "users.json");

    String key;
    final map = jsonDecode(response.body);
    map.forEach((k, v) {
      if (v['email'] == email) {
        key = k;
      }
    });

    return key;
  }
}

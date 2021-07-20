import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/services/local/RAM.dart';

Future loadVars() async {
  Firebase.initializeApp();
  RAM.prefs = await SharedPreferences.getInstance();
  WorkoutDB.userEmail = await RAM.read("user") ?? "";
}

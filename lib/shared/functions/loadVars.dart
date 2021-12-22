import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/models/argumentsModel.dart';

Future<ArgumentsModel> loadVars() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  RAM.prefs = await SharedPreferences.getInstance();
  WorkoutDB.userEmail = await RAM.read("user") ?? "";
  return ArgumentsModel(
      userEmail: WorkoutDB.userEmail, firebaseApp: firebaseApp);
}

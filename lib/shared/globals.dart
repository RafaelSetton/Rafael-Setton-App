import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_treino/services/RAM.dart';

late FirebaseApp firebaseApp;
late String userEmail;
Object? arguments;

Future loadVars() async {
  RAM.prefs = await SharedPreferences.getInstance();
  firebaseApp = await Firebase.initializeApp();
  userEmail = await RAM.read("user") ?? "";
}

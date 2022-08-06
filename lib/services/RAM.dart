import 'package:shared_preferences/shared_preferences.dart';

class RAM {
  static late SharedPreferences prefs;

  static Future<String?> read(String key) async {
    if (prefs.containsKey(key)) {
      return prefs.getString(key)!;
    }
    return null;
  }

  static Future write(String key, String? value) async {
    if (value == null)
      await prefs.remove(key);
    else
      await prefs.setString(key, value);
  }
}

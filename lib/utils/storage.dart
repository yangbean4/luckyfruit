import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<String> getItem(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }

  static setItem(String name, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(name, value);
  }
}

import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
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

  static clearAllCache() async {
    Storage.setItem(TreeGroup.CACHE_KEY, null);
    Storage.setItem(MoneyGroup.CACHE_KEY, null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    print("clearAllCache_start ${keys.toString()}");
    keys.map((value) {
      print("clearAllCache_value=$value");
      prefs.setString(value, null);
    });
  }
}

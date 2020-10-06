import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> readSharedPrefAsync({String key}) async {
  final prefs = await SharedPreferences.getInstance();
  dynamic value = prefs.get(key);
  return value;
}

Future<void> saveSharedPrefsAsync({String key, dynamic value}) async {
  final prefs = await SharedPreferences.getInstance();
  if (value is String) {
    prefs.setString(key, value);
  } else if (value is int) {
    prefs.setInt(key, value);
  } else if (value is double) {
    prefs.setDouble(key, value);
  } else if (value is bool) {
    prefs.setBool(key, value);
  }
}

Future<void> removeharedPrefAsync({String key}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

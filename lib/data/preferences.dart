import 'package:flutter/material.dart';
import 'package:app/utils/shared_pref_utils.dart';

// TODO: APIs in AppPreferences & AppTheme are messed up, need to decouple them

class AppPreferences with ChangeNotifier {
  static final AppPreferences _singleton = AppPreferences._internal();

  AppPreferences._internal() {
    print('AppPreferences: singleton instantiated.');
  }

  factory AppPreferences() => _singleton;

  static final String keyIsDarkTheme = "isDarkTheme";

  bool _isDarkTheme;

  bool get isDarkTheme => this._isDarkTheme;

  set isDarkTheme(bool value) {
    this._isDarkTheme = value;
    notifyListeners();
  }

  Future<void> setIsDarkTheme(bool value) async {
    await saveSharedPrefsAsync(key: keyIsDarkTheme, value: value);
    isDarkTheme = value;
  }

  Future<dynamic> loadAllPreferences() async {
    // isDarkTheme = await readSharedPrefAsync(key: keyIsDarkTheme) ?? false;
    dynamic sharedPref = await readSharedPrefAsync(key: keyIsDarkTheme);
    // print('shared pref isDarkTheme: $sharedPref');
    isDarkTheme = sharedPref ?? false;
  }
}

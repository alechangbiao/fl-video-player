import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  ThemeData _theme;

  static ThemeData light() {
    return ThemeData.light().copyWith(primaryColor: Colors.teal);
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(accentColor: Colors.orange, toggleableActiveColor: Colors.blue);
  }

  AppTheme(this._theme);

  ThemeData get theme => _theme;

  setTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }
}

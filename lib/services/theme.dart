import 'package:flutter/material.dart';

class AppThemeProvider with ChangeNotifier {
  ThemeData _theme;

  AppThemeProvider(this._theme);

  ThemeData get theme => _theme;

  setTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }
}

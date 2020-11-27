import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  ThemeData _theme;

  AppTheme(this._theme);

  static ThemeData light() {
    return ThemeData.light().copyWith(primaryColor: Colors.teal);
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.orange,
      accentColor: Colors.orange,
      toggleableActiveColor: Colors.orange,
      buttonColor: Colors.orange,
      textTheme: TextTheme(),
    );
  }

  ThemeData get theme => _theme;

  set theme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  /// This method **can not** be used at first time *AppTheme*
  /// class is instantiated during the entire life of the app.
  /// ---
  /// Especially **not** using it to create *ChangeNotifierProvider*
  void setLightTheme() => theme = light();

  /// This method **can not** be used at first time *AppTheme*
  /// class is instantiated during the entire life of the app.
  ///
  /// Especially **not** using it to create *ChangeNotifierProvider*
  void setDarkTheme() => theme = dark();

  /// This method **can not** be used at first time *AppTheme*
  /// class is instantiated during the entire life of the app.
  ///
  /// Especially **not** using it to create *ChangeNotifierProvider*
  void setTheme({@required String theme}) {
    switch (theme) {
      case 'light':
        setLightTheme();
        break;
      case 'dark':
        setDarkTheme();
        break;
      default:
        return;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';

class AppTheme with ChangeNotifier {
  ThemeData _theme;

  AppTheme(this._theme);

  static ThemeData light() {
    return ThemeData.light().copyWith(
      primaryColor: AppColors.iconBlueLight,
      primaryColorDark: AppColors.iconBlueDark,
      appBarTheme: AppBarTheme(color: AppColors.lightBlueGrey),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        backgroundColor: AppColors.iconBlueLight,
        contentTextStyle: TextStyle(color: Colors.white),
        actionTextColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.black26,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: AppColors.iconBlueLight,
      accentColor: AppColors.iconYellowDark,
      toggleableActiveColor: AppColors.iconBlueLight,
      buttonColor: AppColors.iconBlueLight,
      textTheme: TextTheme(
          // bodyText2: TextStyle(color: Colors.white),

          ),
      appBarTheme: AppBarTheme(
        color: Color(0xFF303030),
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        // textTheme: TextTheme(
        //   headline6: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        // ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        backgroundColor: AppColors.iconBlueLight,
        contentTextStyle: TextStyle(color: Colors.white),
        actionTextColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
      ),
    );
  }

  /// Get the current theme data.
  ThemeData get theme => _theme;

  /// Set theme data and notify listeners
  set theme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  /// This method **can not** be used at the first time *AppTheme* class is
  /// instantiated during the entire life of the app.
  /// ---
  /// Especially **not** using it to create *ChangeNotifierProvider*
  void setLightTheme() => theme = light();

  /// This method **can not** be used at the first time *AppTheme* class is
  /// instantiated during the entire life of the app.
  ///
  /// Especially **not** using it to create *ChangeNotifierProvider*
  void setDarkTheme() => theme = dark();

  /// This method **can not** be used at first time *AppTheme*
  /// class is instantiated during the entire life of the app.
  ///
  /// Especially **not** using it to create *ChangeNotifierProvider*
  void setTheme({required String theme}) {
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

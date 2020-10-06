import 'package:app/services/utils.dart';

class AppPreferences {
  // static final AppPreferences _singleton = AppPreferences._internal();
  // factory AppPreferences() => _singleton;
  // AppPreferences._internal();

  static final String isDarkTheme = "isDarkTheme";
  static final String isFollowSystemPreference = "isFollowSystemPreference";

  static Map<String, bool> theme = {
    isDarkTheme: true,
    isFollowSystemPreference: true,
  };

  Future<dynamic> loadAllPreferences() async {
    print(theme);
    theme[isDarkTheme] = await readSharedPrefAsync(key: isDarkTheme) ?? theme[isDarkTheme];
    theme[isFollowSystemPreference] =
        await readSharedPrefAsync(key: isFollowSystemPreference) ?? theme[isFollowSystemPreference];
  }
}

import 'package:flutter/material.dart';

class AppNavigation with ChangeNotifier {
  static final videosNavigatorKey = GlobalKey<NavigatorState>();
  static final resourcesNavigatorKey = GlobalKey<NavigatorState>();
  static final settingsNavigatorKey = GlobalKey<NavigatorState>();

  int _currentTabIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys;

  AppNavigation() {
    _navigatorKeys = [videosNavigatorKey, resourcesNavigatorKey, settingsNavigatorKey];
  }

  int get currentTabIndex => _currentTabIndex;

  List<GlobalKey<NavigatorState>> get navigatorKeys => _navigatorKeys;

  GlobalKey<NavigatorState> get currentNavigatorkey => _navigatorKeys[_currentTabIndex];

  void setTabIndex(newIndex) {
    if (_currentTabIndex != newIndex) {
      _currentTabIndex = newIndex;
    } else {
      // If re-selecting the tab, common behavior is to empty the stack.
      _navigatorKeys[_currentTabIndex].currentState.popUntil((route) => route.isFirst);
    }
    notifyListeners();
  }
}

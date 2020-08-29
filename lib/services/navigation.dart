import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  final _videosNavigatorKey = GlobalKey<NavigatorState>();
  final _resourcesNavigatorKey = GlobalKey<NavigatorState>();
  final _settringsNavigatorKey = GlobalKey<NavigatorState>();

  int _currentTabIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys;

  NavigationProvider() {
    _navigatorKeys = [_videosNavigatorKey, _resourcesNavigatorKey, _settringsNavigatorKey];
  }

  int get currentTabIndex => _currentTabIndex;

  List<GlobalKey<NavigatorState>> get navigatorKeys => _navigatorKeys;

  GlobalKey<NavigatorState> get currentNavigatorkey => _navigatorKeys[_currentTabIndex];

  void setTabIndex(newIndex) {
    if (_currentTabIndex != newIndex) {
      _currentTabIndex = newIndex;
    } else {
      // If the user is re-selecting the tab, the common behavior is to empty the stack.
      _navigatorKeys[_currentTabIndex].currentState.popUntil((route) => route.isFirst);
    }
    notifyListeners();
  }
}

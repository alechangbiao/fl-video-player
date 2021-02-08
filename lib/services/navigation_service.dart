import 'package:app/services/file_service.dart';
import 'package:flutter/material.dart';

class NavigationService with ChangeNotifier {
  static final kVideosStack = GlobalKey<NavigatorState>();
  static final kAddStack = GlobalKey<NavigatorState>();
  static final kSettingStack = GlobalKey<NavigatorState>();

  static final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    kVideosStack,
    kAddStack,
    kSettingStack,
  ];

  static int _currentTabIndex = 0;

  static GlobalKey<NavigatorState> get currentStack {
    return _navigatorKeys[_currentTabIndex];
  }

  static NavigatorState? get currentStackState {
    return currentStack.currentState;
  }

  /// Stored path variable for stacks
  ///
  /// This variable is useful when switching currentPath and tabIndex is changed
  static List<String> _stacksPaths = ['', ''];

  /// Get the stored path for the current stack
  static String get currentStackPath {
    return _stacksPaths[_currentTabIndex];
  }

  /// Set & stored path for the current stack
  static set currentStackPath(String path) {
    _stacksPaths[_currentTabIndex] = path;
  }

  /// Navigate to a named route
  static Future<dynamic> navigateTo(String routeName, {Object? arguments, String? path}) {
    path != null ? currentStackPath = path : currentStackPath = '';
    return currentStackState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  List<GlobalKey<NavigatorState>> get navigatorKeys => _navigatorKeys;

  GlobalKey<NavigatorState> get currentNavigatorkey => _navigatorKeys[_currentTabIndex];

  int get currentTabIndex => _currentTabIndex;

  /// When change between tabs, change current path as well
  set tabIndex(int newIndex) {
    final int prevIndex = _currentTabIndex;
    _currentTabIndex != newIndex
        ? _currentTabIndex = newIndex
        : currentStack.currentState!.popUntil((route) => route.isFirst);
    // detect switching between videos & folder stack
    if (prevIndex == 0 && newIndex == 1 || prevIndex == 1 && newIndex == 0) {
      print('NavigationService: switching between videos and folder stack detected...');
      if (currentStackPath.isNotEmpty) FileService().currentPath = currentStackPath;
    }
    notifyListeners();
  }

  // navigate and wait for pop action:
  // https://flutter.dev/docs/cookbook/navigation/returning-data#5-show-a-snackbar-on-the-home-screen-with-the-selection
}

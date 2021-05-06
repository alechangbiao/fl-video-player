import 'package:flutter/material.dart';

class AppColors {
  static const iconBlueLight = Color(0xFF366796);
  static const iconBlueDark = Color(0xFF273B7A);
  static const iconYellowLight = Color(0xFFFDE085);
  static const iconYellowDark = Color(0xFFFFC91B);

  static const lightBlueGrey = Color(0xFF8A9CA5);
}

class AppLayout {
  static const double screenEdgeMargin = 20;
  static const double appBarActionMargin = 10;
}

class SortingModeKey {
  static const String asList = "As List";
  static const String asIcons = "As Icons";
  static const String asCovers = "As Covers";

  static const String name = "Name";
  static const String dateAdded = "Date Added";
  static const String lastWatched = "Last Watched";
}

const List<String> SupportedVideoTypes = <String>['mp4', 'avi', 'mov', 'm4v', '3gp'];

import 'package:flutter/material.dart';

export 'package:app/models/sorting_mode.dart' show LayoutSorterKey, SequenceSorterKey;
export 'package:app/models/folder_info.dart' show FolderInfoKey;
export 'package:app/models/video_info.dart' show VideoInfoKey;
export 'package:app/models/trash_info.dart' show TrashInfoKey;

export 'package:app/utils/folder_icon.dart' show IconNames;

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

const List<String> SupportedVideoTypes = <String>['mp4', 'avi', 'mov', 'm4v', '3gp'];

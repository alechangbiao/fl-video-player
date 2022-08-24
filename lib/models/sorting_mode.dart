import 'package:flutter/material.dart';

enum SorterType { layout, sequence }

extension SorterTypeExtension on SorterType {
  static const names = {
    SorterType.layout: 'layout',
    SorterType.sequence: 'sequence',
  };

  String get name => names[this]!;
}

class SortingMode {
  final String name;
  final IconData iconData;

  SortingMode(this.name, this.iconData);

  static List<SortingMode> layout = [
    SortingMode(LayoutSorterKey.asList, Icons.view_list_rounded),
    SortingMode(LayoutSorterKey.asCovers, Icons.view_stream_rounded),
    SortingMode(LayoutSorterKey.asCovers, Icons.view_column_rounded),
    SortingMode(LayoutSorterKey.asIcons, Icons.view_module_rounded),
  ];

  static List<SortingMode> sequence = [
    SortingMode(SequenceSorterKey.name, Icons.sort_by_alpha),
    SortingMode(SequenceSorterKey.dateAdded, Icons.library_add),
    SortingMode(SequenceSorterKey.lastWatched, Icons.watch_later),
  ];

  static List<SortingMode> getModeList({required SorterType type}) {
    if (type == SorterType.sequence) return SortingMode.sequence;
    if (type == SorterType.layout) return SortingMode.layout;
    return [];
  }
}

class LayoutSorterKey {
  static const String asList = "As List";
  static const String asIcons = "As Icons";
  static const String asCovers = "As Covers";
}

class SequenceSorterKey {
  static const String name = "Name";
  static const String dateAdded = "Date Added";
  static const String lastWatched = "Last Watched";
}

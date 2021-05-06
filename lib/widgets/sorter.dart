import 'package:app/models/folder_info.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:provider/provider.dart';

class SortingMode {
  final String name;
  final IconData iconData;

  SortingMode(this.name, this.iconData);
}

List<SortingMode> _layoutModes = [
  SortingMode(SortingModeKey.asList, Icons.view_list_rounded),
  SortingMode(SortingModeKey.asCovers, Icons.view_stream_rounded),
  SortingMode(SortingModeKey.asCovers, Icons.view_column_rounded),
  SortingMode(SortingModeKey.asIcons, Icons.view_module_rounded),
];

List<SortingMode> _sequenceModes = [
  SortingMode(SortingModeKey.name, Icons.sort_by_alpha),
  SortingMode(SortingModeKey.dateAdded, Icons.library_add),
  SortingMode(SortingModeKey.lastWatched, Icons.watch_later),
];

enum SorterType { layout, sequence }

class Sorter extends StatefulWidget {
  final SorterType sorterType;
  final bool isRootPath;

  const Sorter({Key? key, required this.sorterType, this.isRootPath = false}) : super(key: key);

  @override
  _SorterState createState() {
    if (this.sorterType == SorterType.sequence) return _SorterState(sortingModes: _sequenceModes);
    if (this.sorterType == SorterType.layout) return _SorterState(sortingModes: _layoutModes);
    return _SorterState(sortingModes: []);
  }
}

class _SorterState extends State<Sorter> {
  final List<SortingMode> sortingModes;

  _SorterState({required this.sortingModes});

  late int _currentMode;

  bool _hasSetinitialMode = false;

  Future<void> _selectRow(int row, {@required FileService? fsProvider}) async {
    if (row == _currentMode) return;
    // update sorter UI
    setState(() {
      _currentMode = row;
    });
    // update .info file
    String nameOfSortingMode = this.sortingModes[row].name;
    if (widget.sorterType == SorterType.layout) {
      widget.isRootPath
          ? fsProvider!.updateRootPathFolderInfoFile(layout: nameOfSortingMode)
          : fsProvider!.updateCurrentPathFolderInfoFile(layout: nameOfSortingMode);
    }
    if (widget.sorterType == SorterType.sequence) {
      widget.isRootPath
          ? fsProvider!.updateRootPathFolderInfoFile(sequence: nameOfSortingMode)
          : fsProvider!.updateCurrentPathFolderInfoFile(sequence: nameOfSortingMode);
    }
  }

  void setInitialMode({required FileService fsProvider}) {
    if (_hasSetinitialMode == true) return;
    FolderInfo info =
        widget.isRootPath ? fsProvider.rootPathFolerInfo! : fsProvider.currentPathFolerInfo!;
    if (widget.sorterType == SorterType.layout) {
      if (info.layout == null) {
        _currentMode = 0;
      } else {
        SortingMode mode = sortingModes.firstWhere((mode) => mode.name == info.layout);
        _currentMode = sortingModes.indexOf(mode);
      }
    }
    if (widget.sorterType == SorterType.sequence) {
      if (info.layout == null) {
        _currentMode = 0;
      } else {
        SortingMode mode = sortingModes.firstWhere((mode) => mode.name == info.sequence);
        _currentMode = sortingModes.indexOf(mode);
      }
    }
    _hasSetinitialMode = true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building Sorter, ${widget.sorterType}");
    FileService _fsProvider = Provider.of<FileService>(context);
    setInitialMode(fsProvider: _fsProvider);

    return PopupMenuButton(
      offset: Offset(0, 30),
      onSelected: (int row) async => this._selectRow(row, fsProvider: _fsProvider),
      child: Row(
        children: [
          Icon(this.sortingModes[_currentMode].iconData),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
      itemBuilder: (BuildContext context) {
        return sortingModes
            .asMap()
            .entries
            .map(
              (entry) => PopupMenuItem(
                value: entry.key,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(entry.value.iconData),
                    Text(entry.value.name),
                  ],
                ),
              ),
            )
            .toList();
      },
    );
  }
}

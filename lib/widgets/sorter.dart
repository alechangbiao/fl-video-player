import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/folder_info.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/models/sorting_mode.dart';

export 'package:app/models/sorting_mode.dart' show SorterType;

class Sorter extends StatefulWidget {
  /// Type of the sorter, for sorthing layout or sequence
  final SorterType type;
  final bool isRootPath;

  const Sorter({Key? key, required this.type, this.isRootPath = false}) : super(key: key);

  @override
  _SorterState createState() => _SorterState(modes: SortingMode.getModeList(type: type));
}

class _SorterState extends State<Sorter> {
  final List<SortingMode> modes;

  _SorterState({required this.modes});

  late int _currentMode;
  bool _hasSetInitialMode = false;

  Future<void> _selectRow(int row, {@required FileService? fsProvider}) async {
    if (row == _currentMode) return;
    // update sorter UI
    setState(() {
      _currentMode = row;
    });
    // update .info file
    String mode = this.modes[row].name;
    widget.isRootPath
        ? fsProvider!.updateRootPathFolderInfoFile(updates: {widget.type.name: mode})
        : fsProvider!.updateCurrentPathFolderInfoFile(updates: {widget.type.name: mode});
  }

  void _setInitialMode({required FileService fsProvider}) {
    if (_hasSetInitialMode == true) return;
    FolderInfo info = fsProvider.selectFolderInfo(isRootPath: widget.isRootPath)!;
    if (info.getValue(key: widget.type.name) == null) {
      _currentMode = 0;
    } else {
      SortingMode mode = modes.firstWhere((mode) {
        return mode.name == info.getValue(key: widget.type.name);
      });
      _currentMode = modes.indexOf(mode);
    }
    _hasSetInitialMode = true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building Sorter, ${widget.type}");
    FileService _fsProvider = Provider.of<FileService>(context);
    _setInitialMode(fsProvider: _fsProvider);

    return PopupMenuButton(
      offset: Offset(0, 30),
      onSelected: (int row) async => this._selectRow(row, fsProvider: _fsProvider),
      child: Row(
        children: [
          Icon(this.modes[_currentMode].iconData),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
      itemBuilder: (BuildContext context) {
        return modes
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

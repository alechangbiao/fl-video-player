import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/models/folder_info.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/screens/folder/folder_screen.dart';
import 'package:app/utils/folder_icon.dart';

enum FolderListItemType {
  TrashFolder,
  DefaultPrivateFolder,
}

class FolderListItem extends StatefulWidget {
  final String path;
  final String name;
  final IconData? icon;
  final Function? onTap;
  final FolderListItemType? itemType;

  /// Construct a [StatefulWidget] to show in the [SliverAppBar]
  ///
  ///     String path, name;  // initial path & name
  ///     IconData icon;  // initial icon to show
  FolderListItem({
    required this.name,
    required this.path,
    this.icon,
    this.onTap,
    this.itemType,
  }) : super(key: Key(name));

  @override
  _FolderListItemState createState() => _FolderListItemState();
}

class _FolderListItemState extends State<FolderListItem> {
  String? path;
  FolderInfo? folderInfo;
  String? name;
  IconData? icon;

  @override
  void initState() {
    super.initState();
    this.path = widget.path;
    this.name = widget.name;
    _initFolderInfo(path: this.path);
  }

  Future<void> _initFolderInfo({@required String? path}) async {
    if (widget.icon == null) {
      this.folderInfo = await FileService().getFolderInfo(path: path);
      this.icon = FolderIcons.name(this.folderInfo!.iconName);
    } else {
      this.icon = widget.icon;
    }
    setState(() {});
  }

  /// When name changes, `this.path` needs to be updated as well.
  Future<void> _changeName({required String newName}) async {
    String newPath = '${this.path!.parentPath}/$newName';
    FileService _fsProvider = Provider.of<FileService>(context, listen: false);
    await _fsProvider.renameFolder(folder: Directory(this.path!), newName: newName);
    FolderInfo? newInfo = await _fsProvider.getFolderInfo(path: newPath);
    setState(() {
      this.name = newName;
      this.path = newPath;
      this.folderInfo = newInfo;
    });
  }

  /// When path changes, `this.name` needs to be updated as well.
  Future<void> _moveToTrash() async {
    print('_moveToTrash called');
    FileService _fsProvider = Provider.of<FileService>(context, listen: false);
    print(widget.path);
    await _fsProvider.moveFolderToTrash(folderPath: widget.path);
    await _fsProvider.reloadRootPathFoldersList();
    print('_moveToTrash called complete');
  }

  void _onTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      String? _currentPath = FileService.getCurrentPathStatic;
      await NavigationService.currentStackState?.push(
        MaterialPageRoute(
          builder: (context) => FolderScreen(path: this.path!),
        ),
      );
      FileService.currentPathStatic = _currentPath; // set _currentPath back

      // NavigationService.navigateTo(
      //   '/folder',
      //   arguments: FolderScreenArguments(path: this.path),
      //   path: this.path,
      // );
    }
  }

  /// Pop up a bottom modal for actions
  void _onLongPress() {
    if (this.path!.baseName == '.Private' || this.path!.baseName == '.Trash') return;
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          // color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Change Name'),
                onPressed: () async {
                  //TODO: Complete the UX flow
                  await this._changeName(newName: '${this.name}1');
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Move to Trash'),
                onPressed: () async {
                  await _moveToTrash();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTrashFolderItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: _onTap,
        onLongPress: () {},
        child: Column(
          children: [
            Icon(
              Icons.delete_outline,
              size: 60,
            ),
            SizedBox(
              child: Text(
                "Trash",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemType == FolderListItemType.TrashFolder) {
      return buildTrashFolderItem();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: _onTap,
        onLongPress: _onLongPress,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(
                  Icons.folder,
                  size: 60,
                  color: Colors.amber.withOpacity(0.8),
                ),
                if (icon != null) Icon(icon, size: 24, color: Colors.white70),
              ],
            ),
            SizedBox(
              width: 60,
              child: Text(
                this.name!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

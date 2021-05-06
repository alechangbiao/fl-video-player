import 'package:app/services/file_service/file_service.dart';
import 'package:flutter/material.dart';

import 'package:app/models/folder_info.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/folder/folder_screen.dart';
import 'package:app/utils/folder_icon.dart';

class FolderListItem extends StatefulWidget {
  final String? path;
  final String name;
  final IconData? icon;
  final Function? onTap;

  /// Construct a [StatefulWidget] to show in the [SliverAppBar]
  ///
  ///     String path, name;  // initial path & name
  ///     IconData icon;  // initial icon to show
  FolderListItem({
    required this.name,
    this.path,
    this.icon,
    this.onTap,
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
    this.icon = widget.icon;
    _getFolderInfo(path: this.path);
  }

  Future<void> _getFolderInfo({@required String? path}) async {
    this.folderInfo = await FileService().getFolderInfo(path: path);
    setState(() {
      // this.name = this.folderInfo.name;
      // this.icon = this.folderInfo.iconName.getIcon;
      this.icon = FolderIcons.name(this.folderInfo!.iconName);
    });
  }

  /// When name changes, `this.path` needs to be updated as well.
  void _changeName({required String newName}) async {
    setState(() => this.name = newName);
    //TODO: update current path
  }

  /// When path changes, `this.name` needs to be updated as well.
  void _changePath(String newPath) {}

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

  void _onLongPress() {
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          // color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Change Name'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Move Folder'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

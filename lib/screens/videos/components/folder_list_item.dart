import 'package:app/services/file_service.dart';
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
  void _changeName({required String newName}) {
    setState(() => this.name = newName);
    //TODO: update current path
  }

  /// When path changes, `this.name` needs to be updated as well.
  void _changePath(String newPath) {}

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      NavigationService.currentStackState?.push(
        MaterialPageRoute(
          builder: (context) => FolderScreen(path: this.path!),
          // builder: (context) => Scaffold(),
        ),
      );
      // NavigationService.navigateTo(
      //   '/folder',
      //   arguments: FolderScreenArguments(path: this.path),
      //   path: this.path,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: _onTap,
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

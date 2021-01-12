import 'package:flutter/material.dart';
import 'package:app/screens/select_icon/select_icon_screen.dart';
import 'package:app/screens/folder/components/rename_folder_dialog.dart';

/// A **method** to build a material design app bar.
///
///     buildAppBar();
///
/// When building appBar with it, execute this method as a function
AppBar buildAppBar(BuildContext context) {
  void _popMenuButtonOnSelected(value) {
    switch (value) {
      case 0:
        showDialog(
          context: context,
          builder: (context) => RenameFolderDialog(),
        );
        break;
      case 1:
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => SelectIconScreen(),
            fullscreenDialog: true,
          ),
        );
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  return AppBar(
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.folder, color: Colors.white70),
        SizedBox(width: 10),
        Text("Folder"),
      ],
    ),
    actions: [
      PopupMenuButton(
        offset: Offset(0, 32),
        onSelected: _popMenuButtonOnSelected,
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 0,
              child: Text('Rename Folder'),
            ),
            PopupMenuItem(
              value: 1,
              child: Text('Set Folder Icon'),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Text('Private'),
                  Spacer(),
                  Switch(
                    onChanged: (bool value) {},
                    value: false,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              enabled: false,
              value: 3,
              child: Text('Add Folder'),
            ),
          ];
        },
      ),
    ],
  );
}

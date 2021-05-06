import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/screens/videos/components/folder_list_item.dart';

class FolderList extends StatelessWidget {
  const FolderList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('Building FolderList Component...');
    FileService _fsProvider = Provider.of<FileService>(context);

    Widget addFolder() {
      return FolderListItem(
        name: 'Add Folder',
        icon: Icons.add,
        onTap: () async {
          await _fsProvider.createDirectory(name: null);
          _fsProvider.updateRootPathFoldersList();
        },
      );
    }

    // Widget buildInitialView(BuildContext context) {
    //   return SizedBox(
    //     height: 80,
    //     child: ListView(
    //       scrollDirection: Axis.horizontal,
    //       children: <Widget>[
    //         FolderListItem(name: 'Private', icon: Icons.lock),
    //         addFolder(),
    //       ],
    //     ),
    //   );
    // }

    Widget buildView(BuildContext context) {
      return SizedBox(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            FolderListItem(
              name: 'Private',
              icon: Icons.lock,
            ),
            for (Directory dir in _fsProvider.rootPathFolders)
              FolderListItem(
                name: dir.baseName,
                path: dir.path,
              ),
            addFolder(),
          ],
        ),
      );
    }

    return buildView(context);

    // if (_fsProvider.rootPathFolders.isEmpty) {
    //   _fsProvider.updateRootPathFoldersList();
    //   return buildInitialView(context);
    // } else {
    //   return buildView(context);
    // }
  }
}

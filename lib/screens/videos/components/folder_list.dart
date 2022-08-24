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
    FileService _fsProvider = Provider.of<FileService>(context);

    Widget buildAddFolderButton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: InkWell(
          onTap: () async {
            await _fsProvider.createFolder(name: null);
            _fsProvider.updateRootPathFoldersList();
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Icon(Icons.add, size: 42),
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  "Add Folder",
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

    // Hide .Private & .Trash folders
    List<Directory> _folders = _fsProvider.rootPathFolders
        .where((Directory d) => d.baseName != ".Private" && d.baseName != ".Trash")
        .toList();

    // TODO: Render .Private & .Trash folders repectively
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          FolderListItem(
            name: 'Private',
            path: _fsProvider.defaultPrivateFolderPath,
            icon: Icons.lock,
          ),
          for (Directory folder in _folders)
            FolderListItem(
              name: folder.baseName,
              path: folder.path,
            ),
          FolderListItem(
            name: 'Trash',
            path: _fsProvider.trashFolderPath,
            itemType: FolderListItemType.TrashFolder,
          ),
          buildAddFolderButton(),
        ],
      ),
    );
  }
}

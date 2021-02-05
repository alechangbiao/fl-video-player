import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/utils/folder_icon.dart';
import 'package:app/utils/constants.dart';
import 'package:app/services/file_service.dart';

class SelectIconScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FileService _fsProvider = Provider.of<FileService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Icon'),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppLayout.screenEdgeMargin),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: FolderIcons.allIcons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 3 : 6,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1 / 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    FolderIcon folderIcon = FolderIcons.allIcons[index];
                    return InkWell(
                        onTap: () async {
                          print(folderIcon.name);

                          await _fsProvider.updateCurrentPathFolderInfoFile(
                            iconName: folderIcon.name,
                          );
                          // print(await info.readAsString());
                          await _fsProvider.reloadRootPathFoldersList();

                          Navigator.of(context).pop();
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueGrey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            folderIcon.icon,
                            // color: AppColors.yellowDark,
                            size: 34,
                          ),
                        ));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

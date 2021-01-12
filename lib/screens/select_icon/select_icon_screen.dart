import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/folder_icon.dart';

class SelectIconScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                        onTap: () => print(folderIcon.name),
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

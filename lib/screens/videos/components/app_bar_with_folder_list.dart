import 'package:app/screens/search/search_screen.dart';
import 'package:app/screens/videos/components/folder_list.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class AppBarWithFolderList extends StatelessWidget {
  final bool showFolders;

  const AppBarWithFolderList({
    Key? key,
    this.showFolders = true,
  }) : super(key: key);

  static AppBar staticAppBar(BuildContext context) {
    return AppBar(
      elevation: 5,
      title: Image.asset(
        'assets/images/logo-banner.png',
        height: 40,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, size: 28),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
        ),
        SizedBox(width: AppLayout.appBarActionMargin),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: showFolders ? 140 : 0,
      // toolbarHeight: 45,
      centerTitle: false,
      elevation: 5,
      title: Image.asset(
        'assets/images/logo-banner.png',
        height: 40,
      ),
      flexibleSpace: showFolders
          ? FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FolderList(),
                  SizedBox(height: AppLayout.appBarActionMargin),
                ],
              ),
            )
          : null,
      actions: [
        IconButton(
          icon: Icon(Icons.search, size: 28),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
          // onPressed: () => Navigator.of(context, rootNavigator: true).push(
          //   MaterialPageRoute(
          //     builder: (context) => SearchScreen(),
          //     fullscreenDialog: true,
          //   ),
          // ),
        ),
        SizedBox(width: AppLayout.appBarActionMargin),
      ],
    );
  }
}

import 'package:app/screens/search/search_screen.dart';
import 'package:app/screens/videos/components/folder_list.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class AppBarWithFolderList extends StatelessWidget {
  const AppBarWithFolderList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 140,
      // toolbarHeight: 45,
      centerTitle: false,
      elevation: 5,
      title: Image.asset(
        'assets/images/logo-banner.png',
        height: 40,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FolderList(),
            SizedBox(height: AppLayout.appBarActionMargin),
          ],
        ),
      ),
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

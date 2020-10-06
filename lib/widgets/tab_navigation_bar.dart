import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/navigation.dart';

class TabNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppNavigation _nav = Provider.of<AppNavigation>(context);

    return BottomNavigationBar(
      currentIndex: _nav.currentTabIndex,
      onTap: _nav.setTabIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'Videos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Resources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

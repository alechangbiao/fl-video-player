import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/navigation_service.dart';

class TabNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationService _nav = Provider.of<NavigationService>(context);

    return BottomNavigationBar(
      currentIndex: _nav.currentTabIndex,
      onTap: (index) => _nav.tabIndex = index,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'videos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'resources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'settings',
        ),
      ],
    );
  }
}

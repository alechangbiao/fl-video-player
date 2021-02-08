import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/navigation_service.dart';

class AppBottomNavigationBar extends StatelessWidget {
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
          icon: Icon(Icons.add_circle_outline),
          label: 'add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'setting',
        ),
      ],
    );
  }
}

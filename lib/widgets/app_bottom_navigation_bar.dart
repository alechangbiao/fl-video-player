import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/navigation_service.dart';

class AppBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationService _nav = Provider.of<NavigationService>(context);

    return BottomNavigationBar(
      currentIndex: _nav.currentTabIndex,
      onTap: (index) {
        if (index == 1) {
          showAddNewModal(context, navProvider: _nav);
        } else {
          _nav.tabIndex = index;
        }
      },
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

void showAddNewModal(BuildContext context, {NavigationService? navProvider}) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        // color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 32,
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  child: IconButton(
                    icon: Icon(Icons.computer),
                    onPressed: () {
                      Navigator.pop(context);
                      navProvider?.tabIndex = 1;
                    },
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
            SizedBox(width: 15),
            CircleAvatar(
              radius: 32,
              child: IconButton(
                icon: Icon(Icons.create_new_folder),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}

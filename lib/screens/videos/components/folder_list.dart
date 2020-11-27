import 'package:flutter/material.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/folder/folder_screen.dart';

class FolderList extends StatelessWidget {
  const FolderList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                onTap: () {
                  NavigationService.currentStackState.push(
                    MaterialPageRoute(
                      builder: (context) => FolderScreen(),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(Icons.folder, size: 80, color: Colors.amber.withOpacity(0.8)),
                    Icon(Icons.lock, size: 24, color: Colors.white70)
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.folder, size: 80, color: Colors.amber.withOpacity(0.8)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.folder, size: 80, color: Colors.amber.withOpacity(0.8)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(Icons.folder, size: 80, color: Colors.amber.withOpacity(0.8)),
                  Icon(Icons.add, size: 24, color: Colors.white70)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

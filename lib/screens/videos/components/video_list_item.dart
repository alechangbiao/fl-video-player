import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:app/screens/player/player_screen.dart';

class VideoListItem extends StatelessWidget {
  const VideoListItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: Container(
            child: ListTile(
              // tileColor: Colors.white38,
              onTap: () {
                // showGeneralDialog(
                //   barrierLabel: "Label",
                //   barrierDismissible: false,
                //   barrierColor: Colors.black.withOpacity(0.5),
                //   transitionDuration: Duration(milliseconds: 200),
                //   context: context,
                //   pageBuilder: (context, anim1, anim2) => PlayerScreen(),
                //   transitionBuilder: (context, anim1, anim2, child) {
                //     return SlideTransition(
                //       position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                //       child: child,
                //     );
                //   },
                // );

                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Text('3'),
                foregroundColor: Colors.white,
              ),
              title: Text('Tile n°3'),
              subtitle: Text('SlidableDrawerDelegate'),
            ),
          ),
        ),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Archive',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () => print('Archive'),
          ),
          IconSlideAction(
            caption: 'Share',
            color: Colors.indigo,
            icon: Icons.share,
            onTap: () => print('Share'),
          ),
        ],
        secondaryActions: <Widget>[
          ClipRRect(
            borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
            child: IconSlideAction(
              caption: 'More',
              color: Colors.black45,
              icon: Icons.more_horiz,
              onTap: () => print('More'),
            ),
          ),
          ClipRRect(
            borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => print('Delete'),
            ),
          ),
        ],
      ),
    );
  }
}

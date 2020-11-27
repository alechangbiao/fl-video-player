import 'package:app/screens/videos/components/video_list_item.dart';
import 'package:flutter/material.dart';

class VideoList extends StatelessWidget {
  const VideoList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
          VideoListItem(),
        ],
      ),
    );
  }
}

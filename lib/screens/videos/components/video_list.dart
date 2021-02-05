import 'package:app/screens/videos/components/video_list_item.dart';
import 'package:flutter/material.dart';

List<Widget> _itemList = <Widget>[
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
];

class VideoList extends StatelessWidget {
  const VideoList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      // Use a delegate to build items as they're scrolled on screen.
      delegate: SliverChildBuilderDelegate(
        (context, index) => _itemList[index],
        childCount: _itemList.length,
      ),
    );

    // return Expanded(
    //   child: ListView(
    //     children: _itemList,
    //   ),
    // );
  }
}

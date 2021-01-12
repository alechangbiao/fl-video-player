import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thumbnail Test')),
      floatingActionButton: FABs(),
      body: Column(
        children: <Widget>[
          ThumbnailImage(),
        ],
      ),
    );
  }
}

class ThumbnailImage extends StatefulWidget {
  @override
  _ThumbnailImageState createState() => _ThumbnailImageState();
}

class _ThumbnailImageState extends State<ThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FABs extends StatelessWidget {
  const FABs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GenThumbnailDataButton(),
        SizedBox(width: 10),
        GenThumbnailFileButton(),
      ],
    );
  }
}

class GenThumbnailFileButton extends StatelessWidget {
  const GenThumbnailFileButton({
    Key key,
  }) : super(key: key);

  // Generate a thumbnail in memory from video file
  Future<Uint8List> genThumbnailData(File videofile) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videofile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Generate a file of thumbnail",
      onPressed: () {},
      child: const Text("File"),
    );
  }
}

class GenThumbnailDataButton extends StatelessWidget {
  const GenThumbnailDataButton({
    Key key,
  }) : super(key: key);

  // Generate a thumbnail file from video URL
  Future<String> genThumbnailFile() async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Generate a data of thumbnail",
      onPressed: () {},
      child: const Text("Data"),
    );
  }
}

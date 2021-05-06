import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:app/screens/player/player_screen_stf.dart';
import 'package:app/widgets/generate_thumbnail_image.dart';
import 'package:app/services/file_service/file_service.dart';

class VideoItemCover extends StatefulWidget {
  final String videoPath;

  const VideoItemCover({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoItemCoverState createState() => _VideoItemCoverState();
}

class _VideoItemCoverState extends State<VideoItemCover> {
  late GenerateThumbnailImage? _futreImage;

  int _quality = 10;
  int _sizeH = 0;
  int _sizeW = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _futreImage = GenerateThumbnailImage(
        thumbnailRequest: ThumbnailRequest(
            video: widget.videoPath,
            thumbnailPath: null,
            imageFormat: ImageFormat.JPEG,
            maxHeight: _sizeH,
            maxWidth: _sizeW,
            timeMs: 200000,
            quality: _quality),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: Colors.grey,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: (_futreImage == null)
                  ? SizedBox()
                  : Column(
                      children: [
                        InkWell(
                          child: _futreImage!,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return PlayerScreen(videoFile: widget.videoPath.getFile);
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                        Container(
                          height: 40.0,
                          child: Row(
                            children: <Widget>[
                              Text(widget.videoPath.baseName),
                              Spacer(),
                              _actionMenuButton,
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton _actionMenuButton = PopupMenuButton(
    child: Icon(Icons.more_horiz),
    itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.alt_route),
              Text('Rename'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.archive),
              Text('Move'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.copy),
              Text('Duplicate'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.delete_outline),
              Text('Trash'),
            ],
          ),
        ),
      ];
    },
  );
}

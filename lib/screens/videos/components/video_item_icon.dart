import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:app/services/file_service/file_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/screens/player/player_screen_stf.dart';
import 'package:app/widgets/generate_thumbnail_image.dart';

class VideoItemIcon extends StatefulWidget {
  final String videoPath;

  const VideoItemIcon({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoItemIconState createState() => _VideoItemIconState();
}

class _VideoItemIconState extends State<VideoItemIcon> {
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
    return InkWell(
      onTap: () async {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) {
              return PlayerScreen(videoFile: widget.videoPath.getFile);
            },
            fullscreenDialog: true,
          ),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.lightBlueGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _futreImage,
      ),
    );
  }
}

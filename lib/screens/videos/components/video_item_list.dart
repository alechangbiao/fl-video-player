import 'dart:math' as math;
import 'package:app/models/video_info.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:app/widgets/generate_thumbnail_image.dart';
import 'package:app/screens/player/player_screen_stf.dart';
import 'package:app/services/file_service/file_service.dart';

class VideoItemList extends StatefulWidget {
  final String videoPath;
  final isRootPath;

  const VideoItemList({
    Key? key,
    required this.videoPath,
    this.isRootPath = false,
  }) : super(key: key);

  @override
  _VideoItemListState createState() => _VideoItemListState();
}

class _VideoItemListState extends State<VideoItemList> {
  late GenerateThumbnailImage? _futureImage;
  late VideoInfo _info;

  int _quality = 10;
  int _sizeH = 0;
  int _sizeW = 0;

  VideoInfo _getInfo() {
    List<VideoInfo> infos;
    widget.isRootPath
        ? infos = FileService().rootPathVideosInfo
        : infos = FileService().currentPathVideosInfo;
    return infos.firstWhere((VideoInfo e) => e.name == widget.videoPath.baseName);
  }

  GenerateThumbnailImage _makeThumbnail() {
    int thumbnailTimeMs =
        (_info.timeMs == null || _info.timeMs == _info.durationMs) ? 10000 : _info.timeMs!;
    return GenerateThumbnailImage(
      isSquare: true,
      thumbnailRequest: ThumbnailRequest(
        video: widget.videoPath,
        thumbnailPath: null,
        imageFormat: ImageFormat.JPEG,
        maxHeight: _sizeH,
        maxWidth: _sizeW,
        timeMs: thumbnailTimeMs,
        quality: _quality,
      ),
    );
  }

  void _handleTap() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          return PlayerScreen(
            videoFile: widget.videoPath.getFile,
            isRootPath: widget.isRootPath,
            videoId: _info.id,
            initialTimeMs: _info.timeMs,
          );
        },
        fullscreenDialog: true,
      ),
    );

    setState(() {
      _info = _getInfo();
      _futureImage = _makeThumbnail();
    });
  }

  @override
  void initState() {
    super.initState();
    _info = _getInfo();
    _futureImage = _makeThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    final double _rowHeight = 66;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: _handleTap,
        child: Ink(
          decoration: BoxDecoration(
              // color: AppColors.lightBlueGrey.withOpacity(0.5),
              ),
          child: Container(
            height: _rowHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: _rowHeight,
                  width: _rowHeight,
                  child: _futureImage,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "This is a very long title of the video that is imported from the macobook pro to iPhone or an iPad",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "duration",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "size",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                if (_info.timeMs != null && _info.timeMs != 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _CircleProgressIndicator(
                      diameter: _rowHeight * 0.35,
                      progress: _info.timeMs! / _info.durationMs!,
                      foregroundColor: Colors.grey[500],
                      backgroundColor: Colors.grey[700],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleProgressIndicator extends StatelessWidget {
  final double diameter;
  final double progress;
  final Color? backgroundColor;
  final Color? foregroundColor;

  _CircleProgressIndicator({
    Key? key,
    required this.diameter,
    required this.progress,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
  }) : super(key: key) {
    // ok
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: _CirclePainter(color: this.backgroundColor!, progress: 1),
          child: Container(
            width: this.diameter,
            height: this.diameter,
          ),
        ),
        CustomPaint(
          painter: _CirclePainter(color: this.foregroundColor!, progress: this.progress),
          child: Container(
            width: this.diameter,
            height: this.diameter,
          ),
        ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _CirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..color = this.color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      -(1 / 4) * math.pi * 2,
      progress * math.pi * 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

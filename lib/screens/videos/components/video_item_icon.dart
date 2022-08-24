import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:app/models/video_info.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/screens/player/player_screen_stf.dart';
import 'package:app/widgets/generate_thumbnail_image.dart';

class VideoItemIcon extends StatefulWidget {
  final String videoPath;
  final bool isRootPath;

  const VideoItemIcon({
    Key? key,
    required this.videoPath,
    this.isRootPath = false,
  }) : super(key: key);

  @override
  _VideoItemIconState createState() => _VideoItemIconState();
}

class _VideoItemIconState extends State<VideoItemIcon> {
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
      thumbnailRequest: ThumbnailRequest(
          video: widget.videoPath,
          thumbnailPath: null,
          imageFormat: ImageFormat.JPEG,
          maxHeight: _sizeH,
          maxWidth: _sizeW,
          timeMs: thumbnailTimeMs,
          quality: _quality),
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
    return InkWell(
      onTap: _handleTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            _futureImage!,
            if (_info.timeMs != null && _info.timeMs != 0)
              LinearProgressIndicator(
                value: _info.timeMs! / _info.durationMs!,
                minHeight: 1.0,
              ),
            _VideoIconMask(),
          ],
        ),
      ),
    );
  }
}

class _VideoIconMask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VideoIconMaskPainter(),
      size: Size.infinite,
    );
  }
}

class _VideoIconMaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect shapeBounds = Offset.zero & size;
    Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          Colors.white.withOpacity(0.07),
          Colors.white.withOpacity(0.22),
        ],
      ).createShader(shapeBounds);

    Path path = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top)
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy)
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy * 0.8)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

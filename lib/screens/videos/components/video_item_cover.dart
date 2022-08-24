import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:app/models/video_info.dart';
import 'package:app/screens/player/player_screen_stf.dart';
import 'package:app/widgets/generate_thumbnail_image.dart';
import 'package:app/services/file_service/file_service.dart';

class VideoItemCover extends StatefulWidget {
  final String videoPath;
  final bool isRootPath;

  const VideoItemCover({
    Key? key,
    required this.videoPath,
    this.isRootPath = false,
  }) : super(key: key);

  @override
  _VideoItemCoverState createState() => _VideoItemCoverState();
}

class _VideoItemCoverState extends State<VideoItemCover> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: Colors.grey,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: (_futureImage == null)
                  ? SizedBox()
                  : Column(
                      children: [
                        InkWell(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              _futureImage!,
                              if (_info.timeMs != null && _info.timeMs != 0)
                                LinearProgressIndicator(
                                  value: _info.timeMs! / _info.durationMs!,
                                  minHeight: 2.0,
                                ),
                            ],
                          ),
                          onTap: _handleTap,
                        ),
                        Container(
                          height: 40.0,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.videoPath.baseName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 10),
                              _actionMenuButton(videoPath: widget.videoPath),
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

  PopupMenuButton _actionMenuButton({required String videoPath}) {
    return PopupMenuButton(
      child: Icon(Icons.more_horiz),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 0,
            onTap: () => _renameVideo(videoPath: videoPath),
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
            onTap: () => _moveVideo(videoPath: videoPath),
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

  Future<void> _renameVideo({required String videoPath}) async {
    print("VideoItemCover, _renameVideo called");
    String newName = "${videoPath.fileName}1";
    FileService _fsProvider = Provider.of<FileService>(context, listen: false);
    _fsProvider.renameVideo(videoPath: videoPath, newName: newName);
  }

  Future<void> _moveVideo({required String videoPath}) async {
    print("VideoItemCover, _moveVideo called");
    FileService _fsProvider = Provider.of<FileService>(context, listen: false);
    _fsProvider.moveVideo(videoPath: videoPath, targetPath: '${_fsProvider.rootPath}/untitled1');
  }
}

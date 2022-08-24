import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/screens/player/components/play_pause_overlay_stf.dart';

class PlayerScreen extends StatefulWidget {
  final File videoFile;
  final bool isRootPath;
  final String videoId;
  final int? initialTimeMs;

  const PlayerScreen({
    Key? key,
    required this.videoFile,
    required this.videoId,
    this.isRootPath = false,
    this.initialTimeMs,
  }) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  // late Duration _position;
  // Duration? _duration;
  // bool _isPlaying = false;
  // bool _isEnd = false;

  @override
  void initState() {
    super.initState();
    this._controller = VideoPlayerController.file(widget.videoFile)
      ..addListener(_addListnerCallBack)
      ..initialize().then((_) {
        setState(() {
          if (widget.initialTimeMs != null) {
            _controller.seekTo(Duration(milliseconds: widget.initialTimeMs!)).then((_) {
              // _controller.play();
            });
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _handlePop() async {
    if (_controller.value.isPlaying) await _controller.pause();
    int timeMs = _controller.value.position.inMilliseconds;
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;

    await FileService().updateVideosInfoFileInPath(
      widget.videoFile.parent.path,
      id: widget.videoId,
      updates: {
        VideoInfoKey.timeMs: timeMs,
        VideoInfoKey.lastWatchedAt: nowTimeStamp,
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _handlePop(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Icon(Icons.arrow_left, size: 30),
        ),
        body: GestureDetector(
          // print("Vertical Drag Down: details - $details"),
          onVerticalDragDown: (details) => null,
          // print("Vertical Drag Start: details - $details"),
          onVerticalDragStart: (details) => null,
          // print("Vertical Drag End: details - $details"),
          onVerticalDragEnd: (details) => null,
          // onVerticalDragUpdate: (details) => print("Vertical Drag Update: details - $details"),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_controller),
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: orientation == Orientation.portrait
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.fromLTRB(10, 0, 10, 30),
                            ),
                            PlayPauseOverlay(
                              controller: _controller,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _addListnerCallBack() {
    // final bool isPlaying = _controller.value.isPlaying;
    // if (isPlaying != _isPlaying) {
    //   setState(() {
    //     _isPlaying = isPlaying;
    //   });
    // }
    // _position = _controller.value.position;
    // _duration = _controller.value.duration;

    // Timer.run(() {
    // _position = _controller.value.position;
    // if (_controller.value.isPlaying == false) {
    //   setState(() {
    //     _controller.seekTo(_controller.value.position);
    //   });
    // }
    // this.setState(() {
    //   _position = _controller.value.position;
    // });
    // });

    // _duration?.compareTo(_position) == 0 || _duration?.compareTo(_position) == -1
    //     ? this.setState(() {
    //         _isEnd = true;
    //       })
    //     : this.setState(() {
    //         _isEnd = false;
    //       });
  }
}

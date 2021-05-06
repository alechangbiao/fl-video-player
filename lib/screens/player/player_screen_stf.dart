import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'components/play_pause_overlay_stf.dart';

class PlayerScreen extends StatefulWidget {
  final File videoFile;

  const PlayerScreen({Key? key, required this.videoFile}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // File videoFile = "${FileService.getRootPathSync}/Basic Theming.mp4".getFile;
    this._controller = VideoPlayerController.file(widget.videoFile)
      ..addListener(() {})
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<bool> _handlePop() async {
    if (_controller.value.isPlaying) await _controller.pause();
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
                                  : EdgeInsets.fromLTRB(10, 0, 10, 30),
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
}

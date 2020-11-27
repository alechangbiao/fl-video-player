import 'package:app/screens/player/components/play_pause_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/video_player_service.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatelessWidget {
  Future<bool> _handlePop(videoPlayerService) async {
    if (videoPlayerService.isPlaying) videoPlayerService.pause();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('Building Player Page...');
    VideoPlayerService _videoPlayerService = Provider.of<VideoPlayerService>(context);

    return WillPopScope(
      onWillPop: () => _handlePop(_videoPlayerService),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.maybePop(context),
          child: Icon(Icons.arrow_left, size: 30),
        ),
        body: GestureDetector(
          onVerticalDragStart: (details) {
            print("object");
          },
          child: OrientationBuilder(
            builder: (context, orientation) {
              return Center(
                child: _videoPlayerService.initialized
                    ? AspectRatio(
                        aspectRatio: _videoPlayerService.controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_videoPlayerService.controller),
                            VideoProgressIndicator(
                              _videoPlayerService.controller,
                              allowScrubbing: true,
                              padding: orientation == Orientation.portrait
                                  ? EdgeInsets.zero
                                  : EdgeInsets.fromLTRB(10, 0, 10, 30),
                            ),
                            PlayPauseOverlay(),
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

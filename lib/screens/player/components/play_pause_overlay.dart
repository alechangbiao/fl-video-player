import 'package:app/services/video_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/extensions/video_player_extension.dart';

class PlayPauseOverlay extends StatelessWidget {
  const PlayPauseOverlay({
    Key? key,
  }) : super(key: key);

  // TODO: add dragable dot on progress indicator
  // TODO: add drag down to dismiss with fade animation

  @override
  Widget build(BuildContext context) {
    VideoPlayerService _videoPlayerService = Provider.of<VideoPlayerService>(context);

    return GestureDetector(
      onTap: () => _videoPlayerService.hideOverlay(shouldStopPreviousTask: true),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 100), // from invisible to visible
        reverseDuration: Duration(milliseconds: 200), // from visible to invisible
        child: _videoPlayerService.isOverlayVisible
            ? Stack(
                children: [
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: _videoPlayerService.isPlaying
                          ? GestureDetector(
                              child: Icon(Icons.pause, color: Colors.white, size: 100.0),
                              onTap: () {
                                _videoPlayerService.pause();
                              })
                          : GestureDetector(
                              child: Icon(Icons.play_arrow, color: Colors.white, size: 100.0),
                              onTap: () {
                                _videoPlayerService.play();
                                _videoPlayerService.hideOverlay(
                                    delay: 1500, shouldStopPreviousTask: true);
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      children: [
                        StreamBuilder<Duration>(
                          stream: _videoPlayerService.positionStream,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Text(snapshot.data!.extractTimeString)
                                : Text(_videoPlayerService.position.extractTimeString);
                          },
                        ),
                        SizedBox(width: 5),
                        Text('/'),
                        SizedBox(width: 5),
                        Text(_videoPlayerService.duration.extractTimeString),
                      ],
                    ),
                  ),
                ],
              )
            // _videoPlayerService.isOverlayVisible == false
            : GestureDetector(
                onTap: () {
                  _videoPlayerService.setOverlayVisibility = true;
                  _videoPlayerService.hideOverlay(delay: 6000);
                },
              ),
      ),
    );
  }
}

import 'package:app/services/video_player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPauseOverlay extends StatelessWidget {
  const PlayPauseOverlay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoPlayerService _videoPlayerService = Provider.of<VideoPlayerService>(context);

    return GestureDetector(
      onTap: () => _videoPlayerService.hideOverlay(),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 100), // from invisible to visible
        reverseDuration: Duration(milliseconds: 200), // from visible to invisible
        child: _videoPlayerService.isOverlayVisible
            ? Container(
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
                            _videoPlayerService.hideOverlay(delay: 1500);
                          },
                        ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _videoPlayerService.isOverlayVisible = true;
                  _videoPlayerService.hideOverlay(delay: 6000);
                },
              ),
      ),
    );
  }
}

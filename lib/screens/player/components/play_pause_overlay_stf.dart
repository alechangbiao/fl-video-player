import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:video_player/video_player.dart';
import 'package:app/extensions/video_player_extension.dart';

// Play a list of videos
// Stackoverflow: https://stackoverflow.com/questions/55466602/how-to-play-a-list-of-video-in-flutter/55755670#55755670
// Example: https://github.com/brownsoo/flutter_video_list_sample

class PlayPauseOverlay extends StatefulWidget {
  final VideoPlayerController controller;

  const PlayPauseOverlay({Key? key, required this.controller}) : super(key: key);
  @override
  _PlayPauseOverlayState createState() => _PlayPauseOverlayState();
}

class _PlayPauseOverlayState extends State<PlayPauseOverlay> {
  bool _isOverlayVisible = true;
  late List<String> _hidingOverlayTaskQueue = <String>[];

  /// Set player overlay visibility and re-render [isOverlayVisible]'s
  /// listener UI components accordingly
  set isOverlayVisible(bool visibile) {
    if (_isOverlayVisible == visibile) return;
    setState(() => _isOverlayVisible = visibile);
  }

  bool get videoIsPlaying => widget.controller.value.isPlaying;

  Future<void> playVideo() async {
    await widget.controller.play();
    setState(() {});
  }

  Future<void> pauseVideo() async {
    await widget.controller.pause();
    setState(() {});
  }

  /// Stream of the current playback position.
  ///
  /// Updates every second.
  Stream<Duration?> get positionStream {
    return Stream<Duration?>.periodic(
      const Duration(seconds: 1),
      (count) => widget.controller.value.position,
    );
  }

  /// Hide the overlay view in a short delay
  ///
  /// TODO: *hideOverlay()* API is still kinda buggy, need more test
  void hideOverlay({int delay = 0, bool shouldStopPreviousTask = false}) {
    final String taskId = randomAlpha(5); // generate a string of 5 characters
    this._hidingOverlayTaskQueue.add(taskId);
    if (delay == 0) {
      if (shouldStopPreviousTask) _hidingOverlayTaskQueue.clear();
      isOverlayVisible = false;
    } else {
      Future.delayed(Duration(milliseconds: delay), () {
        if (_hidingOverlayTaskQueue.contains(taskId)) isOverlayVisible = false;
        if (shouldStopPreviousTask) _hidingOverlayTaskQueue.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.hideOverlay(shouldStopPreviousTask: true),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 100), // from invisible to visible
        reverseDuration: Duration(milliseconds: 200), // from visible to invisible
        child: _isOverlayVisible
            ? Stack(
                children: [
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: this.videoIsPlaying
                          ? GestureDetector(
                              child: Icon(Icons.pause, color: Colors.white, size: 100.0),
                              onTap: () => this.pauseVideo(),
                            )
                          : GestureDetector(
                              child: Icon(Icons.play_arrow, color: Colors.white, size: 100.0),
                              onTap: () {
                                this.playVideo();
                                this.hideOverlay(delay: 1500, shouldStopPreviousTask: true);
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      children: [
                        StreamBuilder<Duration?>(
                          stream: positionStream,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Text(snapshot.data!.extractTimeString)
                                : Text(widget.controller.value.position.extractTimeString);
                          },
                        ),
                        SizedBox(width: 5),
                        Text('/'),
                        SizedBox(width: 5),
                        Text(widget.controller.value.duration.extractTimeString),
                      ],
                    ),
                  ),
                ],
              )
            // _videoPlayerService.isOverlayVisible == false
            : GestureDetector(
                onTap: () {
                  this.isOverlayVisible = true;
                  this.hideOverlay(delay: 6000);
                },
              ),
      ),
    );
  }
}

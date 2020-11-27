import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerService with ChangeNotifier {
  VideoPlayerController _controller;

  bool _isOverlayVisible = true;

  VideoPlayerService.asset({String asset = 'assets/intro.mp4'}) {
    this._controller = VideoPlayerController.asset(asset)
      ..addListener(() {})
      ..initialize().then((_) => notifyListeners());
  }

  VideoPlayerService.file(File videoFile) {
    this._controller = VideoPlayerController.file(videoFile)
      ..addListener(() {})
      ..initialize().then((_) => notifyListeners());
  }

  VideoPlayerController get controller => _controller;

  bool get initialized => _controller.value.initialized;

  bool get isPlaying => _controller.value.isPlaying;

  /// Is null when [_controller.value.initialized] is false.
  Duration get duration => _controller.value.duration;

  Duration get position => _controller.value.position;

  /// The current volume of the playback.
  double get volume => _controller.value.volume;

  /// The current speed of the playback.
  double get playbackSpeed => _controller.value.playbackSpeed;

  Future<void> pause() async {
    await _controller.pause();
    notifyListeners();
  }

  Future<void> play() async {
    await _controller.play();
    notifyListeners();
  }

  bool get isOverlayVisible => _isOverlayVisible ?? false;

  set isOverlayVisible(bool visibility) {
    if (_isOverlayVisible == visibility) return;
    _isOverlayVisible = visibility;
    notifyListeners();
  }

  void hideOverlay({int delay = 0}) {
    if (delay == 0) {
      isOverlayVisible = false;
    } else {
      Future.delayed(Duration(milliseconds: delay), () => isOverlayVisible = false);
    }
  }
}

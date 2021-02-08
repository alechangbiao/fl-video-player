import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';
// import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerService with ChangeNotifier {
  late VideoPlayerController _controller;

  bool _isOverlayVisible = true;

  /// A List that contains the ids of tasks that hide overlay.
  List<String> _hidingOverlayTaskQueue = <String>[];

  /// Constructs a [VideoPlayerController] playing a video from an asset.
  ///
  /// The name of the asset is given by the [dataSource] argument and
  /// is defaulted to `'assets/intro.mp4'`
  VideoPlayerService.asset({String dataSource = 'assets/intro.mp4'}) {
    this._controller = VideoPlayerController.asset(dataSource)
      ..addListener(() {})
      ..initialize().then((_) => notifyListeners());
  }

  /// Constructs a [VideoPlayerController] playing a video from a file.
  ///
  /// This will load the file from the file-URI given by: `'file://${file.path}`'.
  VideoPlayerService.file(File videoFile) {
    this._controller = VideoPlayerController.file(videoFile)
      ..addListener(() {})
      ..initialize().then((_) => notifyListeners());
  }

  VideoPlayerController get controller => _controller;

  bool get initialized => _controller.value.isInitialized;

  bool get isPlaying => _controller.value.isPlaying;

  /// The total duration of the video.
  ///
  /// Is null when [_controller.value.initialized] is false.
  Duration get duration => _controller.value.duration;

  /// The current playback position.
  Duration get position => _controller.value.position;

  /// Stream of the current playback position.
  ///
  /// Updates every second.
  Stream<Duration> get positionStream {
    return Stream<Duration>.periodic(
      const Duration(seconds: 1),
      (count) => _controller.value.position,
    );
  }

  /// The current volume of the playback.
  double get volume => _controller.value.volume;

  /// The current speed of the playback.
  double get playbackSpeed => _controller.value.playbackSpeed;

  // set playbackSpeed(double speed) => _controller.setPlay

  /// Pauses the video.
  Future<void> pause() async {
    await _controller.pause();
    notifyListeners();
  }

  /// This method returns a future that completes as soon as the "play" command
  /// has been sent to the platform, not when playback itself is totally finished.
  Future<void> play() async {
    await _controller.play();
    notifyListeners();
  }

  bool get isOverlayVisible => _isOverlayVisible;

  /// Set player overlay visibility and re-render [isOverlayVisible]'s
  /// listener UI components accordingly
  set setOverlayVisibility(bool visibile) {
    if (_isOverlayVisible == visibile) return;
    _isOverlayVisible = visibile;
    notifyListeners();
  }

  /// Hide the overlay view in a short delay
  ///
  /// TODO: *hideOverlay()* API is still kinda buggy, need more test
  void hideOverlay({int delay = 0, bool shouldStopPreviousTask = false}) {
    final String taskId = randomAlpha(5); // generate a string of 5 characters
    this._hidingOverlayTaskQueue.add(taskId);
    if (delay == 0) {
      if (shouldStopPreviousTask) _hidingOverlayTaskQueue.clear();
      setOverlayVisibility = false;
    } else {
      Future.delayed(Duration(milliseconds: delay), () {
        if (_hidingOverlayTaskQueue.contains(taskId)) setOverlayVisibility = false;
        if (shouldStopPreviousTask) _hidingOverlayTaskQueue.clear();
      });
    }
  }
}

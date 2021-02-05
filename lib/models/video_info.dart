import 'dart:convert';

import 'package:random_string/random_string.dart';

/// A collection of values, that contains information of a video file.
///
/// A [VideoInfo] object can be constructed from parsing JSON string in the
/// `.video_infoes` file which was created along with the folder, or when was not
/// found in the directory. A `.video_infoes` file stores information of a List of
/// [VideoInfo] objects in the format of JSON string.
///
/// ---
///
///     String id;  // id of the [VideoInfo] object
///     String name;  // name of the video file
///     int timeMS; // playback position of the last time
///     int createdAt, lastWatchedAt, lastModifiedAt;
///
/// ---
///
///     // Parses the JSON string and returns the resulting `VideoInfo` object.
///     DotHistory.fromJsonString(String jsonString);
///     // Converts `<VideoInfo>data` to JSON string.
///     VideoInfo.toJsonString(DotLocal data);
class VideoInfo {
  /// Parses a JSON string and returns the resulting `VideoInfo` object.
  static VideoInfo fromJsonString(String jsonString) => VideoInfo.fromJson(json.decode(jsonString));

  /// Converts `<VideoInfo>data` to JSON string.
  ///
  /// Converts `<VideoInfo>data` to instance of `Map<String, dynamic>` that
  /// contains the information, then decode the `<Map>instance` to a JSON string
  /// for the `.video_infoes` file to store.
  static String toJsonString(VideoInfo data) => json.encode(data.toJson());

  String id;
  String name;
  int timeMs;
  int createdAt;
  int lastWatchedAt;
  int lastModifiedAt;

  /// Construct a `VideoInfo()` instance
  ///
  ///     String name;  // name of the video file
  ///     int timeMS; // playback position of the last time
  ///     int lastWatchedAt, lastModifiedAt, trashedAt;
  VideoInfo({
    required this.id,
    required this.name,
    required this.timeMs,
    required this.createdAt,
    required this.lastWatchedAt,
    required this.lastModifiedAt,
  });

  /// Construct a `VideoInfo()` instance from a `JSON Map`
  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      id: json['id'] ?? randomAlpha(5),
      name: json['name'],
      timeMs: json['timeMs'],
      createdAt: json['createdAt'],
      lastWatchedAt: json['lastWatchedAt'],
      lastModifiedAt: json['lastModifiedAt'],
    );
  }

  /// Create a `JSON Map` from a [VideoInfo] the instance property
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "timeMs": this.timeMs,
      "createdAt": this.createdAt,
      "lastWatchedAt": this.lastWatchedAt,
      "lastModifiedAt": this.lastModifiedAt,
    };
  }
}

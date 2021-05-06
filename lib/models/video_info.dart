import 'dart:convert';

import 'package:random_string/random_string.dart';

/// A collection of values, that contains information of a video file.
///
/// A `List<VideoInfo>` object can be constructed from parsing JSON string in the
/// `.videos_info` file which was created along with the folder, or when was not
/// found in the directory. A `.videos_info` file stores information of a List of
/// [VideoInfo] objects in the format of JSON string.
/// ---
/// ```dart
/// String id;  // id of the [VideoInfo] object
/// String name;  // name of the video file, for targeting the info data
/// int? timeMS; // the specified millisecond that last playback stopped at
/// int? durationMs;  // total duration of the video in millisecond
/// int? lastWatchedAt; // time stamp of the last time this video was watched
/// int createdAt, lastModifiedAt;  // timeStamps
/// ```
/// ---
/// ```dart
/// // Parses a JSON string and returns the resulting `List<VideoInfo>` object.
/// VideoInfo.fromJsonString(String jsonString);
/// // Converts `List<VideoInfo> data` to JSON string.
/// VideoInfo.toJsonString(List<VideoInfo> data);
/// ```
class VideoInfo {
  /// Parses a JSON string and returns the resulting `List<VideoInfo>` object.
  static List<VideoInfo> fromJsonString(String jsonString) =>
      List<VideoInfo>.from(json.decode(jsonString).map((info) => VideoInfo.fromJson(info)));

  /// Converts `List<VideoInfo> data` to JSON string.
  ///
  /// Converts `List<VideoInfo> data` to instance of `Map<String, dynamic>` that
  /// contains the information, then decode the `<Map>instance` to a JSON string
  /// for the `.video_infoes` file to store.
  static String toJsonString(List<VideoInfo> data) =>
      json.encode(List<dynamic>.from(data.map((VideoInfo info) => info.toJson())));

  static const String fileName = ".videos_info";

  String id;
  String name;
  int? timeMs; // the specified millisecond that last playback stopped at
  int? durationMs; // total duration of the video in millisecond
  int? lastWatchedAt;
  int createdAt;
  int lastModifiedAt;

  /// Construct a `VideoInfo()` instance
  /// ```dart
  /// String id;  // id of the [VideoInfo] object
  /// String name;  // name of the video file, for targeting the info data
  /// int? timeMS; // the specified millisecond that last playback stopped at
  /// int? durationMs;  // total duration of the video in millisecond
  /// int? lastWatchedAt; // time stamp of the last time this video was watched
  /// int createdAt, lastModifiedAt;  // timeStamps
  /// ```
  VideoInfo({
    required this.id,
    required this.name,
    this.timeMs,
    this.durationMs,
    required this.createdAt,
    this.lastWatchedAt,
    required this.lastModifiedAt,
  });

  /// Construct a `VideoInfo()` instance from a `JSON Map`
  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      id: json['id'] ?? randomAlpha(5),
      name: json['name'],
      timeMs: json['timeMs'],
      durationMs: json['durationMs'],
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
      "durationMs": this.durationMs,
      "createdAt": this.createdAt,
      "lastWatchedAt": this.lastWatchedAt,
      "lastModifiedAt": this.lastModifiedAt,
    };
  }
}

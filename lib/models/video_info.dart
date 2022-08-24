import 'dart:convert';
import 'dart:io';

import 'package:app/models/dot_info.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
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
class VideoInfo implements DotInfo {
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

  /// create a list of [VideoInfo] from a given list of video files
  static Future<List<VideoInfo>> createList({required List<File> videos}) async {
    List<VideoInfo> videoInfoList = <VideoInfo>[];
    if (videos.isNotEmpty) {
      await Future.forEach(videos, (File video) async {
        VideoInfo info = await create(video: video);
        videoInfoList.add(info);
      });
    }
    return videoInfoList;
  }

  /// create a [VideoInfo] from a given of video file
  static Future<VideoInfo> create({required File video}) async {
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    int? durationMs = (await FlutterVideoInfo().getVideoInfo(video.path))?.duration?.round();
    return VideoInfo(
      id: randomAlpha(6),
      name: video.path.split('/').last,
      durationMs: durationMs,
      createdAt: nowTimeStamp,
      lastModifiedAt: nowTimeStamp,
    );
  }

  static List<VideoInfo> deleteById({required List<VideoInfo> infos, required String videoId}) {
    List<VideoInfo> updatedList = infos.where((VideoInfo info) => info.id != videoId).toList();
    return updatedList;
  }

  /// ```dart
  /// String fileName = ".videos_info";
  /// ```
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
      id: json[VideoInfoKey.id] ?? randomAlpha(5),
      name: json[VideoInfoKey.name],
      timeMs: json[VideoInfoKey.timeMs],
      durationMs: json[VideoInfoKey.durationMs],
      createdAt: json[VideoInfoKey.createdAt],
      lastWatchedAt: json[VideoInfoKey.lastWatchedAt],
      lastModifiedAt: json[VideoInfoKey.lastModifiedAt],
    );
  }

  /// Create a `JSON Map` from a [VideoInfo] the instance property
  @override
  Map<String, dynamic> toJson() {
    return {
      VideoInfoKey.id: this.id,
      VideoInfoKey.name: this.name,
      VideoInfoKey.timeMs: this.timeMs,
      VideoInfoKey.durationMs: this.durationMs,
      VideoInfoKey.createdAt: this.createdAt,
      VideoInfoKey.lastWatchedAt: this.lastWatchedAt,
      VideoInfoKey.lastModifiedAt: this.lastModifiedAt,
    };
  }

  @override
  dynamic getValue({required String key}) {
    switch (key) {
      case VideoInfoKey.id:
        return this.id;
      case VideoInfoKey.name:
        return this.name;
      case VideoInfoKey.timeMs:
        return this.timeMs;
      case VideoInfoKey.durationMs:
        return this.durationMs;
      case VideoInfoKey.createdAt:
        return this.createdAt;
      case VideoInfoKey.lastWatchedAt:
        return this.lastWatchedAt;
      case VideoInfoKey.lastModifiedAt:
        return this.lastModifiedAt;
    }
  }

  @override
  void update({required Map<String, dynamic> updates}) {
    for (MapEntry<String, dynamic> e in updates.entries) {
      if (e.key == VideoInfoKey.name && e.value is String) this.name = e.value;
      if (e.key == VideoInfoKey.timeMs && e.value is int?) this.timeMs = e.value;
      if (e.key == VideoInfoKey.durationMs && e.value is int?) this.durationMs = e.value;
      if (e.key == VideoInfoKey.lastWatchedAt && e.value is int?) this.lastWatchedAt = e.value;
    }
    if (updates.length > 0) {
      int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
      this.lastModifiedAt = nowTimeStamp;
    }
  }
}

class VideoInfoKey {
  static const String id = "id";
  static const String name = "name";
  static const String timeMs = "timeMs"; // the specified millisecond that last playback stopped at
  static const String durationMs = "durationMs"; // total duration of the video in millisecond
  static const String lastWatchedAt = "lastWatchedAt";
  static const String createdAt = "createdAt";
  static const String lastModifiedAt = "lastModifiedAt";
}

import 'dart:convert';
import 'dart:io';

import 'package:app/models/dot_info.dart';
import 'package:app/models/video_info.dart';
import 'package:mime/mime.dart';

/// A collection of values, that contains information of files that are trashed.
///
/// A `List<TrashInfo>` object can be constructed from parsing JSON string in the
/// `.trash_info` file which was created along with the folder, or when was not
/// found in the directory. A `.trash_info` file stores information of a List of
/// [TrashInfo] objects in the format of JSON string.
/// ---
/// ```dart
/// String name;  // name of the video file, for targeting the info data
/// String originalPath; // path of the file before it was trashed
/// int trashedAt;  // time stamp when the file was trashed
/// String fileType;  // file mime type in String, 'video' | 'folder'
/// VideoInfo? videoInfo; // VideoInfo of the trashed video file
/// ```
/// ---
/// ```dart
/// // Parses a JSON string and returns the resulting `List<TrashInfo>` object.
/// VideoInfo.fromJsonString(String jsonString);
/// // Converts `List<TrashInfo> data` to JSON string.
/// VideoInfo.toJsonString(List<TrashInfo> data);
/// ```
class TrashInfo implements DotInfo {
  /// Parses a JSON string and returns the resulting `List<TrashInfo>` object.
  static List<TrashInfo> fromJsonString(String jsonString) {
    return List<TrashInfo>.from(json.decode(jsonString).map((info) => TrashInfo.fromJson(info)));
  }

  /// Converts `List<TrashInfo> data` to JSON string.
  ///
  /// Converts `List<TrashInfo> data` to instance of `Map<String, dynamic>` that
  /// contains the information, then decode the `<Map>instance` to a JSON string
  /// for the `.video_infoes` file to store.
  static String toJsonString(List<TrashInfo> data) =>
      json.encode(List<dynamic>.from(data.map((TrashInfo info) => info.toJson())));

  /// create a list of [TrashInfo] from a given list of video files
  static Future<List<TrashInfo>> createList({required List<File> files}) async {
    List<TrashInfo> trashInfoList = <TrashInfo>[];
    if (files.isNotEmpty) {
      await Future.forEach(files, (File file) async {
        TrashInfo info = await create(file: file, originalPath: file.path);
        trashInfoList.add(info);
      });
    }
    return trashInfoList;
  }

  /// create a [TrashInfo] from a given of video file
  static Future<TrashInfo> create({
    required File file,
    required String originalPath,
    VideoInfo? videoInfo,
  }) async {
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    String fileType = FileSystemEntity.isDirectorySync(file.path)
        ? FileType.folder.name
        : isVideo(file.path)
            ? FileType.video.name
            : "unknown";
    // int? durationMs = (await FlutterVideoInfo().getVideoInfo(video.path))?.duration?.round();
    return TrashInfo(
      name: file.path.split('/').last,
      originalPath: originalPath,
      trashedAt: nowTimeStamp,
      fileType: fileType,
      videoInfo: videoInfo,
    );
  }

  static List<TrashInfo> deleteByName({required List<TrashInfo> infos, required String name}) {
    List<TrashInfo> updatedList = infos.where((TrashInfo info) => info.name != name).toList();
    return updatedList;
  }

  static bool isVideo(String path) {
    final String? mimeString = lookupMimeType(path);
    if (mimeString == null) return false;
    final String type = mimeString.split('/')[0];
    return type == 'video';
  }

  /// ```dart
  /// String fileName = ".trash_info";
  /// ```
  static const String fileName = ".trash_info";

  String name;
  String originalPath;
  int trashedAt;
  String fileType;
  VideoInfo? videoInfo;

  TrashInfo({
    required this.name,
    required this.originalPath,
    required this.trashedAt,
    required this.fileType,
    this.videoInfo,
  });

  factory TrashInfo.fromJson(Map<String, dynamic> json) {
    return TrashInfo(
      name: json[TrashInfoKey.name],
      fileType: json[TrashInfoKey.fileType],
      originalPath: json[TrashInfoKey.originalPath],
      trashedAt: json[TrashInfoKey.trashedAt],
      videoInfo: json[TrashInfoKey.videoInfo] != null
          ? VideoInfo.fromJson(json[TrashInfoKey.videoInfo])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      TrashInfoKey.name: this.name,
      TrashInfoKey.originalPath: this.originalPath,
      TrashInfoKey.trashedAt: this.trashedAt,
      TrashInfoKey.fileType: this.fileType,
      TrashInfoKey.videoInfo: this.videoInfo != null ? this.videoInfo!.toJson() : null,
    };
  }

  @override
  dynamic getValue({required String key}) {
    switch (key) {
      case TrashInfoKey.name:
        return this.name;
      case TrashInfoKey.originalPath:
        return this.originalPath;
      case TrashInfoKey.trashedAt:
        return this.trashedAt;
      case TrashInfoKey.fileType:
        return this.fileType;
      case TrashInfoKey.videoInfo:
        return this.videoInfo;
    }
  }

  @override
  void update({required Map<String, dynamic> updates}) {
    for (MapEntry<String, dynamic> e in updates.entries) {
      if (e.key == TrashInfoKey.name && e.value is String) this.name = e.value;
      if (e.key == TrashInfoKey.originalPath && e.value is String) this.originalPath = e.value;
      if (e.key == TrashInfoKey.trashedAt && e.value is int) this.trashedAt = e.value;
      if (e.key == TrashInfoKey.fileType && e.value is String) this.fileType = e.value;
      if (e.key == TrashInfoKey.videoInfo && e.value is VideoInfo?) this.videoInfo = e.value;
    }
  }

  // bool get isVideo => this.fileType == FileType.video.name;
}

class TrashInfoKey {
  static const String name = "name";
  static const String originalPath = "originalPath";
  static const String trashedAt = "trashedAt";
  static const String fileType = "fileType";
  static const String videoInfo = "videoInfo";
}

enum FileType { video, folder }

extension FileTypeExtension on FileType {
  static const names = {
    FileType.video: 'video',
    FileType.folder: 'folder',
  };

  String get name => names[this]!;
}

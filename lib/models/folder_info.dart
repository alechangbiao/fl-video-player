import 'dart:convert';
import 'package:random_string/random_string.dart';
import 'package:app/models/dot_info.dart';

/// A collection of values, that contains information of a directory folder.
///
/// A [FolderInfo] object can be constructed from parsing JSON string in the
/// `.info` file which was created along with the folder, or when was not found
/// in the directory.
/// ---
/// ```dart
/// String id;  // id of the [FolderInfo] object
/// String name;  // name of the directory
/// String? password;  // password of the directory
/// String? iconName ; // name of the icon to show on the directory
/// bool isPrivate; // whether this directory is private
/// int createdAt, lastModifiedAt; // timeStamps
/// String? sequence, layout; // arrangement order & icon forms to display
/// ```
/// ---
/// ```dart
/// // Parses the JSON string and returns the resulting `FolderInfo` object.
/// FolderInfo.fromJsonString(String jsonString);
/// // Converts `<FolderInfo>data` to JSON string.
/// FolderInfo.toJsonString(FolderInfo data);
/// ```
class FolderInfo implements DotInfo {
  /// Parses a JSON string and returns the resulting `FolderInfo` object.
  static FolderInfo fromJsonString(String jsonString) =>
      FolderInfo.fromJson(json.decode(jsonString));

  /// Converts `<FolderInfo>data` to JSON string.
  ///
  /// Converts `<FolderInfo>data` to instance of `Map<String, dynamic>` that
  /// contains the information, then decode the `<Map>instance` to a JSON string
  /// for the `.info` file to store.
  static String toJsonString(FolderInfo data) => json.encode(data.toJson());

  static FolderInfo create({
    required String? path,
    bool isPrivate = false,
    String? password,
    String? iconName,
  }) {
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    return FolderInfo(
      id: randomAlpha(6),
      name: path!.split('/').last,
      password: password,
      iconName: iconName,
      isPrivate: isPrivate,
      createdAt: nowTimeStamp,
      lastModifiedAt: nowTimeStamp,
    );
  }

  static const String fileName = ".info";

  String id;
  String name;
  bool isPrivate;
  String? password;
  String? iconName;
  int createdAt;
  int lastModifiedAt;
  String? sequence;
  String? layout;

  /// Construct a `FolderInfo()` instance
  /// ```dart
  /// String id;  // id of the [.info] file
  /// String name;  // name of the directory
  /// String? password;  // password of the directory
  /// String? iconName ; // name of the icon to show on the directory
  /// bool isPrivate; // whether this directory is private
  /// int createdAt, lastModifiedAt; // timeStamps
  /// String? sequence, layout; // arrangement order & icon forms to display
  /// ```
  FolderInfo({
    required this.id,
    required this.name,
    required this.isPrivate,
    this.password,
    this.iconName,
    required this.createdAt,
    required this.lastModifiedAt,
    this.sequence,
    this.layout,
  });

  /// Construct a `FolderInfo()` instance from a `JSON Map`
  factory FolderInfo.fromJson(Map<String, dynamic> json) {
    return FolderInfo(
      id: json[FolderInfoKey.id] ?? randomAlpha(5),
      isPrivate: json[FolderInfoKey.isPrivate],
      name: json[FolderInfoKey.name],
      password: json[FolderInfoKey.password],
      iconName: json[FolderInfoKey.iconName],
      createdAt: json[FolderInfoKey.createdAt],
      lastModifiedAt: json[FolderInfoKey.lastModifiedAt],
      sequence: json[FolderInfoKey.sequence],
      layout: json[FolderInfoKey.layout],
    );
  }

  /// Create a `JSON Map` using the instance property
  @override
  Map<String, dynamic> toJson() {
    return {
      FolderInfoKey.id: this.id,
      FolderInfoKey.name: this.name,
      FolderInfoKey.isPrivate: this.isPrivate,
      FolderInfoKey.password: this.password,
      FolderInfoKey.iconName: this.iconName,
      FolderInfoKey.createdAt: this.createdAt,
      FolderInfoKey.lastModifiedAt: this.lastModifiedAt,
      FolderInfoKey.sequence: this.sequence,
      FolderInfoKey.layout: this.layout,
    };
  }

  @override
  void update({Map<String, dynamic>? updates}) {
    if (updates != null) {
      for (MapEntry<String, dynamic> e in updates.entries) {
        if (e.key == FolderInfoKey.name && e.value is String) this.name = e.value;
        if (e.key == FolderInfoKey.isPrivate && e.value is bool) this.isPrivate = e.value;
        if (e.key == FolderInfoKey.password && e.value is String?) this.password = e.value;
        if (e.key == FolderInfoKey.iconName && e.value is String?) this.iconName = e.value;
        if (e.key == FolderInfoKey.sequence && e.value is String?) this.sequence = e.value;
        if (e.key == FolderInfoKey.layout && e.value is String?) this.layout = e.value;
      }
    }
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    this.lastModifiedAt = nowTimeStamp;
  }

  @override
  dynamic getValue({required String key}) {
    switch (key) {
      case FolderInfoKey.id:
        return this.id;
      case FolderInfoKey.name:
        return this.name;
      case FolderInfoKey.isPrivate:
        return this.isPrivate;
      case FolderInfoKey.password:
        return this.password;
      case FolderInfoKey.iconName:
        return this.iconName;
      case FolderInfoKey.createdAt:
        return this.createdAt;
      case FolderInfoKey.lastModifiedAt:
        return this.lastModifiedAt;
      case FolderInfoKey.sequence:
        return this.sequence;
      case FolderInfoKey.layout:
        return this.layout;
    }
  }
}

class FolderInfoKey {
  static const String id = "id";
  static const String name = "name";
  static const String isPrivate = "isPrivate";
  static const String password = "password";
  static const String createdAt = "createdAt";
  static const String iconName = "iconName";
  static const String lastModifiedAt = "lastModifiedAt";
  static const String sequence = "sequence";
  static const String layout = "layout";
}

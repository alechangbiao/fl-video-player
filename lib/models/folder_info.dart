import 'dart:convert';
import 'package:random_string/random_string.dart';

/// A collection of values, that contains information of a directory folder.
///
/// A [FolderInfo] object can be constructed from parsing JSON string in the
/// `.info` file which was created along with the folder, or when was not found
/// in the directory.
/// ---
///
///     String name, password;  // name and password of the directory
///     String iconName ; // name of the icon to show on the directory
///     bool isPrivate; // whether this directory is private
///     int createdAt, lastModifiedAt; // timeStamps of the file
///
/// ---
///
///     // Parses the JSON string and returns the resulting `FolderInfo` object.
///     FolderInfo.fromJsonString(String jsonString);
///     // Converts `<FolderInfo>data` to JSON string.
///     FolderInfo.toJsonString(FolderInfo data);
class FolderInfo {
  /// Parses a JSON string and returns the resulting `FolderInfo` object.
  static FolderInfo fromJsonString(String jsonString) =>
      FolderInfo.fromJson(json.decode(jsonString));

  /// Converts `<FolderInfo>data` to JSON string.
  ///
  /// Converts `<FolderInfo>data` to instance of `Map<String, dynamic>` that
  /// contains the information, then decode the `<Map>instance` to a JSON string
  /// for the `.info` file to store.
  static String toJsonString(FolderInfo data) => json.encode(data.toJson());

  String id;
  String name;
  bool isPrivate;
  String? password;
  String? iconName;
  int createdAt;
  int lastModifiedAt;

  /// Construct a `FolderInfo()` instance
  ///
  ///     String id;  // id of the [FolderInfo] object
  ///     String name, password;  // name and password of the directory
  ///     String iconName ; // name of the icon to show on the directory
  ///     bool isPrivate; // whether this directory is private
  ///     int createdAt, lastModifiedAt; // timeStamps
  FolderInfo({
    required this.id,
    required this.name,
    required this.isPrivate,
    this.password,
    this.iconName,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  /// Construct a `FolderInfo()` instance from a `JSON Map`
  factory FolderInfo.fromJson(Map<String, dynamic> json) {
    return FolderInfo(
      id: json['id'] ?? randomAlpha(5),
      isPrivate: json['isPrivate'],
      name: json['name'],
      password: json['password'],
      iconName: json['iconName'],
      createdAt: json['createdAt'],
      lastModifiedAt: json['lastModifiedAt'],
    );
  }

  /// Create a `JSON Map` using the instance property
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "isPrivate": this.isPrivate,
      "password": this.password,
      "iconName": this.iconName,
      "createdAt": this.createdAt,
      "lastModifiedAt": this.lastModifiedAt,
    };
  }
}

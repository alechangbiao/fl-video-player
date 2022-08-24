import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';

import 'package:app/models/trash_info.dart';
import 'package:app/models/video_info.dart';
import 'package:app/models/folder_info.dart';
import 'package:app/utils/constants.dart';

part 'package:app/services/file_service/utils.dart';
part 'package:app/services/file_service/video_part.dart';
part 'package:app/services/file_service/folder_part.dart';
part 'package:app/services/file_service/trash_folder_part.dart';

/// A service class to manage files in app directory
///
/// `FileService.init()`dart function should be called at app launch
class FileService with ChangeNotifier {
  /// Construct an instance of [FileService]
  FileService() {
    if (_rootPath == null) setPaths();
  }

  static Future<void> init() async {
    if (_rootPath != null) {
      _currentPath ??= _rootPath; // sets the _currentPath to _rootPath only if it's null
      return;
    }
    final Directory? directory = await getApplicationDocumentsDirectory();
    _currentPath = _rootPath = directory?.path;
  }

  //***************** Path properties, setters & getters *****************//

  static String? _rootPath;
  static String? _currentPath;

  String? get rootPath => _rootPath;

  String? get currentPath => _currentPath;

  set currentPath(String? path) => FileService.currentPathStatic = path;

  /// Constructor can not be async, hense this method is created
  Future<void> setPaths() async {
    _rootPath = await getRootPath;
    _currentPath ??= _rootPath;
  }

  /// Static getter to `_rootPath` in [FileService]
  ///
  /// Make sure `FileService.init()` has been called before using this method.
  static String? get getRootPathStatic => _rootPath;

  /// Static getter to `_currentPath` in [FileService]
  ///
  /// Make sure `FileService.init()` has been called before using this method.
  static String? get getCurrentPathStatic => _currentPath;

  /// Static setter to set `_currentPath` in [FileService]
  static set currentPathStatic(String? path) {
    if (_currentPath == path) return;
    _currentPath = path;
    print('current path has changed to: ${FileService._currentPath}');
  }

  Future<String?> get getRootPath async {
    if (_rootPath != null) return _rootPath;
    final Directory? directory = await getApplicationDocumentsDirectory();
    return directory?.path;
  }

  bool isRootPath(String? path) => path == null ? false : path == _rootPath;
  bool isCurrentPath(String? path) => path == null ? false : path == _currentPath;

  void notify() => notifyListeners();

  //***************** Class Methods *****************//

  /// Navigate current path by `<int>level`
  void goBack({int level = 1}) async {
    List<String> splitedPath = currentPath!.split('/');
    splitedPath.removeRange(splitedPath.length - level, splitedPath.length);
    currentPath = splitedPath.join('/');
  }

  /// List all the files in the given path of a directory
  Future<List<FileSystemEntity>> _listFiles(
    String? path, {
    bool testing = false,
  }) async {
    _rootPath ?? await setPaths(); // make sure _rootPath is not null
    path = testing ? _rootPath : path;
    List<FileSystemEntity> fileList = Directory("$path/").listSync();
    for (FileSystemEntity file in fileList) {
      bool isDirectory = await FileSystemEntity.isDirectory(file.path);
      String? fileType = lookupMimeType(file.path);
      print("${file.baseName} - ${isDirectory ? "directory" : "file"} - $fileType");
    }
    return fileList;
  }

  Future<List<FileSystemEntity>> listTestingPathFiles({bool testing = false}) {
    return _listFiles('$rootPath/test', testing: testing);
  }

  /// List all the files in the directory given _rootPath
  Future<List<FileSystemEntity>> listRootPathFiles({bool testing = false}) async {
    return _listFiles(_rootPath, testing: testing);
  }

  /// List all the files in the directory given _currentPath
  Future<List<FileSystemEntity>> listCurrentPathFiles({bool testing = false}) async {
    return _listFiles(_currentPath, testing: testing);
  }

  Future<bool> _isFileExists({
    @required String? fileBaseName,
    @required String? path,
    bool testing = false,
  }) async {
    path = testing ? '$rootPath/test' : path ?? _currentPath ?? _rootPath;
    bool exists = await File('$path/$fileBaseName').exists();
    // print('File $path/$fileBaseName exists: $exists.');
    return exists;
  }
}

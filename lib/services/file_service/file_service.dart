import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:mime/mime.dart';

import 'package:app/models/video_info.dart';
import 'package:app/models/folder_info.dart';
import 'package:app/utils/constants.dart';

part 'package:app/services/file_service/utils.dart';
part 'package:app/services/file_service/video_part.dart';
part 'package:app/services/file_service/file_part.dart';

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

  /// Create a directory, default name to `'untitled' + incremental suffix`
  /// (eg. untitled 2) if name is not provided
  Future<Directory> createDirectory({required String? name, String? path}) async {
    _rootPath ?? await setPaths();
    path = path ?? _currentPath ?? _rootPath;

    List<String> dirBaseNames =
        (await this.updateRootPathFoldersList()).map((directory) => directory.baseName).toList();
    // regular express for a string that is 'untitled' or 'untitled\s\d+'
    final RegExp untitledRegExp = RegExp(r'^untitled(\s\d+$)?');
    List<String> untitledDirBaseNames =
        dirBaseNames.where((name) => untitledRegExp.hasMatch("$name")).toList();

    if (name == null) {
      if (untitledDirBaseNames.isEmpty) {
        name = "untitled";
      } else if (untitledDirBaseNames.length == 1 && untitledDirBaseNames[0] == 'untitled') {
        name = "untitled 2";
      } else {
        int maxUntitledDirNumSuffix = untitledDirBaseNames
            .where((String name) => name != 'untitled')
            .map((String name) => int.parse(name.replaceAll(new RegExp(r'[^0-9]'), '')))
            .reduce(max);
        String suffix = (maxUntitledDirNumSuffix + 1).toString();
        name = "untitled $suffix";
      }
    }

    String newDirPath = "$path/$name";
    Directory newDir = await Directory(newDirPath).create();
    await this.createFolderInfoFile(path: newDirPath);
    return newDir;
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

  /// Moving a file to a new path
  ///
  /// Using rename as it is probably faster.
  /// If rename fails, copy the source file and then delete it
  Future<dynamic> moveFile({required File file, required String to}) async {
    try {
      return await file.rename(to);
    } on FileSystemException catch (e) {
      print(e);
      final newFile = await file.copy(to);
      await file.delete();
      return newFile;
    }
  }

  // TODO: Complete the functionality of belowing API
  Future<dynamic>? moveDirectory({required Directory directory, required String to}) {}
}

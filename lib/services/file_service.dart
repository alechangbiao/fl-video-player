// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

import 'package:app/models/video_info.dart';
import 'package:app/models/foler_info.dart';

/// A service class to manage files in app directory
///
///     FileService.init() function should be called at app launch
class FileService with ChangeNotifier {
  /// Construct an instance of [FileService]
  FileService() {
    if (_rootPath == null) setPaths();
  }

  static String _rootPath;
  static String _currentPath;

  /// Make sure `FileService.init()` has been called before using this method.
  static String get getRootPathSync => _rootPath;

  static Future<void> init() async {
    if (_rootPath != null) {
      _currentPath ??= _rootPath;
      return;
    }
    final Directory directory = await getApplicationDocumentsDirectory();
    _currentPath = _rootPath = directory.path;
  }

  String get rootPath => _rootPath;

  String get currentPath => _currentPath;

  /// Constructor can not be async, hense this method is created
  Future<void> setPaths() async {
    _rootPath = await getRootPath;
    _currentPath ??= _rootPath;
  }

  Future<String> get getRootPath async {
    if (_rootPath != null) return _rootPath;
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// List all the files in the given path of a directory
  Future<List<FileSystemEntity>> _listFiles(
    String path, {
    bool testing = false,
  }) async {
    _rootPath ?? await setPaths(); // make sure _rootPath is not null
    path = testing ? _rootPath : path;
    List<FileSystemEntity> fileList = Directory("$path/").listSync();
    for (FileSystemEntity file in fileList) {
      bool isDirectory = await FileSystemEntity.isDirectory(file.path);
      print("${file.baseName} - ${isDirectory ? "directory" : "file"}");
    }
    return fileList;
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
  Future<Directory> createDirectory({@required String name, String path}) async {
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
    await this.createFolerInfoFile(path: newDirPath);
    return newDir;
  }

  Future<bool> _isFileExists({
    @required String fileBaseName,
    @required String path,
    bool testing = false,
  }) async {
    path = testing ? '$rootPath/test' : path ?? _currentPath ?? _rootPath;
    bool exists = await File('$path/$fileBaseName').exists();
    print('File $path/$fileBaseName exists: $exists.');
    return exists;
  }

  /// Moving a file to a new path
  ///
  /// Using rename as it is probably faster.
  /// If rename fails, copy the source file and then delete it
  Future<dynamic> moveFile({@required File file, @required String to}) async {
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
  Future<dynamic> moveDirectory({@required Directory directory, @required String to}) {}
}

/// `<Directory>Folder` Service
///
/// Helper Methods on folder object related tasks
extension FoldersExtension on FileService {
  static List<Directory> _rootPathFolders = <Directory>[];
  static List<Directory> _currentPathFolders = <Directory>[];

  List<Directory> get rootPathFolders => _rootPathFolders;

  List<Directory> get currentPathFolders => _currentPathFolders;

  set rootPathFolders(List<Directory> folders) {
    _rootPathFolders = folders;
    notifyListeners();
  }

  set currentPathFolders(List<Directory> folders) {
    _currentPathFolders = folders;
    notifyListeners();
  }

  Future<List<Directory>> updateRootPathFoldersList() async {
    rootPathFolders = await _listFolders(rootPath);
    return _rootPathFolders;
  }

  Future<List<Directory>> updateCurrentPathFoldersList() async {
    currentPathFolders = await _listFolders(currentPath);
    return _currentPathFolders;
  }

  Future<List<Directory>> _listFolders(path) async {
    assert(path != null, 'path should not be null');
    rootPath ?? await setPaths();

    List<Directory> folers = <Directory>[];
    List<FileSystemEntity> files = Directory("$path/").listSync();
    await Future.forEach(files, (FileSystemEntity file) async {
      bool isDirectoy = await file.path.isDirectory;
      if (isDirectoy) folers.add(file);
    });
    for (Directory foler in folers) print("${foler.baseName}");
    return folers;
  }
}

/// `FolderInfo` Service
///
/// Helper Methods on folderInfo object related tasks
extension FolderInfoExtension on FileService {
  static FolderInfo _rootPathFolerInfo;
  static FolderInfo _currentPathFolerInfo;

  FolderInfo get rootPathFolerInfo => _rootPathFolerInfo;

  FolderInfo get currentPathFolerInfo => _currentPathFolerInfo;

  Future<bool> isFolderInfoFileExists({String path, bool testing = false}) async {
    return await this._isFileExists(fileBaseName: '.info', path: path, testing: testing);
  }

  Future<FolderInfo> getRootPathFolderInfo({bool testing = false}) async {
    return this.getFolerInfo(path: rootPath, testing: testing);
  }

  Future<FolderInfo> getCurrentPathFolderInfo({bool testing = false}) async {
    return this.getFolerInfo(path: currentPath, testing: testing);
  }

  /// Collet information from `.info` file
  ///
  /// Create a new `.info` file if coundn't find any in the path
  Future<FolderInfo> getFolerInfo({@required String path, bool testing = false}) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    bool fileExists = await _isFileExists(fileBaseName: '.info', path: path);
    if (fileExists) {
      print('Found .info in $path');
      String jsonContent = await File('$path/.info').readAsString();
      print(jsonContent);
      return FolderInfo.fromJsonString(jsonContent);
    } else {
      print('.info not found in $path \n creating a new file...');
      File file = await this.createFolerInfoFile(path: path, testing: testing);
      String jsonContent = await file.readAsString();
      print(jsonContent);
      return FolderInfo.fromJsonString(jsonContent);
    }
  }

  /// Create an object of [FolderInfo] and save it in `.info` file as JSON String
  Future<File> createFolerInfoFile({
    @required String path,
    bool isPrivate = false,
    String password,
    String iconName,
    bool testing = false,
  }) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    FolderInfo info = FolderInfo(
      id: randomAlpha(6),
      name: path.baseName,
      password: password,
      iconName: iconName,
      isPrivate: isPrivate,
      createdAt: nowTimeStamp,
      lastModifiedAt: nowTimeStamp,
    );
    return await File('$path/.info').writeAsString(FolderInfo.toJsonString(info));
  }

  // TODO: Complete the functionality of belowing API
  Future<dynamic> updateFolderInfoFile({@required String path}) async {}
}

extension SubFoldersInfoesExtension on FileService {
  static List<FolderInfo> _rootPathSubFoldersInfoes;
  static List<FolderInfo> _currentPathSubFoldersInfoes;

  List<FolderInfo> get rootPathSubFoldersInfoes => _rootPathSubFoldersInfoes;

  List<FolderInfo> get currentPathSubFoldersInfoes => _currentPathSubFoldersInfoes;

  set rootPathSubFoldersInfoes(List<FolderInfo> infoes) {
    _rootPathSubFoldersInfoes = infoes;
    notifyListeners();
  }

  set currentPathSubFoldersInfoes(List<FolderInfo> infoes) {
    _currentPathSubFoldersInfoes = infoes;
    notifyListeners();
  }

  Future<List<FolderInfo>> updateRootPathSubFoldersInfoes() async {
    rootPathSubFoldersInfoes = await this._listSubFolersInfoes(rootPath);
    return _rootPathSubFoldersInfoes;
  }

  Future<List<FolderInfo>> updateCurrentPathSubFoldersInfoes() async {
    currentPathSubFoldersInfoes = await this._listSubFolersInfoes(currentPath);
    return _currentPathSubFoldersInfoes;
  }

  /// Collect information from all the `.info` files of sub-directories'
  /// of the given path which defaluts to the current working directory
  Future<List<FolderInfo>> _listSubFolersInfoes(String path) async {
    assert(path != null, 'path should not be null');
    print('Listing sub-folder infos in path: \n$path');
    final List<Directory> subFolers = await this._listFolders(path);
    List<FolderInfo> infoes = [];
    await Future.forEach(subFolers, (Directory subFolder) async {
      FolderInfo subFolderInfo = await this.getFolerInfo(path: subFolder.path);
      infoes.add(subFolderInfo);
    });
    return infoes;
  }
}

extension VideoFilesExtension on FileService {
  static List<File> _rootPathVideoFiles;
  static List<File> _currentPathVideoFiles;

  List<File> get rootPathVideoFiles => _rootPathVideoFiles;

  List<File> get currentPathVideoFiles => _currentPathVideoFiles;
}

extension VideosInfoesExtension on FileService {
  static List<VideoInfo> _rootPathVideoesInfoes = [];
  static List<VideoInfo> _currentPathVideosInfoes = [];

  List<VideoInfo> get rootPathVideoesInfoes => _rootPathVideoesInfoes;

  List<VideoInfo> get currentPathVideosInfoes => _currentPathVideosInfoes;

  Future<bool> isVideosInfoFileExists({String path}) async {
    return await this._isFileExists(fileBaseName: '.videos_infoes', path: path);
  }

  // TODO: Complete the functionality of belowing API
  Future<void> createVideosInfoesFile() async {}

  // TODO: Complete the functionality of belowing API
  Future<List<VideoInfo>> getVideosInfoes() async {
    List<VideoInfo> info = <VideoInfo>[];
    return info;
  }

  // TODO: Complete the functionality of belowing API
  Future<dynamic> updateVideoInfoFile() {}
}

extension FileServiceUtilsExtension on FileSystemEntity {
  /// Getter method
  ///
  /// Extract a file name from object of [FileSystemEntity]
  String get baseName {
    String baseName = this.path.split('/').last;
    return baseName;
  }
}

extension FilePathUtilsExtension on String {
  /// **Async** getter
  ///
  /// Returns `true` if given path can resolve a directory
  Future<bool> get isDirectory async {
    // if (path == null) path = '$_path/test/';
    final bool isDirectory = await FileSystemEntity.isDirectory(this);
    return isDirectory;
  }

  /// **Async** getter
  ///
  /// Returns `true` if given path can resolve a file
  Future<bool> get isFile async {
    // if (path == null) path = '$_path/test/';
    final bool isFile = await FileSystemEntity.isFile(this);
    // print(isFile);
    return isFile;
  }

  /// Returns a [File] from a given <String>path
  ///
  /// on iOS it converts a path from the file's uri to avoid files
  /// whose names contains spaces could not be found
  File get getFile {
    final File file = File(this);
    String uriPath = file.uri.toString().substring(7); // take out 'file://'
    return File(uriPath);
  }

  /// Getter method
  ///
  /// Extract file name from file's path String
  String get baseName {
    String baseName = this.split('/').last;
    return baseName;
  }
}

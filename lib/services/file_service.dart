import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/models/dot_local.dart';
import 'package:app/extensions/file_extension.dart';

/// A helper class to easily manage files inside app directory
///
///     FileService.init() function should be called at app launch
class FileService {
  static String _path;

  static String _currentPath;

  /// Returns a [File] from a given path
  ///
  /// on iOS it converts a path from the file's uri
  /// to avoid files whose names contains spaces could not be found
  static File getFile(String path) {
    final File file = File(path);
    String uriPath = file.uri.toString().substring(7); // take out 'file://'
    return File(uriPath);
  }

  static Future<void> init() async {
    if (_path != null) return;
    _path = (await getApplicationDocumentsDirectory()).path;
    _currentPath ??= _path; // if _currentDirecetory is null, set it equal to _path
  }

  /// Make sure `FileService.init()` has been called before using this method.
  static String get getPathSync => _path;

  FileService() {
    if (_path == null) setPath();
  }

  Future<String> get getPath async {
    if (_path != null) return _path;
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> setPath() async => _path = await getPath;

  String get currentPath => _currentPath;

  set currentPath(String directory) => _currentPath = '$_currentPath/$directory';

  Future<List<FileSystemEntity>> get listFiles async {
    if (_path == null) _path = await getPath;
    List<FileSystemEntity> fileList = Directory("$_path/").listSync();
    for (FileSystemEntity file in fileList) {
      bool isDirectory = await FileSystemEntity.isDirectory(file.path);
      print("${file.baseName} - ${isDirectory ? "directory" : "file"}");
    }
    return fileList;
  }

  Future<List<Directory>> get listDirectories async {
    List<Directory> directories = <Directory>[];
    if (_path == null) _path = await getPath;
    List<FileSystemEntity> fileList = Directory("$_path/").listSync();
    await Future.forEach(fileList, (FileSystemEntity file) async {
      bool isDirectoy = await file.path.isDirectory;
      if (isDirectoy) directories.add(file);
    });
    for (Directory dir in directories) print("${dir.baseName}");
    return directories;
  }

  /// Create a directory, default name to `'untitled' + incremental suffix`
  /// (eg. untitled 2) if name is not provided
  Future<Directory> createDirectory({@required String name, String path}) async {
    if (path == null) path = await getPath;
    List<String> dirBaseNames = (await listDirectories).map((directory) => directory.baseName).toList();
    // regular express for a string that is 'untitled' or 'untitled\s\d+'
    final RegExp untitledRegExp = RegExp(r'^untitled(\s\d+$)?');
    List<String> untitledDirBaseNames = dirBaseNames.where((name) => untitledRegExp.hasMatch("$name")).toList();

    if (name == null) {
      if (untitledDirBaseNames.isEmpty) {
        name = "untitled";
      } else if (untitledDirBaseNames.length == 1 && untitledDirBaseNames[0] == 'untitled') {
        name = "untitled 2";
      } else {
        int maxUntitledDirNum = untitledDirBaseNames
            .where((String name) => name != 'untitled')
            .map((String name) => int.parse(name.replaceAll(new RegExp(r'[^0-9]'), '')))
            .reduce(max);
        String suffix = (maxUntitledDirNum + 1).toString();
        name = "untitled $suffix";
      }
    }

    String dirPath = "$path/$name";
    Directory newDir = await Directory(dirPath).create();
    return newDir;
  }

  Future<bool> isDotLocalExists({String path}) async {
    path = path ?? _currentPath ?? _path;
    bool exists = await File('$path/.local').exists();
    // print(exists);
    return exists;
  }

  Future<void> createDotLocalFile(
    String path, {
    bool isPrivate = false,
    String password,
    String iconName,
  }) async {
    path = path ?? '$_path/test/';
    DotLocal info = DotLocal(
      iconName: iconName,
      password: password,
      isPrivate: isPrivate,
    );
    await File('$path/.local').writeAsString(DotLocal.toJsonString(info));
  }

  /// Collet information from `.local` file
  Future<DotLocal> getLocalInfo({String path}) async {
    path = path ?? _currentPath ?? _path;
    File file = File('$_path/test/.local');
    String contents = await file.readAsString();
    DotLocal info = DotLocal.fromJsonString(contents);
    return info;
  }

  // TODO:

  /// Collect information from all the `.local` files of sub-directories'
  /// of the given path which defaluts to the current working directory
  Future<List> collectSubDirectoryInfo({String path}) {
    path ??= _currentPath; // default path is the current working directory
  }
}

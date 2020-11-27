import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// A helper class to easily manage files inside app directory
///
///     FileService.init() function should be called at app launch
class FileService {
  static String _path;

  /// Returns a [File] from a given path
  ///
  /// on iOS it converts a path from the file's uri
  /// to avoid files whose names contains spaces could not be found
  static File getFile(String path) {
    final File file = File(path);
    String uriPath = file.uri.toString().substring(7); // take out 'file://'
    return File(uriPath);
  }

  FileService() {
    if (_path == null) setPath();
  }

  static Future<void> init() async {
    if (_path != null) return;
    final Directory directory = await getApplicationDocumentsDirectory();
    _path = directory.path;
  }

  /// Make sure `FileService.init()` has been called before using this method.
  static String get getPathSync => _path;

  Future<String> get getPath async {
    if (_path != null) return _path;
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> setPath() async => _path = await getPath;

  Future<List<FileSystemEntity>> get listOfFiles async {
    if (_path == null) _path = await getPath;
    print(_path);
    List<FileSystemEntity> fileLists = Directory("$_path/").listSync();
    print(fileLists);
    return fileLists;
  }
}

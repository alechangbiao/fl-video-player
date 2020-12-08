import 'dart:io';

extension FileExtension on FileSystemEntity {
  /// Getter method
  ///
  /// Extract file name from file's path String
  String get baseName {
    String baseName = this.path.split('/').last;
    return baseName;
  }
}

extension FilePathExtension on String {
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
}

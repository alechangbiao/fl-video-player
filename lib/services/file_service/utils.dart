part of 'package:app/services/file_service/file_service.dart';

extension FileSystemEntityUtilsExtension on FileSystemEntity {
  /// Getter method
  ///
  /// Extract a file name from object of [FileSystemEntity]
  String get baseName {
    String baseName = this.path.split('/').last;
    return baseName;
  }

  /// getter method
  ///
  /// Returns `true` if given FileSystemEntity is a video file
  bool get isVideo {
    return this.path.isVideo;
  }
}

extension FileExtension on File {
  /// getter method
  ///
  /// Returns the extension of the file in string
  String get suffix {
    String suffix = this.baseName.split('.').last;
    return suffix;
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

  /// getter method
  ///
  /// Returns `true` if given path can resolve a video file
  bool get isVideo {
    final fileType = this.baseName.split('.').last;
    return SupportedVideoTypes.contains(fileType);
  }

  bool get isVideoMime {
    final String? mimeString = lookupMimeType(this);
    if (mimeString == null) return false;
    final String type = mimeString.split('/')[0];
    return type == 'video';
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
  /// Extract file name with its suffix from file's path String
  String get baseName {
    String baseName = this.split('/').last;
    return baseName;
  }

  /// Getter method
  ///
  /// Extract file name without its suffix from file's path String
  String get fileName {
    List<String> baseNameSplitted = this.baseName.split('.');
    baseNameSplitted.removeLast();
    String parentPath = baseNameSplitted.join('.');
    return parentPath;
  }

  /// getter method
  ///
  /// Returns the extension of the file from it's path string
  String get suffix {
    String suffix = this.baseName.split('.').last;
    return suffix;
  }

  /// Getter method
  ///
  /// Get the parent path of the given <String>path
  String get parentPath {
    List<String> filePathList = this.split('/');
    filePathList.removeLast();
    String parentPath = filePathList.join('/');
    return parentPath;
  }
}

// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: invalid_use_of_visible_for_testing_member

part of 'package:app/services/file_service/file_service.dart';

extension VideoFilesExtension on FileService {
  static List<File>? _rootPathVideoFiles = [];
  static List<File>? _currentPathVideoFiles = [];

  List<File>? get rootPathVideoFiles => _rootPathVideoFiles;
  List<File>? get currentPathVideoFiles => _currentPathVideoFiles;

  set rootPathVideoFiles(List<File>? videoFiles) {
    _rootPathVideoFiles = videoFiles;
    notifyListeners();
  }

  set currentPathVideoFiles(List<File>? videoFiles) {
    _currentPathVideoFiles = videoFiles;
    notifyListeners();
  }

  /// List out the `List<File> videoFileList` in the root path
  ///
  /// Returns an empty list `<File>[]` if found none
  Future<List<File>> getRootPathVideosList() async {
    rootPathVideoFiles = await _listVideos(rootPath);
    return rootPathVideoFiles!;
  }

  /// List out the `List<File> videoFileList` in the current path
  ///
  /// returns an empty list `<File>[]` if found none
  Future<List<File>> getCurrentPathVideosList() async {
    currentPathVideoFiles = await _listVideos(currentPath);
    return currentPathVideoFiles!;
  }

  /// List out the `List<File> videoFileList` in the given directory
  ///
  /// returns an empty list `<File>[]` if found none
  Future<List<File>> _listVideos(path) async {
    assert(path != null, 'path should not be null');
    rootPath ?? await setPaths();

    List<File> videos = <File>[];
    List<FileSystemEntity> files = Directory("$path/").listSync();
    files.forEach((FileSystemEntity file) {
      if (file.isVideo) videos.add(file as File);
    });
    for (File video in videos) {
      print(video.path);
    }
    return videos;
  }
}

extension VideosInfoExtension on FileService {
  static List<VideoInfo> _rootPathVideosInfo = [];
  static List<VideoInfo> _currentPathVideosInfo = [];

  List<VideoInfo> get rootPathVideosInfo => _rootPathVideosInfo;
  List<VideoInfo> get currentPathVideosInfo => _currentPathVideosInfo;

  set rootPathVideosInfo(List<VideoInfo> videosInfo) {
    _rootPathVideosInfo = videosInfo;
    notifyListeners();
  }

  set currentPathVideosInfo(List<VideoInfo> videosInfo) {
    _currentPathVideosInfo = videosInfo;
    notifyListeners();
  }

  Future<bool> isVideosInfoFileExists({String? path, bool testing = false}) async {
    bool exist = await this._isFileExists(
      fileBaseName: '.videos_info',
      path: path,
      testing: testing,
    );
    print('.videos_info file exists: $exist');
    return exist;
  }

  Future<List<VideoInfo>> getVideosInfo({@required String? path, bool testing = false}) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    bool fileExists = await _isFileExists(fileBaseName: '.videos_info', path: path);

    if (!fileExists) {
      print('.videos_info not found in $path \n creating a new file...');
      await createVideosInfoFile(path: path, testing: testing);
    } else {
      print('Found .videos_info in <${path?.baseName}>');
    }

    String jsonContent = await File('$path/.videos_info').readAsString();
    print('JSON String content: $jsonContent');
    List<VideoInfo> infos = VideoInfo.fromJsonString(jsonContent);
    for (VideoInfo info in infos) {
      print('''
            name:${info.name}, 
            id:${info.id}, 
            createdAt:${info.createdAt}, 
            timeMs:${info.timeMs}, 
            durationMs:${info.durationMs},
            lastWatchedAt:${info.lastWatchedAt}
            ''');
    }
    return infos;
  }

  Future<File> createVideosInfoFile({@required String? path, bool testing = false}) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    List<File> videoFiles;
    List<VideoInfo> videoInfoList = <VideoInfo>[];

    // videoFiles = await _listVideos(path);
    if (testing) {
      videoFiles = await _listVideos(path);
    } else if (path == rootPath) {
      videoFiles = rootPathVideoFiles ?? await getRootPathVideosList();
    } else {
      videoFiles = currentPathVideoFiles ?? await getCurrentPathVideosList();
    }

    print(videoFiles.length);

    if (videoFiles.isNotEmpty) {
      await Future.forEach(videoFiles, (FileSystemEntity videoFile) async {
        String videoFilePath = videoFile.path;
        int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
        int? durationMs = (await FlutterVideoInfo().getVideoInfo(videoFilePath))?.duration?.round();
        VideoInfo info = VideoInfo(
          id: randomAlpha(6),
          name: videoFilePath.baseName,
          durationMs: durationMs,
          createdAt: nowTimeStamp,
          lastModifiedAt: nowTimeStamp,
        );
        videoInfoList.add(info);
      });
    }
    return await File('$path/.videos_info').writeAsString(VideoInfo.toJsonString(videoInfoList));
  }

  Future<File?> updateCurrentPathVideoInfoFile({
    required String id,
    String? name,
    int? timeMs,
    int? durationMs,
    int? lastWatchedAt,
    bool testing = false,
  }) async {
    print("FileService.updateCurrentPathVideoInfoFile get called");
    File? videoInfoFile = await this._updateVideosInfoFile(
      path: currentPath,
      id: id,
      name: name,
      timeMs: timeMs,
      durationMs: durationMs,
      lastWatchedAt: lastWatchedAt,
      testing: testing,
    );
    return videoInfoFile;
  }

  Future<File?> updateRootPathVideoInfoFile({
    required String id,
    String? name,
    int? timeMs,
    int? durationMs,
    int? lastWatchedAt,
  }) async {
    print("FileService.updateRootPathVideoInfoFile get called");
    File? videoInfoFile = await this._updateVideosInfoFile(
      path: rootPath,
      id: id,
      name: name,
      timeMs: timeMs,
      durationMs: durationMs,
      lastWatchedAt: lastWatchedAt,
    );
    return videoInfoFile;
  }

  Future<File?> _updateVideosInfoFile({
    @required String? path,
    required String id,
    String? name,
    int? timeMs,
    int? durationMs,
    int? lastWatchedAt,
    bool testing = false,
  }) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    if (name == null && timeMs == null && durationMs == null && lastWatchedAt == null) return null;
    List<VideoInfo> videoInfoList = await this.getVideosInfo(path: path);
    List<VideoInfo> newList = videoInfoList.map((VideoInfo info) {
      if (id == info.id) {
        VideoInfo newInfo = info;
        if (name != null) newInfo.name = name;
        if (timeMs != null) newInfo.timeMs = timeMs;
        if (durationMs != null) newInfo.durationMs = durationMs;
        if (lastWatchedAt != null) newInfo.lastWatchedAt = lastWatchedAt;
        int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
        newInfo.lastModifiedAt = nowTimeStamp;
        return newInfo;
      } else {
        return info;
      }
    }).toList();
    return await File('$path/.videos_info').writeAsString(VideoInfo.toJsonString(newList));
  }
}

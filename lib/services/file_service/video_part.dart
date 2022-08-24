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
  Future<List<File>> getRootPathVideosList({bool notify = false}) async {
    // print("getRootPathVideosList called");
    List<File> videos = await _listVideos(rootPath);
    notify ? rootPathVideoFiles = videos : _rootPathVideoFiles = videos;
    return rootPathVideoFiles!;
  }

  /// List out the `List<File> videoFileList` in the current path
  ///
  /// returns an empty list `<File>[]` if found none
  Future<List<File>> getCurrentPathVideosList({bool notify = false}) async {
    List<File> videos = await _listVideos(rootPath);
    notify ? currentPathVideoFiles = videos : _currentPathVideoFiles = videos;
    return currentPathVideoFiles!;
  }

  Future<List<File>> updateVideosListAsync({required bool isRootPath, bool notify = true}) async {
    return isRootPath
        ? await getRootPathVideosList(notify: notify)
        : await getCurrentPathVideosList(notify: notify);
  }

  Future<List<File>> selectVideosListAsync({required bool isRootPath}) async {
    return isRootPath
        ? await getRootPathVideosList(notify: false)
        : await getCurrentPathVideosList(notify: false);
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
      fileBaseName: VideoInfo.fileName,
      path: path,
      testing: testing,
    );
    print('${VideoInfo.fileName} file exists: $exist');
    return exist;
  }

  Future<List<VideoInfo>> getRootPathVideosInfo({
    bool testing = false,
    bool notify = false,
  }) async {
    // print("getRootPathVideosInfo called");
    List<VideoInfo> info = await this.getVideosInfo(path: rootPath, testing: testing);
    // notify ? rootPathVideosInfo = info : _rootPathVideosInfo = info;
    rootPathVideosInfo = info;
    return info;
  }

  Future<List<VideoInfo>> updateRootPathVideosInfo({bool testing = false}) async {
    return await this.getRootPathVideosInfo(testing: testing, notify: true);
  }

  Future<List<VideoInfo>> getCurrentPathVideosInfo({
    bool testing = false,
    bool notify = false,
  }) async {
    List<VideoInfo> info = await this.getVideosInfo(path: currentPath, testing: testing);
    notify ? currentPathVideosInfo = info : _currentPathVideosInfo = info;
    return info;
  }

  Future<List<VideoInfo>> updateCurrentPathVideosInfo({bool testing = false}) async {
    return await this.getCurrentPathVideosInfo(testing: testing, notify: true);
  }

  Future<List<VideoInfo>> selectVideosInfoAsync({
    required bool isRootPath,
    bool notify = false,
  }) async {
    return isRootPath
        ? await getRootPathVideosInfo(notify: notify)
        : await getCurrentPathVideosInfo(notify: notify);
  }

  Future<List<VideoInfo>> getVideosInfo({@required String? path, bool testing = false}) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    if (this.isRootPath(path)) {
      if (_rootPathVideosInfo.length > 0) return _rootPathVideosInfo;
    }
    if (this.isCurrentPath(path)) {
      if (_currentPathVideosInfo.length > 0) return _currentPathVideosInfo;
    }

    bool fileExists = await _isFileExists(fileBaseName: VideoInfo.fileName, path: path);
    List<VideoInfo> infos;
    if (!fileExists) {
      print('.videos_info not found in $path \n creating a new file...');
      File videosInfoFile = await this.createVideosInfoFile(path: path, testing: testing);
      String jsonContent = await videosInfoFile.readAsString();
      infos = VideoInfo.fromJsonString(jsonContent);
    } else {
      print('Found .videos_info in <${path?.baseName}>');
      String jsonContent = await File('$path/.videos_info').readAsString();
      infos = VideoInfo.fromJsonString(jsonContent);
      List<String> videoNamesInInfoList = infos.map((VideoInfo info) => info.name).toList();
      List<File> videoFiles = await _listVideos(path);

      // check if .video_info contains each video's info
      await Future.forEach(videoFiles, (File videoFile) async {
        if (!videoNamesInInfoList.contains(videoFile.baseName)) {
          VideoInfo newInfo = await VideoInfo.create(video: videoFile);
          infos.add(newInfo);
        }
      });
      await File('$path/.videos_info').writeAsString(VideoInfo.toJsonString(infos));
    }
    return infos;
  }

  Future<File> createVideosInfoFile({@required String? path, bool testing = false}) async {
    bool isRootPath = this.isRootPath(path);
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    List<File> videoFiles = testing
        ? await _listVideos(path)
        : await this.selectVideosListAsync(isRootPath: isRootPath);
    print(videoFiles.length);
    List<VideoInfo> videoInfoList = await VideoInfo.createList(videos: videoFiles);
    return await File('$path/.videos_info').writeAsString(VideoInfo.toJsonString(videoInfoList));
  }

  Future<File?> updateCurrentPathVideosInfoFile({
    required String id,
    required Map<String, dynamic> updates,
    bool testing = false,
  }) async {
    print("FileService.updateCurrentPathVideoInfoFile get called");
    File? videoInfoFile = await this._updateVideosInfoFile(
      path: currentPath,
      id: id,
      updates: updates,
      testing: testing,
    );
    await this.updateCurrentPathVideosInfo(); // update _rootPathVideosInfo & notify
    return videoInfoFile;
  }

  Future<File?> updateRootPathVideosInfoFile({
    required String id,
    required Map<String, dynamic> updates,
    bool testing = false,
  }) async {
    print("FileService.updateRootPathVideoInfoFile get called");
    File? videoInfoFile = await this._updateVideosInfoFile(
      path: rootPath,
      id: id,
      updates: updates,
      testing: testing,
    );
    await this.updateRootPathVideosInfo(); // update _rootPathVideosInfo & notify
    return videoInfoFile;
  }

  Future<File?> updateVideosInfoFileInPath(
    String path, {
    required String id,
    required Map<String, dynamic> updates,
    bool testing = false,
  }) async {
    print("FileService.updateVideosInfoFileInPath get called");
    File? videoInfoFile = await this._updateVideosInfoFile(
      path: path,
      id: id,
      updates: updates,
      testing: testing,
    );
    return videoInfoFile;
  }

  Future<File?> _updateVideosInfoFile({
    @required String? path,
    required String id,
    required Map<String, dynamic> updates,
    bool testing = false,
  }) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    if (updates.length == 0) return null;
    List<VideoInfo> videoInfoList = await this.getVideosInfo(path: path);
    List<VideoInfo> newList = videoInfoList.map((VideoInfo info) {
      if (id == info.id) info.update(updates: updates);
      return info;
    }).toList();
    return await File('$path/${VideoInfo.fileName}').writeAsString(VideoInfo.toJsonString(newList));
  }

  Future<File?> deleteInfoByIdFromVideosInfoFile({
    required String path,
    required String videoId,
  }) async {
    List<VideoInfo> videoInfoList = await this.getVideosInfo(path: path);
    List<VideoInfo> newList = VideoInfo.deleteById(infos: videoInfoList, videoId: videoId);
    return await File('$path/${VideoInfo.fileName}').writeAsString(VideoInfo.toJsonString(newList));
  }

  Future<File?> addInfoIntoVideosInfoFile({
    required String path,
    required VideoInfo info,
    bool updateLastModifiedTimestamp = true,
  }) async {
    List<VideoInfo> infos = await this.getVideosInfo(path: path);
    if (updateLastModifiedTimestamp) info.lastModifiedAt = DateTime.now().millisecondsSinceEpoch;
    infos.add(info);
    return await File('$path/${VideoInfo.fileName}').writeAsString(VideoInfo.toJsonString(infos));
  }

  Future<VideoInfo?> getVideoInfoFromVideosInfoFile({required String videoPath}) async {
    List<VideoInfo> videoInfoList = await this.getVideosInfo(path: videoPath.parentPath);
    return videoInfoList.firstWhere((VideoInfo e) => e.name == videoPath.baseName);
  }

  /// Moving a file to a new path
  ///
  /// Using rename as it is probably faster.
  /// If rename fails, copy the source file and then delete it
  Future<void> moveVideo({required String videoPath, required String targetPath}) async {
    assert(videoPath.isVideo, "chosen file has to be a video file");
    String folderPath = videoPath.parentPath;
    VideoInfo? videoInfo = await getVideoInfoFromVideosInfoFile(videoPath: videoPath);
    File video = File(videoPath);
    try {
      await video.rename('$targetPath/${video.baseName}');
    } on FileSystemException catch (e) {
      print(e);
      await video.copy('$targetPath/${video.baseName}');
      await video.delete();
    }
    if (videoInfo != null) {
      await Future.wait([
        this.deleteInfoByIdFromVideosInfoFile(path: video.parent.path, videoId: videoInfo.id),
        this.addInfoIntoVideosInfoFile(path: targetPath, info: videoInfo),
      ]);
    }
    await this.updateVideosListAsync(isRootPath: isRootPath(folderPath));
  }

  //TODO: complete the belowing API
  Future<void> moveVideoToTrash({required String videoPath}) async {
    try {
      await this.moveVideo(videoPath: videoPath, targetPath: trashFolderPath);
    } catch (e) {
      print(e);
    }
    // update .trash_info
    // update trash folder .info
  }

  Future<void> renameVideo({required String videoPath, required String newName}) async {
    assert(videoPath.isVideo, "chosen file has to be a video file");
    //TODO: check new name regular expression
    String folderPath = videoPath.parentPath;
    List<VideoInfo> infos = await this.selectVideosInfoAsync(isRootPath: isRootPath(folderPath));
    String videoId = infos.firstWhere((VideoInfo e) => e.name == videoPath.baseName).id;
    File videoFile = File(videoPath);
    try {
      await videoFile.rename('$folderPath/$newName.${videoPath.suffix}');
      await this.updateVideosInfoFileInPath(
        folderPath,
        id: videoId,
        updates: {VideoInfoKey.name: '$newName.${videoPath.suffix}'},
      );
      await this.updateVideosListAsync(isRootPath: isRootPath(folderPath), notify: false);
      await this.updateFolderInfoFileInPath(folderPath, notify: true);
    } catch (e) {
      print(e);
    }
  }
}

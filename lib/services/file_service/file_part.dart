// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: invalid_use_of_visible_for_testing_member

part of 'package:app/services/file_service/file_service.dart';

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
    //TODO: Check if .trash & .default_private directories exists
    return _rootPathFolders;
  }

  /// Force update `_rootPathFolders`
  ///
  /// Empty the list first then infate it with updated data
  Future<List<Directory>> reloadRootPathFoldersList() async {
    rootPathFolders = <Directory>[];
    // a short delay (200 milliseconds) to ensure listeners emptying list taken effect
    Future.delayed(const Duration(milliseconds: 200), () async {
      rootPathFolders = await _listFolders(rootPath);
    });
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
      if (isDirectoy) folers.add(file as Directory);
    });
    // for (Directory foler in folers) print("${foler.baseName}");
    return folers;
  }
}

/// `FolderInfo` Service
///
/// Helper Methods on folderInfo object related tasks
extension FolderInfoExtension on FileService {
  static FolderInfo? _rootPathFolerInfo;
  static FolderInfo? _currentPathFolerInfo;

  FolderInfo? get rootPathFolerInfo => _rootPathFolerInfo;
  FolderInfo? get currentPathFolerInfo => _currentPathFolerInfo;

  set rootPathFolerInfo(FolderInfo? info) {
    _rootPathFolerInfo = info;
    notifyListeners();
  }

  set currentPathFolerInfo(FolderInfo? info) {
    _currentPathFolerInfo = info;
    notifyListeners();
  }

  Future<bool> isFolderInfoFileExists({String? path, bool testing = false}) async {
    return await this._isFileExists(fileBaseName: '.info', path: path, testing: testing);
  }

  Future<FolderInfo?> getRootPathFolderInfo({bool testing = false}) async {
    FolderInfo? info = await this.getFolderInfo(path: rootPath, testing: testing);
    rootPathFolerInfo = info;
    return info;
  }

  Future<FolderInfo?> getCurrentPathFolderInfo({bool testing = false}) async {
    FolderInfo? info = await this.getFolderInfo(path: currentPath, testing: testing);
    currentPathFolerInfo = info;
    return info;
  }

  /// Collet information from `.info` file
  ///
  /// Create a new `.info` file if coundn't find any in the path
  Future<FolderInfo?> getFolderInfo({@required String? path, bool testing = false}) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    bool fileExists = await _isFileExists(fileBaseName: '.info', path: path);
    if (fileExists) {
      String jsonContent = await File('$path/.info').readAsString();
      // print('Found .info in "${path.baseName}": $jsonContent');
      FolderInfo info = FolderInfo.fromJsonString(jsonContent);
      return info;
    } else {
      // print('.info not found in $path \n creating a new file...');
      FolderInfo info = this.createFolderInfo(path: path);
      File file = await this.createFolderInfoFile(path: path, testing: testing, folderInfo: info);
      return info;
      // String jsonContent = await file.readAsString();
      // // print(jsonContent);
      // return FolderInfo.fromJsonString(jsonContent);
    }
  }

  FolderInfo createFolderInfo({
    @required String? path,
    bool isPrivate = false,
    String? password,
    String? iconName,
  }) {
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    return FolderInfo(
      id: randomAlpha(6),
      name: path!.baseName,
      password: password,
      iconName: iconName,
      isPrivate: isPrivate,
      createdAt: nowTimeStamp,
      lastModifiedAt: nowTimeStamp,
    );
  }

  /// Create an object of [FolderInfo] and save it in `.info` file as JSON String
  Future<File> createFolderInfoFile({
    @required String? path,
    bool isPrivate = false,
    String? password,
    String? iconName,
    bool testing = false,
    FolderInfo? folderInfo,
  }) async {
    path = testing ? '$rootPath/test' : path ?? currentPath ?? rootPath;
    if (folderInfo != null) {
      return await File('$path/.info').writeAsString(FolderInfo.toJsonString(folderInfo));
    }
    FolderInfo info = createFolderInfo(
      path: path,
      isPrivate: isPrivate,
      password: password,
      iconName: iconName,
    );
    return await File('$path/.info').writeAsString(FolderInfo.toJsonString(info));
  }

  Future<File?> updateRootPathFolderInfoFile({
    String? name,
    String? password,
    String? iconName,
    bool? isPrivate,
    String? sequence,
    String? layout,
  }) async {
    print("FileService.updateRootPathFolderInfoFile get called");
    File? infoFile = await this._updateFolderInfoFile(
      path: rootPath,
      name: name,
      password: password,
      iconName: iconName,
      isPrivate: isPrivate,
      sequence: sequence,
      layout: layout,
    );
    await this.getRootPathFolderInfo();
    return infoFile;
  }

  Future<File?> updateCurrentPathFolderInfoFile({
    String? name,
    String? password,
    String? iconName,
    bool? isPrivate,
    String? sequence,
    String? layout,
  }) async {
    print("FileService.updateCurrentPathFolderInfoFile get called");
    File? infoFile = await this._updateFolderInfoFile(
      path: currentPath,
      name: name,
      password: password,
      iconName: iconName,
      isPrivate: isPrivate,
      sequence: sequence,
      layout: layout,
    );
    await this.getCurrentPathFolderInfo();
    return infoFile;
  }

  Future<File?> _updateFolderInfoFile({
    @required String? path,
    String? name,
    String? password,
    String? iconName,
    bool? isPrivate,
    String? sequence,
    String? layout,
  }) async {
    if (name == null &&
        password == null &&
        iconName == null &&
        isPrivate == null &&
        sequence == null &&
        layout == null) return null;
    FolderInfo? info = await this.getFolderInfo(path: path);
    if (name != null) info!.name = name;
    if (password != null) info!.password = password;
    if (iconName != null) info!.iconName = iconName;
    if (isPrivate != null) info!.isPrivate = isPrivate;
    if (sequence != null) info!.sequence = sequence;
    if (layout != null) info!.layout = layout;
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    info!.lastModifiedAt = nowTimeStamp;
    return await File('$path/.info').writeAsString(FolderInfo.toJsonString(info));
  }
}

extension SubFoldersInfoesExtension on FileService {
  static List<FolderInfo>? _rootPathSubFoldersInfoes;
  static List<FolderInfo>? _currentPathSubFoldersInfoes;

  List<FolderInfo>? get rootPathSubFoldersInfoes => _rootPathSubFoldersInfoes;

  List<FolderInfo>? get currentPathSubFoldersInfoes => _currentPathSubFoldersInfoes;

  set rootPathSubFoldersInfoes(List<FolderInfo>? infoes) {
    _rootPathSubFoldersInfoes = infoes;
    notifyListeners();
  }

  set currentPathSubFoldersInfoes(List<FolderInfo>? infoes) {
    _currentPathSubFoldersInfoes = infoes;
    notifyListeners();
  }

  Future<List<FolderInfo>?> updateRootPathSubFoldersInfoes() async {
    rootPathSubFoldersInfoes = await this._listSubFolersInfoes(rootPath);
    return _rootPathSubFoldersInfoes;
  }

  Future<List<FolderInfo>?> updateCurrentPathSubFoldersInfoes() async {
    currentPathSubFoldersInfoes = await this._listSubFolersInfoes(currentPath);
    return _currentPathSubFoldersInfoes;
  }

  /// Collect information from all the `.info` files of sub-directories'
  /// of the given path which defaluts to the current working directory
  Future<List<FolderInfo>> _listSubFolersInfoes(String? path) async {
    assert(path != null, 'path should not be null');
    print('Listing sub-folder infos in path: \n$path');
    final List<Directory> subFolers = await this._listFolders(path);
    List<FolderInfo> infoes = [];
    await Future.forEach(subFolers, (Directory subFolder) async {
      FolderInfo? subFolderInfo = await this.getFolderInfo(path: subFolder.path);
      infoes.add(subFolderInfo!);
    });
    return infoes;
  }
}

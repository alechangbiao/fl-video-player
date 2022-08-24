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

  static const String _trashFolderName = '.Trash';
  static const String _defaultPrivateFolderName = '.Private';

  String get defaultPrivateFolderName => _defaultPrivateFolderName;
  static String get defaultPrivateFolderNameStatic => _defaultPrivateFolderName;
  String get defaultPrivateFolderPath => "${this.rootPath}/$_defaultPrivateFolderName";

  set rootPathFolders(List<Directory> folders) {
    _rootPathFolders = folders;
    notifyListeners();
  }

  set currentPathFolders(List<Directory> folders) {
    _currentPathFolders = folders;
    notifyListeners();
  }

  Future<List<Directory>> updateRootPathFoldersList() async {
    // print("updateRootPathFoldersList called");
    List<Directory> _folders = await _listFolders(rootPath);
    List<String> _folderNames = _folders.map((Directory folder) => folder.path.baseName).toList();
    // if .Trash does not exist, create it and add it to _folders
    if (!_folderNames.contains(trashFolderName)) {
      print("couldn't find $trashFolderName in root directory");
      Directory trashFolder = await this.createTrashFolder();
      _folders.add(trashFolder);
    }
    // if .Private does not exist, create it and add it to _folders
    if (!_folderNames.contains(defaultPrivateFolderName)) {
      print("couldn't find $defaultPrivateFolderName in root directory");
      Directory defaultPrivateFolder = await this.createDefaultPrivateFolder();
      _folders.insert(0, defaultPrivateFolder);
    }
    rootPathFolders = _folders;
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

  /// Create a directory, default name to `'untitled' + incremental suffix`
  /// (eg. untitled 2) if name is not provided
  Future<Directory> createFolder({
    required String? name,
    String? path,
    bool isPrivate = false,
    String? iconName,
  }) async {
    FileService._rootPath ?? await setPaths();
    path = path ?? FileService._currentPath ?? FileService._rootPath;

    List<String> dirBaseNames = (await _listFolders(path)).map((e) => e.baseName).toList();
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
    await this.createFolderInfoFile(path: newDirPath, isPrivate: isPrivate, iconName: iconName);
    return newDir;
  }

  Future<Directory> createDefaultPrivateFolder() async {
    FileService._rootPath ?? await setPaths();
    print("creating default private folder - $defaultPrivateFolderName");
    Directory _defaultPrivateFolder = await this.createFolder(
      name: defaultPrivateFolderName,
      isPrivate: true,
    );
    return _defaultPrivateFolder;
  }

  Future<Directory> createTrashFolder() async {
    FileService._rootPath ?? await setPaths();
    print("creating default private folder - $trashFolderName");
    Directory _trashFolder = await this.createFolder(name: trashFolderName);
    return _trashFolder;
  }

  //TODO: compelete the belowing API
  Future<void> moveFolderToTrash({required String folderPath}) async {
    final folder = Directory(folderPath);
    try {
      await this._copyFolder(folder, Directory(trashFolderPath));
      await this._deleteFolder(folderPath: folderPath);
    } catch (e) {
      print(e);
    }
    // update rootPath .info file
    await this.updateRootPathFolderInfoFile();
    //TODO: update .trash_info
  }

  Future<void> _deleteFolder({required String folderPath}) async {
    final folder = Directory(folderPath);
    try {
      await folder.delete(recursive: true);
    } catch (e) {
      print(e);
    }
  }

  //TODO: compelete the belowing API
  Future<void> emptyTrash() async {
    Directory trashFolder = Directory(trashFolderPath);
    await for (FileSystemEntity entity in trashFolder.list()) {
      if (entity.baseName != FolderInfo.fileName && entity.baseName != TrashInfo.fileName) {
        if (entity is Directory) {
          await this._deleteFolder(folderPath: entity.absolute.path);
        }
        if (entity is File) {
          await entity.delete();
        }
      }
    }
    // update .info in trash info
    await this.updateTrashFolderInfoFile();
    //TODO: empty .trash info list
    //TODO: notify listneres
  }

  Future<void> renameFolder({
    required Directory folder,
    required String newName,
    bool notify = false,
  }) async {
    //TODO: check new name regular expression
    String newPath = '${folder.parent.path}/$newName';
    try {
      folder.rename(newPath);
      await this.updateFolderInfoFileInPath(
        newPath,
        updates: {FolderInfoKey.name: newName},
        notify: notify,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _copyFolder(Directory source, Directory destination) async {
    // create folder in destination
    Directory folderInDesination = Directory('${destination.absolute.path}/${source.baseName}');
    await folderInDesination.create();
    // copy files in folder
    await for (FileSystemEntity entity in source.list(recursive: false)) {
      if (entity is Directory) {
        var newDirectory = Directory('${folderInDesination.absolute.path}/${entity.baseName}');
        await newDirectory.create();
        await _copyFolder(entity, newDirectory);
      } else if (entity is File) {
        await entity.copy('${folderInDesination.absolute.path}/${entity.baseName}');
      }
    }
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
  FolderInfo? selectFolderInfo({required bool isRootPath}) {
    return isRootPath ? _rootPathFolerInfo : _currentPathFolerInfo;
  }

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

  Future<FolderInfo?> getRootPathFolderInfo({
    bool notify = true,
    bool testing = false,
  }) async {
    // print("getRootPathFolderInfo called");
    FolderInfo? info = await this.getFolderInfo(path: rootPath, testing: testing);
    notify ? rootPathFolerInfo = info : _rootPathFolerInfo = info;
    return info;
  }

  Future<FolderInfo?> getCurrentPathFolderInfo({
    bool notify = true,
    bool testing = false,
  }) async {
    FolderInfo? info = await this.getFolderInfo(path: currentPath, testing: testing);
    notify ? currentPathFolerInfo = info : _currentPathFolerInfo = info;
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
      FolderInfo info = FolderInfo.create(path: path);
      await this.createFolderInfoFile(path: path, testing: testing, folderInfo: info);
      // File file = await this.createFolderInfoFile(path: path, testing: testing, folderInfo: info);
      // String jsonContent = await file.readAsString();
      // // print(jsonContent);
      // return FolderInfo.fromJsonString(jsonContent);
      return info;
    }
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
    String infoFilePath = '$path/${FolderInfo.fileName}';
    if (folderInfo != null) {
      return await File(infoFilePath).writeAsString(FolderInfo.toJsonString(folderInfo));
    }
    FolderInfo info = FolderInfo.create(
      path: path,
      isPrivate: isPrivate,
      password: password,
      iconName: iconName,
    );
    return await File(infoFilePath).writeAsString(FolderInfo.toJsonString(info));
  }

  /// Update the `.info` file in root directory
  ///
  /// If null was passed in to `Map<String, dynamic>? updates`,
  /// only `lastModifiedAt` gets updated.
  Future<File?> updateRootPathFolderInfoFile({Map<String, dynamic>? updates}) async {
    print("FileService.updateRootPathFolderInfoFile get called");
    File? infoFile = await this._updateFolderInfoFile(path: rootPath, updates: updates);
    await this.getRootPathFolderInfo();
    return infoFile;
  }

  /// Update the `.info` file in current working directory
  ///
  /// If null was passed in to `Map<String, dynamic>? updates`,
  /// only `lastModifiedAt` gets updated.
  Future<File?> updateCurrentPathFolderInfoFile({Map<String, dynamic>? updates}) async {
    print("FileService.updateCurrentPathFolderInfoFile get called");
    File? infoFile = await this._updateFolderInfoFile(path: currentPath, updates: updates);
    await this.getCurrentPathFolderInfo();
    return infoFile;
  }

  /// Update the `.info` file in 'rootPath/.Trash' directory
  ///
  /// If null was passed in to `Map<String, dynamic>? updates`,
  /// only `lastModifiedAt` gets updated.
  Future<File?> updateTrashFolderInfoFile({Map<String, dynamic>? updates}) async {
    print("FileService.updateTrashFolderInfoFile get called");
    File? infoFile = await this._updateFolderInfoFile(path: trashFolderPath, updates: updates);
    await this.getCurrentPathFolderInfo();
    return infoFile;
  }

  /// Update the `.info` file in the directory of `<String>path`
  ///
  /// If null was passed in to `Map<String, dynamic>? updates`,
  /// only `lastModifiedAt` gets updated.
  Future<File?> updateFolderInfoFileInPath(
    String path, {
    Map<String, dynamic>? updates,
    bool notify = false,
  }) async {
    print("FileService.updateFolderInfoFileInPath get called");
    File? infoFile = await this._updateFolderInfoFile(path: path, updates: updates);
    await this.getCurrentPathFolderInfo(notify: notify);
    return infoFile;
  }

  Future<File?> _updateFolderInfoFile({
    @required String? path,
    Map<String, dynamic>? updates,
  }) async {
    FolderInfo? info = await this.getFolderInfo(path: path);
    info!.update(updates: updates);
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

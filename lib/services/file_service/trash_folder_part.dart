// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: invalid_use_of_visible_for_testing_member

part of 'package:app/services/file_service/file_service.dart';

extension TrashFolderExtension on FileService {
  String get trashFolderName => _trashFolderName;
  String get trashFolderPath => "${this.rootPath}/$_trashFolderName";
  String get trashInfoFilePath => "$trashFolderPath/${TrashInfo.fileName}";
}

extension TrashInfoExtension on FileService {
  static List<TrashInfo>? _trashInfo;

  List<TrashInfo>? get trashInfo => _trashInfo;

  set trashInfo(List<TrashInfo>? infos) {
    _trashInfo = infos;
    notifyListeners();
  }

  Future<bool> isTrashInfoFileExists() async {
    bool exist = await this._isFileExists(
      fileBaseName: TrashInfo.fileName,
      path: this.trashFolderPath,
    );
    print('${TrashInfo.fileName} file exists: $exist');
    return exist;
  }

  Future<List<TrashInfo>> getTrashInfo() async {
    bool fileExists = await isTrashInfoFileExists();
    List<TrashInfo> infos;
    if (!fileExists) {
      print('${TrashInfo.fileName} not found, creating a new file...');
      File trashInfoFile = await this.createTrashInfoFile();
      String jsonContent = await trashInfoFile.readAsString();
      infos = TrashInfo.fromJsonString(jsonContent);
    } else {
      print('Found ${TrashInfo.fileName}');
      String jsonContent = await File(trashInfoFilePath).readAsString();
      infos = TrashInfo.fromJsonString(jsonContent);
      List<String> fileNamesInInfoList = infos.map((TrashInfo info) => info.name).toList();
      List<File> filesInTrashFolder = await _listFiles(trashFolderPath) as List<File>
        ..where((File file) =>
            file.baseName != FolderInfo.fileName && file.baseName != TrashInfo.fileName);

      // check if .trash_info file contains each files info
      await Future.forEach(filesInTrashFolder, (File file) async {
        if (!fileNamesInInfoList.contains(file.baseName)) {
          TrashInfo newInfo = await TrashInfo.create(file: file, originalPath: file.path);
          infos.add(newInfo);
        }
      });
      await File(trashInfoFilePath).writeAsString(TrashInfo.toJsonString(infos));
    }
    return infos;
  }

  Future<File> createTrashInfoFile() async {
    List<File> filesInTrashFolder = await _listFiles(trashFolderPath) as List<File>;
    print(filesInTrashFolder.length);
    List<TrashInfo> trashInfoList = await TrashInfo.createList(files: filesInTrashFolder);
    return await File(trashInfoFilePath).writeAsString(TrashInfo.toJsonString(trashInfoList));
  }
}

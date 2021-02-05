import 'package:app/screens/thumbnail_test/thumbnail_test.dart';
import 'package:app/widgets/v2_snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/file_service.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/thumbnail_test/thumbnail_official_demo.dart';

class FoldersStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Resources Stack...');
    return Navigator(
      key: NavigationService.kFoldersStack,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return _renderStack(context);
        },
      ),
    );
  }

  Widget _renderStack(BuildContext context) {
    final _title = Text(
      AppLocalizations.of(context)!.appName,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.headline4?.fontSize,
        color: Colors.orange,
      ),
    );

    final _actionTester = <Widget>[
      ElevatedButton(
        onPressed: () => V2Snackbar.show(context: context),
        child: Text('Try Snack Bar'),
      ),
      ElevatedButton(
        onPressed: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            // title: Text('Title'),
            // message: Text('Message'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Something'),
                isDefaultAction: true,
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Something'),
                isDestructiveAction: true,
              ),
              Container(
                height: 200,
                color: Colors.red,
              )
            ],
          ),
        ),
        child: Text('Try Cupertino Action Sheet'),
      ),
      Divider(),
    ];

    final _pathTester = <Widget>[
      ElevatedButton(
        onPressed: () => FileService.getRootPathSync,
        child: Text('check local path'),
      ),
      ElevatedButton(
        onPressed: () => FileService().goBack(level: 2),
        child: Text('check go back'),
      ),
      Divider(),
    ];

    final _fileDirectoryTester = <Widget>[
      ElevatedButton(
        onPressed: () => FileService().listRootPathFiles(testing: true),
        child: Text('get a list of files'),
      ),
      ElevatedButton(
        onPressed: () => FileService().rootPathFolders,
        child: Text('get a list of directories'),
      ),
      Divider(),
      ElevatedButton(
        onPressed: () => '${FileService.getRootPathSync}/test_new_dir'.isDirectory,
        child: Text('check is directory'),
      ),
      ElevatedButton(
        onPressed: () => '${FileService.getRootPathSync}/test_new_dir'.isFile,
        child: Text('check is file'),
      ),
      Divider(),
      ElevatedButton(
        onPressed: () => FileService().createDirectory(name: null),
        child: Text('create directory'),
      ),
      ElevatedButton(
        onPressed: () {
          // FileService().moveFile(file: null, to: null);
        },
        child: Text('move file'),
      ),
      ElevatedButton(
        onPressed: () {
          // FileService().moveFile(file: null, to: null)
        },
        child: Text('move directory'),
      ),
      Divider(),
    ];

    final _dotInfoTester = <Widget>[
      ElevatedButton(
        onPressed: () => FileService().getRootPathFolderInfo(testing: true),
        child: Text('check .info file'),
      ),
      ElevatedButton(
        onPressed: () => FileService().isFolderInfoFileExists(testing: true),
        child: Text('check .info existance'),
      ),
      ElevatedButton(
        onPressed: () => FileService().createFolerInfoFile(
          path: null,
          testing: true,
        ),
        child: Text('create .info file'),
      ),
      Divider(),
    ];

    final _thumbnailTester = <Widget>[
      ElevatedButton(
        onPressed: () => NavigationService.currentStackState?.push(
          MaterialPageRoute(
            builder: (context) => ThumbnailOfficialDemo(),
          ),
        ),
        child: Text('Thumbnail Demo'),
      ),
      ElevatedButton(
        onPressed: () => NavigationService.currentStackState?.push(
          MaterialPageRoute(
            builder: (context) => ThumbnailTest(),
          ),
        ),
        child: Text('Thumbnail Test'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title,
            Divider(),
            for (Widget i in _actionTester) i,
            for (Widget i in _pathTester) i,
            for (Widget i in _fileDirectoryTester) i,
            for (Widget i in _dotInfoTester) i,
            for (Widget i in _thumbnailTester) i,
          ],
        ),
      ),
    );
  }
}

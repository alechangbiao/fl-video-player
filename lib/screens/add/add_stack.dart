import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/widgets/v2_snakbar.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/services/navigation_service.dart';

import 'package:app/archive/thumbnail_test/thumbnail_official_demo.dart';
import 'package:app/archive/thumbnail_test/thumbnail_test_screen.dart';

class AddStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('Building Add Stack...');
    return Navigator(
      key: NavigationService.kAddStack,
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

    // snackbar and iOS anction sheet
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
        onPressed: () => FileService.getRootPathStatic,
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
        onPressed: () => FileService().listTestingPathFiles(),
        child: Text('get a list of files in Testing Path'),
      ),
      ElevatedButton(
        onPressed: () => FileService().listRootPathFiles(testing: true),
        child: Text('get a list of files in RootPath'),
      ),
      ElevatedButton(
        onPressed: () => FileService().rootPathFolders,
        child: Text('get a list of directories'),
      ),
      Divider(),
      ElevatedButton(
        onPressed: () => '${FileService.getRootPathStatic}/test_new_dir'.isDirectory,
        child: Text('check is directory'),
      ),
      ElevatedButton(
        onPressed: () => '${FileService.getRootPathStatic}/test_new_dir'.isFile,
        child: Text('check is file'),
      ),
      Divider(),
      ElevatedButton(
        onPressed: () => FileService().createFolder(name: ".test_hidden"),
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
        onPressed: () => FileService().getRootPathFolderInfo(/*testing: true*/),
        child: Text('check .info file'),
      ),
      ElevatedButton(
        onPressed: () => FileService().isFolderInfoFileExists(testing: true),
        child: Text('check .info existance'),
      ),
      ElevatedButton(
        onPressed: () => FileService().createFolderInfoFile(
          path: null,
          testing: true,
        ),
        child: Text('create .info file'),
      ),
      Divider(),
    ];

    final _dotVideosInfoTester = <Widget>[
      ElevatedButton(
        onPressed: () => FileService().isVideosInfoFileExists(testing: true),
        child: Text('check .videos_info existance'),
      ),
      ElevatedButton(
        onPressed: () => FileService().getVideosInfo(testing: true, path: null),
        child: Text('check .videos_info info'),
      ),
      ElevatedButton(
        onPressed: () => FileService().createVideosInfoFile(testing: true, path: null),
        child: Text('create .videos_info file'),
      ),
      ElevatedButton(
        onPressed: () => FileService().updateCurrentPathVideosInfoFile(
          id: "xybsrQ",
          updates: {VideoInfoKey.timeMs: 100},
          // timeMs: 100,
          // testing: true,
        ),
        child: Text('update .videos_info file'),
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
            builder: (context) => ThumbnailTestScreen(),
          ),
        ),
        child: Text('Thumbnail Test'),
      ),
    ];

    void _delay() async {
      await await Future.delayed(Duration(seconds: 3));
      print('_delay done!');
    }

    void delay() => _delay();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title,
            Divider(),
            ..._actionTester, // for (Widget i in _actionTester) i
            ..._pathTester,
            ..._fileDirectoryTester,
            ..._dotInfoTester,
            ..._dotVideosInfoTester,
            ..._thumbnailTester,
            Divider(),

            ElevatedButton(onPressed: delay, child: Text('async await test')),
          ],
        ),
      ),
    );
  }
}

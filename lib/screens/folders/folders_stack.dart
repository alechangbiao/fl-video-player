import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:app/services/file_service.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/extensions/file_extension.dart';

class FoldersStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Resources Stack...');
    return Navigator(
      key: NavigationService.kResourcesStack,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return _renderStack(context);
        },
      ),
    );
  }

  Widget _renderStack(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).app_name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4.fontSize,
                color: Colors.orange,
              ),
            ),
            RaisedButton(
              onPressed: () => FileService.getPathSync,
              child: Text('check local path'),
            ),
            RaisedButton(
              onPressed: () => FileService().listFiles,
              child: Text('get a list of files'),
            ),
            RaisedButton(
              onPressed: () => FileService().listDirectories,
              child: Text('get a list of directories'),
            ),
            RaisedButton(
              onPressed: () => FileService().getLocalInfo(),
              child: Text('check .local file'),
            ),
            RaisedButton(
              onPressed: () => FileService().isDotLocalExists(),
              child: Text('check .local existance'),
            ),
            RaisedButton(
              onPressed: () => FileService().createDotLocalFile(null),
              child: Text('create .local file'),
            ),
            RaisedButton(
              onPressed: () => '${FileService.getPathSync}/test_new_dir'.isDirectory,
              child: Text('check is directory'),
            ),
            RaisedButton(
              onPressed: () => '${FileService.getPathSync}/test_new_dir'.isFile,
              child: Text('check is file'),
            ),
          ],
        ),
      ),
    );
  }
}

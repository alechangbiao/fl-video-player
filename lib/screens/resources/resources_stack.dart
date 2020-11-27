import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:app/services/file_service.dart';
import 'package:app/services/navigation_service.dart';

class ResourcesStack extends StatelessWidget {
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
        title: Text('Resources'),
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
              onPressed: () => FileService().listOfFiles,
              child: Text('get a list of files'),
            ),
          ],
        ),
      ),
    );
  }
}

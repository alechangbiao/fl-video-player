import 'package:app/localization/localization.dart';
import 'package:app/screens/videos/components/folder_list.dart';
import 'package:app/screens/videos/components/video_list.dart';
import 'package:flutter/material.dart';
import 'package:app/services/navigation_service.dart';

class VideosStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Videos Stack...');

    return Navigator(
      key: NavigationService.kVideosStack,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return _entryScreen(context);
          },
        );
      },
    );
  }

  Scaffold _entryScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).app_name,
            style: TextStyle(fontSize: Theme.of(context).textTheme.headline4.fontSize, color: Colors.blue),
          ),
          FolderList(),
          Divider(),
          VideoList(),
        ],
      ),
    );
  }
}

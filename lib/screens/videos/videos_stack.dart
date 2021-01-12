import 'package:app/screens/videos/components/app_bar_with_folder_list.dart';
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
          builder: (context) => _entryScreen(context),
        );
      },
    );
  }

  Scaffold _entryScreen(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          AppBarWithFolderList(),
          VideoList(),
          VideoList(),
        ],
      ),
    );
  }
}

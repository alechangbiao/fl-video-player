import 'package:app/screens/folder/folder_screen.dart';
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
          builder: (context) {
            switch (settings.name) {
              case '/':
                return VideosScreen();
              case '/folder':
                return FolderScreen();
              // return FolderScreen(path: path);
              default:
                return Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                );
            }
          },
        );
      },
    );

    // return Navigator(
    //   key: NavigationService.kVideosStack,
    //   onGenerateRoute: (RouteSettings settings) {
    //     return MaterialPageRoute(
    //       settings: settings,
    //       builder: (context) => _entryScreen(context),
    //     );
    //   },
    // );
  }

  // Scaffold _entryScreen(BuildContext context) {
  //   return Scaffold(
  //     body: CustomScrollView(
  //       slivers: <Widget>[
  //         AppBarWithFolderList(),
  //         VideoList(),
  //         VideoList(),
  //       ],
  //     ),
  //   );
  // }
}

class VideosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Videos Screen...');
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          AppBarWithFolderList(),
          VideoList(),
        ],
      ),
    );
  }
}

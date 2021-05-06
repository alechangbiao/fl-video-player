import 'package:flutter/material.dart';

import 'package:app/models/folder_info.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/videos/components/app_bar_with_folder_list.dart';
import 'package:app/screens/videos/components/sorting_selector.dart';
import 'package:app/screens/videos/components/sliver_videos.dart';
import 'package:app/widgets/buffer_background.dart';

class VideosStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  /// Get video list, folder list, parse .info file & .videos_info file
  Future<bool> _getNecessaryInfo(BuildContext context) async {
    // await Future.delayed(Duration(seconds: 2));
    List responses = await Future.wait([
      FileService().getRootPathVideosList(),
      FileService().updateRootPathFoldersList(),
      FileService().getRootPathFolderInfo(),
    ]);

    FolderInfo info = responses[2];
    print('${info.id} - info.sequence: ${info.sequence}, info.layout: ${info.layout}');
    return true;
  }

  Widget _entryScreen(BuildContext context) {
    return FutureBuilder(
      future: _getNecessaryInfo(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return CustomScrollView(
                  slivers: <Widget>[
                    AppBarWithFolderList(showFolders: true),
                    SortingSelector(),
                    SliverVideos(orientation: orientation),
                  ],
                );
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBarWithFolderList.staticAppBar(context),
            body: BufferBackground(),
          );
        }
      },
    );
  }
}

// class VideosStackNamedRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print('Building Videos Stack...');
//     return Navigator(
//       key: NavigationService.kVideosStack,
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//           settings: settings,
//           builder: (context) {
//             switch (settings.name) {
//               case '/':
//                 return VideosScreen();
//               case '/folder':
//                 return FolderScreen();
//               // return FolderScreen(path: path);
//               default:
//                 return Scaffold(
//                   body: Center(
//                     child: Text('No route defined for ${settings.name}'),
//                   ),
//                 );
//             }
//           },
//         );
//       },
//     );
//   }
// }

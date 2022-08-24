import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watcher/watcher.dart';

import 'package:app/models/folder_info.dart';
import 'package:app/models/video_info.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/videos/components/app_bar_with_folder_list.dart';
import 'package:app/screens/videos/components/sorting_selector.dart';
import 'package:app/screens/videos/components/sliver_videos.dart';
import 'package:app/widgets/buffer_background.dart';

late DirectoryWatcher directoryWatcher;

class VideosStack extends StatelessWidget {
  void _enableWatcher(String directory) {
    directoryWatcher = DirectoryWatcher(directory, pollingDelay: Duration(seconds: 1));
    print("object $directory");
    directoryWatcher.events.listen((event) {
      print(event.type);
      print(event);
    });
  }

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
    final fs = FileService();
    List responses;
    try {
      responses = await Future.wait([
        fs.getRootPathVideosList(notify: false),
        fs.updateRootPathFoldersList(),
        fs.getRootPathFolderInfo(notify: false),
        fs.getRootPathVideosInfo(notify: false),
      ]);
      FolderInfo folderInfo = responses[2];
      _printFolderInfo(info: folderInfo);

      List<VideoInfo> videosInfo = responses[3];
      _printVideoInfoList(infos: videosInfo);
    } catch (e) {
      print("e: $e");
    }

    return true;
  }

  Widget _entryScreen(BuildContext context) {
    // _enableWatcher(FileService.getRootPathStatic!);

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
                    SliverVideos(
                      orientation: orientation,
                      isRootPath: true,
                    ),
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

void _printFolderInfo({required FolderInfo info}) {
  print('''folder info:
    info.id: ${info.id}:
    info.sequence: ${info.sequence}, 
    info.layout: ${info.layout}
    ''');
}

void _printVideoInfoList({required List<VideoInfo> infos}) {
  for (VideoInfo info in infos) {
    print('''video info:
      name - ${info.name}:
      id - ${info.id},
      timeMs - ${info.timeMs},
      durationMs:${info.durationMs},
      createdAt:${info.createdAt}, 
      lastWatchedAt:${info.lastWatchedAt}
      ''');
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

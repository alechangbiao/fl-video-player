import 'package:flutter/material.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/videos/components/app_bar_with_folder_list.dart';
import 'package:app/screens/videos/components/video_list.dart';
import 'package:app/widgets/thumbnail.dart';

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

  List<Widget> _thumbnailList = <Widget>[
    Thumbnail(),
    Thumbnail(),
    Thumbnail(),
  ];

  Scaffold _entryScreen(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          AppBarWithFolderList(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _thumbnailList[index],
              childCount: _thumbnailList.length,
            ),
          ),
          VideoList(),
        ],
      ),
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

// class VideosScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print('Building Videos Screen...');
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           AppBarWithFolderList(),
//           VideoList(),
//         ],
//       ),
//     );
//   }
// }

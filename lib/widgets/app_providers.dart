import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/theme.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/services/video_player_service.dart';
import 'package:app/services/file_service.dart';
import 'package:app/data/preferences.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  AppProviders({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileService()),
        ChangeNotifierProvider(
            create: (context) =>
                AppTheme(AppPreferences().isDarkTheme ? AppTheme.dark() : AppTheme.light())),
        ChangeNotifierProvider(create: (context) => NavigationService()),
        ChangeNotifierProvider(create: (context) => AppPreferences()),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            // return VideoPlayerService.asset();
            File video = "${FileService.getRootPathSync}/Basic Theming.mp4".getFile;
            return VideoPlayerService.file(video);
          },
        )
      ],
      child: child,
    );
  }
}

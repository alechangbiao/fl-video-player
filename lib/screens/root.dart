import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/screens/videos/videos_stack.dart';
import 'package:app/screens/folders/folders_stack.dart';
import 'package:app/screens/settings/settings_stack.dart';
import 'package:app/widgets/app_bottom_navigation_bar.dart';

class Root extends StatelessWidget {
  final List<Widget> _stacks = [
    VideosStack(),
    FoldersStack(),
    SettingsStack(),
  ];

  @override
  Widget build(BuildContext context) {
    NavigationService _nav = Provider.of<NavigationService>(context);

    return WillPopScope(
      onWillPop: () async => !await _nav.currentNavigatorkey.currentState!.maybePop(),
      child: Scaffold(
        body: IndexedStack(
          index: _nav.currentTabIndex,
          children: this._stacks,
        ),
        bottomNavigationBar: AppBottomNavigationBar(),
      ),
    );
  }
}

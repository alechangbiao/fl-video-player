import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/navigation.dart';
import 'package:app/pages/videos.dart';
import 'package:app/pages/resources.dart';
import 'package:app/pages/settings.dart';
import 'package:app/widgets/tab_navigation_bar.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationProvider _nav = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async => !await _nav.currentNavigatorkey.currentState.maybePop(),
      child: Scaffold(
        body: IndexedStack(
          index: _nav.currentTabIndex,
          children: [
            Videos(navigatorKey: _nav.navigatorKeys[0]),
            Resources(navigatorKey: _nav.navigatorKeys[1]),
            Settings(navigatorKey: _nav.navigatorKeys[2])
          ],
        ),
        bottomNavigationBar: TabNavigationBar(),
      ),
    );
  }
}

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
    AppNavigation _nav = Provider.of<AppNavigation>(context);

    return WillPopScope(
      onWillPop: () async => !await _nav.currentNavigatorkey.currentState.maybePop(),
      child: Scaffold(
        body: IndexedStack(
          index: _nav.currentTabIndex,
          children: [Videos(), Resources(), Settings()],
        ),
        bottomNavigationBar: TabNavigationBar(),
      ),
    );
  }
}

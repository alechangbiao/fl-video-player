import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:app/pages/player.dart';

class Videos extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Videos({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    print('Building Video Page Stacks...');

    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return _Videos();
              case '/player':
                return Player();
            }
          },
        );
      },
    );
  }
}

class _Videos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).app_name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4.fontSize,
                color: Colors.blue,
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => Player(),
                  fullscreenDialog: true,
                ),
              ),
              child: Text('PLAY'),
            )
          ],
        ),
      ),
    );
  }
}

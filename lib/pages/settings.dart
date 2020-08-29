import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:app/pages/appearances.dart';
import 'package:app/pages/storage.dart';

class Settings extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Settings({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    print('Building Settings Root Page...');

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Settings'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).app_name,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline4.fontSize,
                      color: Colors.green,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => Appearances()));
                    },
                    child: Text('Appearances'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => Storage()));
                    },
                    child: Text('Storage'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Settings extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  _Settings({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    print('Building Settings Root Page...');

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).app_name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4.fontSize,
                color: Colors.green,
              ),
            ),
            RaisedButton(
              onPressed: () {
                // Navigator.of(context, rootNavigator: false).pushNamed('/Appearances');
                navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => Appearances()));
              },
              child: Text('Appearances'),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context, rootNavigator: false).pushNamed('/Storage'),
              child: Text('Storage'),
            )
          ],
        ),
      ),
    );
  }
}

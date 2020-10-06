import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:app/pages/appearances.dart';
import 'package:app/pages/storage.dart';
import 'package:app/services/navigation.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Settings Root Page...');

    return Navigator(
      key: AppNavigation.settingsNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return _Settings();
        },
      ),
    );
  }
}

class _Settings extends StatelessWidget {
  _Settings();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).app_name,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline4.fontSize,
            ),
          ),
          RaisedButton(
            onPressed: () {
              AppNavigation.settingsNavigatorKey.currentState
                  .push(MaterialPageRoute(builder: (context) => Appearances()));
            },
            child: Text('Appearances'),
          ),
          RaisedButton(
            onPressed: () {
              AppNavigation.settingsNavigatorKey.currentState.push(MaterialPageRoute(builder: (context) => Storage()));
            },
            child: Text('Storage'),
          ),
          SwitchListTile(
            value: true,
            title: Text("This is a SwitchPreference"),
            onChanged: (value) {},
          ),
          ListTile(
            title: Text('Enable Feature'),
            trailing: Checkbox(
              value: true,
              onChanged: (val) {
                print('onChanged');
              },
            ),
            onTap: () {
              print('onTap');
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/localization/localization.dart';
import 'package:app/screens/settings/storage.dart';
import 'package:app/services/navigation_service.dart';
import 'package:app/services/theme.dart';
import 'package:app/data/preferences.dart';

class SettingsStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Settings Stack...');
    return Navigator(
      key: NavigationService.kSettingsStack,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return _buildStack(context);
        },
      ),
    );
  }

  Widget _buildStack(BuildContext context) {
    AppPreferences _preferences = Provider.of<AppPreferences>(context);
    AppTheme _theme = Provider.of<AppTheme>(context);

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
          Divider(height: 1),
          ListTile(
            title: Text("Dark Mode"),
            trailing: Switch(
              value: _preferences.isDarkTheme,
              onChanged: (value) async {
                await _preferences.setIsDarkTheme(value);
                _theme.setTheme(theme: value ? 'dark' : 'light');
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text('Enable Feature'),
            subtitle: Text('subtitle'),
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
          Divider(height: 1),
          ListTile(
            title: Text('Enable/Disable'),
            enabled: false,
            onTap: () {
              print('onTap');
            },
          ),
          RaisedButton(
            onPressed: () {
              NavigationService.currentStackState.push(
                MaterialPageRoute(
                  builder: (context) => Storage(),
                ),
              );
            },
            child: Text('Storage'),
          ),
        ],
      ),
    );
  }
}

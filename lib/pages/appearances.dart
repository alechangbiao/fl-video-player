import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/theme.dart';

class Appearances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Appearances Page...');

    AppTheme _theme = Provider.of<AppTheme>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Appearances'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => _theme.setTheme(ThemeData.light()),
              child: Text('DEFAULT LIGHT THEME'),
            ),
            FlatButton(
              onPressed: () => _theme.setTheme(AppTheme.light()),
              child: Text('CUSTOM LIGHT THEME'),
            ),
            FlatButton(
              onPressed: () => _theme.setTheme(ThemeData.dark()),
              child: Text('DEFAULT DARK THEME'),
            ),
            FlatButton(
              onPressed: () => _theme.setTheme(AppTheme.dark()),
              child: Text('CUSTOM DARK THEME'),
            )
          ],
        ),
      ),
    );
  }
}

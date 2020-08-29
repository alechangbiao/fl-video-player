import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/theme.dart';

class Appearances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Appearances Page...');

    AppThemeProvider _theme = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Appearances'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => _theme.setTheme(ThemeData.dark()),
              child: Text('DARK THEME'),
            ),
            FlatButton(
              onPressed: () => _theme.setTheme(ThemeData.light()),
              child: Text('LIGHT THEME'),
            ),
          ],
        ),
      ),
    );
  }
}

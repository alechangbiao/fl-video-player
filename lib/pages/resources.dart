import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';

class Resources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Resources Root Page...');

    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).app_name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4.fontSize,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

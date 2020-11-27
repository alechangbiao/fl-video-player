import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/localization/localization.dart';
import 'package:app/services/theme.dart';

class MaterialAppWithLocalization extends StatelessWidget {
  final Widget home;

  MaterialAppWithLocalization({@required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V2 Player',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<AppTheme>(context).theme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('zh', ''),
      ],
      home: home,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/localization/localization.dart';
import 'package:app/services/navigation.dart';
import 'package:app/services/theme.dart';
import 'package:app/pages/root.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppThemeProvider(ThemeData.dark())),
        ChangeNotifierProvider(create: (context) => NavigationProvider())
      ],
      child: ThemeWrapper(),
    );
  }
}

class ThemeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V2 Player',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<AppThemeProvider>(context).theme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('zh', ''),
      ],
      home: Root(),
    );
  }
}

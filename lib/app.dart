import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/data/preferences.dart';
import 'package:app/localization/localization.dart';
import 'package:app/services/navigation.dart';
import 'package:app/services/theme.dart';
import 'package:app/pages/root.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null, //AppTheme.userDefault(),
      builder: (context, snapshot) {
        return ProviderWrapper(
          child: MaterialAppWithLocalization(
            home: Root(),
          ),
        );
      },
    );
  }
}

class ProviderWrapper extends StatelessWidget {
  final Widget child;

  ProviderWrapper({@required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AppPreferences.theme[AppPreferences.isDarkTheme]
                ? AppTheme(AppTheme.dark())
                : AppTheme(AppTheme.light())),
        ChangeNotifierProvider(
          create: (context) => AppNavigation(),
        )
      ],
      child: child,
    );
  }
}

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

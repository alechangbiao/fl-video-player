import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/theme.dart';

class MaterialAppWithLocalization extends StatelessWidget {
  final Widget home;

  MaterialAppWithLocalization({required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V2 Player',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<AppTheme>(context).theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}

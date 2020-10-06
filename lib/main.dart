import 'package:flutter/material.dart';
import 'package:app/app.dart';
import 'package:app/data/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppPreferences().loadAllPreferences();

  runApp(App());
}

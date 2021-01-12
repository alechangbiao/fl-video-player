import 'package:flutter/material.dart';
import 'package:app/app.dart';
import 'package:app/data/preferences.dart';
import 'package:app/services/file_service.dart';

void main() async {
  // To ensure app preference to work, call ensureInitialized()
  WidgetsFlutterBinding.ensureInitialized();

  await AppPreferences().loadAllPreferences();

  // To ensure app path is not null
  await FileService.init();

  // Prints information about gesture recognizers and gesture arenas.
  // debugPrintGestureArenaDiagnostics = true;

  runApp(App());
}

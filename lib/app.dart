import 'package:app/widgets/material_app_with_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/root.dart';
import 'package:app/widgets/app_providers.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialAppWithLocalization(
        home: Root(),
      ),
    );
  }
}

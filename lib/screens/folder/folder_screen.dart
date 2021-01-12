import 'package:flutter/material.dart';
import 'package:app/screens/folder/components/build_app_bar.dart';

class FolderScreen extends StatelessWidget {
  final String path;

  FolderScreen({
    Key key,
    @required this.path,
  }) : super(key: key) {
    print('FolderScreen was created');
    print(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
    );
  }
}

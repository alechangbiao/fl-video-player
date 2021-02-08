import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/file_service.dart';
import 'package:app/screens/folder/components/build_app_bar.dart';

// class FolderScreenArguments {
//   final String? path;

//   FolderScreenArguments({@required this.path});
// }

class FolderScreen extends StatelessWidget {
  final String path;

  FolderScreen({Key? key, required this.path}) : super(key: key) {
    print('FolderScreen created');
  }
  // FolderScreen({Key? key}) : super(key: key) {
  //   print('FolderScreen created');
  // }

  @override
  Widget build(BuildContext context) {
    // final FolderScreenArguments? args =
    //     ModalRoute.of(context)?.settings.arguments as FolderScreenArguments;

    FileService _fsProvider = Provider.of<FileService>(context);
    // _fsProvider.currentPath = args?.path;
    _fsProvider.currentPath = path;

    print(ModalRoute.of(context)!.settings.name);

    return Scaffold(
      appBar: buildAppBar(context),
    );

    // return WillPopScope(
    //   onWillPop: () async {
    //     _fsProvider.goBack();
    //     return true;
    //   },
    //   child: Scaffold(
    //     appBar: buildAppBar(context),
    //   ),
    // );
  }
}

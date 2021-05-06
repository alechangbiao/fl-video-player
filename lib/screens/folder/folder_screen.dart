import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/screens/folder/components/build_app_bar.dart';
import 'package:app/widgets/buffer_background.dart';

// class FolderScreenArguments {
//   final String? path;

//   FolderScreenArguments({@required this.path});
// }

class FolderScreen extends StatelessWidget {
  final String path;

  FolderScreen({Key? key, required this.path}) : super(key: key) {
    print('FolderScreen created');
  }

  @override
  Widget build(BuildContext context) {
    FileService _fsProvider = Provider.of<FileService>(context);
    _fsProvider.currentPath = path;

    // final FolderScreenArguments? args =
    //     ModalRoute.of(context)?.settings.arguments as FolderScreenArguments;
    // _fsProvider.currentPath = args?.path;
    // print(ModalRoute.of(context)!.settings.name);

    return Scaffold(
      appBar: buildAppBar(context),
      body: BufferBackground(),
    );
  }
}

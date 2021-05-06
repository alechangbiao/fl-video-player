import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/screens/videos/components/video_item_icon.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/screens/videos/components/video_item_cover.dart';
import 'package:app/utils/constants.dart';

class SliverVideos extends StatelessWidget {
  final Orientation orientation;
  final bool isRootPath;

  const SliverVideos({
    Key? key,
    this.isRootPath = false,
    required this.orientation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FileService _fsProvider = Provider.of<FileService>(context);

    if (_fsProvider.rootPathFolerInfo!.layout == SortingModeKey.asIcons) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.appBarActionMargin),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                VideoItemIcon(videoPath: _fsProvider.rootPathVideoFiles![index].path),
            childCount: _fsProvider.rootPathVideoFiles!.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1 / 1,
          ),
        ),
      );
    } else if (_fsProvider.rootPathFolerInfo!.layout == SortingModeKey.asCovers) {
      return SliverList(
        // Use a delegate to build items as they're scrolled on screen.
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              VideoItemCover(videoPath: _fsProvider.rootPathVideoFiles![index].path),
          childCount: _fsProvider.rootPathVideoFiles!.length,
        ),
      );
    } else {
      return Container();
    }

    // return Expanded(
    //   child: ListView(
    //     children: _itemList,
    //   ),
    // );
  }
}

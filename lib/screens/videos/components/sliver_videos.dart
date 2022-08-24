import 'dart:io';

import 'package:app/models/video_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/screens/videos/components/video_item_icon.dart';
import 'package:app/services/file_service/file_service.dart';
import 'package:app/screens/videos/components/video_item_cover.dart';
import 'package:app/screens/videos/components/video_item_list.dart';
import 'package:app/utils/constants.dart';

class SliverVideos extends StatelessWidget {
  final Orientation orientation;
  final bool isRootPath;

  const SliverVideos({
    Key? key,
    this.isRootPath = false,
    required this.orientation,
  }) : super(key: key);

  VideoInfo _getVideoInfoByName({required String videoName, required List<VideoInfo> infos}) {
    return infos.firstWhere((VideoInfo e) => e.name == videoName);
  }

  List<File> _sortingSequence({required List<File> videoFiles, required String? sequence}) {
    switch (sequence) {
      case SequenceSorterKey.name:
        videoFiles.sort((File a, File b) => a.baseName.compareTo(b.baseName));
        return videoFiles;
      case SequenceSorterKey.dateAdded:
        List<VideoInfo> infos = FileService().rootPathVideosInfo;
        videoFiles.sort((File a, File b) {
          int aDateAdded = _getVideoInfoByName(videoName: a.baseName, infos: infos).createdAt;
          int bDateAdded = _getVideoInfoByName(videoName: b.baseName, infos: infos).createdAt;
          return aDateAdded.compareTo(bDateAdded);
        });
        return videoFiles;
      case SequenceSorterKey.lastWatched:
        List<VideoInfo> infos = FileService().rootPathVideosInfo;
        List<File> newVideoFiles = [], videoFilesNeverWatched = [];
        for (File file in videoFiles) {
          VideoInfo info = _getVideoInfoByName(videoName: file.baseName, infos: infos);
          info.lastWatchedAt == null ? videoFilesNeverWatched.add(file) : newVideoFiles.add(file);
        }
        if (newVideoFiles.length > 1) {
          newVideoFiles.sort((File a, File b) {
            int aWatched = _getVideoInfoByName(videoName: a.baseName, infos: infos).lastWatchedAt!;
            int bWatched = _getVideoInfoByName(videoName: b.baseName, infos: infos).lastWatchedAt!;
            return bWatched.compareTo(aWatched);
          });
        }
        return [...newVideoFiles, ...videoFilesNeverWatched];
      default:
        return videoFiles;
    }
  }

  @override
  Widget build(BuildContext context) {
    FileService _fsProvider = Provider.of<FileService>(context);
    String? sequence = _fsProvider.rootPathFolerInfo!.sequence;
    List<File> videoFileList = _fsProvider.rootPathVideoFiles!;

    List<File> videoFileListSorted = _sortingSequence(
      videoFiles: videoFileList,
      sequence: sequence,
    );

    switch (_fsProvider.rootPathFolerInfo!.layout) {
      case LayoutSorterKey.asIcons:
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.appBarActionMargin),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => VideoItemIcon(
                key: Key(videoFileListSorted[index].path),
                videoPath: videoFileListSorted[index].path,
                isRootPath: this.isRootPath,
              ),
              childCount: _fsProvider.rootPathVideoFiles!.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 8 / 7,
            ),
          ),
        );
      case LayoutSorterKey.asCovers:
        return SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            (context, index) => VideoItemCover(
              key: Key(videoFileListSorted[index].path),
              videoPath: videoFileListSorted[index].path,
              isRootPath: this.isRootPath,
            ),
            childCount: _fsProvider.rootPathVideoFiles!.length,
          ),
        );
      case LayoutSorterKey.asList:
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.appBarActionMargin),
          sliver: SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              (context, index) => VideoItemList(
                key: Key(videoFileListSorted[index].path),
                videoPath: videoFileListSorted[index].path,
                isRootPath: this.isRootPath,
              ),
              childCount: _fsProvider.rootPathVideoFiles!.length,
            ),
          ),
        );
      default:
        return SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            (context, index) => VideoItemCover(
              key: Key(videoFileListSorted[index].path),
              videoPath: videoFileListSorted[index].path,
              isRootPath: this.isRootPath,
            ),
            childCount: _fsProvider.rootPathVideoFiles!.length,
          ),
        );
    }

    // return Expanded(
    //   child: ListView(
    //     children: _itemList,
    //   ),
    // );
  }
}

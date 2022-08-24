import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:app/services/file_service/file_service.dart';

class GenerateThumbnailImage extends StatefulWidget {
  final ThumbnailRequest? thumbnailRequest;
  final bool isSquare;

  const GenerateThumbnailImage({
    Key? key,
    this.thumbnailRequest,
    this.isSquare = false,
  }) : super(key: key);

  @override
  _GenerateThumbnailImageState createState() => _GenerateThumbnailImageState();
}

class _GenerateThumbnailImageState extends State<GenerateThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: _genThumbnail(widget.thumbnailRequest!, isSquare: widget.isSquare),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final Image _image = snapshot.data.image;
          final int _width = snapshot.data.width;
          final int _height = snapshot.data.height;
          final int _dataSize = snapshot.data.dataSize;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.isSquare
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          child: _image,
                        ),
                      ),
                    )
                  : _image,
            ],
          );
        } else if (snapshot.hasError) {
          print('snapshot hasError');
          return Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              "Error:\n${snapshot.error.toString()}",
            ),
          );
        } else {
          // print('Generating the thumbnail for: ${widget.thumbnailRequest?.video}...');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text("Generating the thumbnail for: ${widget.thumbnailRequest?.video}..."),
              SizedBox(
                height: 10.0,
              ),
              CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }
}

//----------------------------------------------------------------------

Future<ThumbnailResult> _genThumbnail(ThumbnailRequest req, {bool? isSquare}) async {
  //WidgetsFlutterBinding.ensureInitialized();

  Uint8List? bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if (req.thumbnailPath != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: req.video!,
      thumbnailPath: req.thumbnailPath,
      imageFormat: req.imageFormat!,
      maxHeight: req.maxHeight!,
      maxWidth: req.maxWidth!,
      timeMs: req.timeMs!,
      quality: req.quality!,
    );

    print("thumbnail file is located: $thumbnailPath");

    final file = thumbnailPath!.getFile;
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
      video: req.video!,
      imageFormat: req.imageFormat!,
      maxHeight: req.maxHeight!,
      maxWidth: req.maxWidth!,
      timeMs: req.timeMs!,
      quality: req.quality!,
    );
  }

  int _imageDataSize = bytes!.length;
  // print("image size: $_imageDataSize");

  Image _image = isSquare! ? Image.memory(bytes, fit: BoxFit.fitHeight) : Image.memory(bytes);
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}

//----------------------------------------------------------------------

class ThumbnailRequest {
  final String? video;
  final String? thumbnailPath;
  final ImageFormat? imageFormat;
  final int? maxHeight;
  final int? maxWidth;
  final int? timeMs;
  final int? quality;

  const ThumbnailRequest({
    this.video,
    this.thumbnailPath,
    this.imageFormat,
    this.maxHeight,
    this.maxWidth,
    this.timeMs,
    this.quality,
  });
}

class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

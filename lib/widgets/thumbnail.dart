import 'dart:async';
import 'dart:typed_data';

import 'package:app/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Thumbnail extends StatefulWidget {
  @override
  _Thumbnail createState() => _Thumbnail();
}

class _Thumbnail extends State<Thumbnail> {
  GenerateThumbnailImage? _futreImage;

  int _quality = 50;
  int _sizeH = 0;
  int _sizeW = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      final String videoFilePath = "${FileService.getRootPathSync}/Basic Theming.mp4";
      print("Basic Theming.mp4 path: $videoFilePath");
      _futreImage = GenerateThumbnailImage(
        thumbnailRequest: ThumbnailRequest(
            video: videoFilePath,
            thumbnailPath: null,
            imageFormat: ImageFormat.JPEG,
            maxHeight: _sizeH,
            maxWidth: _sizeW,
            timeMs: 200000,
            quality: _quality),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            child: (_futreImage != null) ? _futreImage! : SizedBox(),
          ),
        ),
      ],
    );
  }
}

//----------------------------------------------------------------------

//----------------------------------------------------------------------

class GenerateThumbnailImage extends StatefulWidget {
  final ThumbnailRequest? thumbnailRequest;

  const GenerateThumbnailImage({Key? key, this.thumbnailRequest}) : super(key: key);

  @override
  _GenerateThumbnailImageState createState() => _GenerateThumbnailImageState();
}

class _GenerateThumbnailImageState extends State<GenerateThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: _genThumbnail(widget.thumbnailRequest!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final _image = snapshot.data.image;
          final _width = snapshot.data.width;
          final _height = snapshot.data.height;
          final _dataSize = snapshot.data.dataSize;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                    "Image ${widget.thumbnailRequest?.thumbnailPath == null ? 'data size' : 'file size'}: $_dataSize, width:$_width, height:$_height"),
              ),
              Container(
                color: Colors.grey,
                height: 1.0,
              ),
              _image,
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              "Error:\n${snapshot.error.toString()}",
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Generating the thumbnail for: ${widget.thumbnailRequest?.video}..."),
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

Future<ThumbnailResult> _genThumbnail(ThumbnailRequest req) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if (req.thumbnailPath != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: req.video,
      thumbnailPath: req.thumbnailPath,
      imageFormat: req.imageFormat,
      maxHeight: req.maxHeight,
      maxWidth: req.maxWidth,
      timeMs: req.timeMs,
      quality: req.quality,
    );

    print("thumbnail file is located: $thumbnailPath");

    final file = thumbnailPath.getFile;
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
      video: req.video,
      imageFormat: req.imageFormat,
      maxHeight: req.maxHeight,
      maxWidth: req.maxWidth,
      timeMs: req.timeMs,
      quality: req.quality,
    );
  }

  int _imageDataSize = bytes.length;
  print("image size: $_imageDataSize");

  final _image = Image.memory(bytes);
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

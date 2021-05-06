import 'package:flutter/material.dart';

class BufferBackground extends StatelessWidget {
  const BufferBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return AspectRatio(
            aspectRatio: orientation == Orientation.portrait ? 3 / 5 : 3 / 2,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo-banner.png',
              ),
            ),
          );
        },
      ),
    );
  }
}

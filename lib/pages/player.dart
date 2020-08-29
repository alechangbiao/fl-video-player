import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building Player Page...');

    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: Text('Player'),
    );
  }
}

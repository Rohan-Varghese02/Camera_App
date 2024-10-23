import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final File image;

  const FullScreenImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}
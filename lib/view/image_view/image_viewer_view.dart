import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageViewerView extends StatelessWidget {
  final Uint8List image;
  final String name;
  const ImageViewerView(this.image, this.name,{ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(child: Center(
        child: Image.memory(image),
      )),
    );
  }
}
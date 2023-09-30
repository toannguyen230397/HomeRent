import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImage extends StatelessWidget {
  const ZoomImage({super.key, required this.Url});
  final String Url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
              child: PhotoView(
        imageProvider: NetworkImage(Url),
      ))),
    );
  }
}

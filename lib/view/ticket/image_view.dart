import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  String imageUrl;
  ImageView(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network(imageUrl)),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'constant_styles.dart';

class ImageView extends StatelessWidget {
  String imageUrl;
  int? id;
  ImageView(this.imageUrl, {this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Hero(
          tag: id ?? '',
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            loadingBuilder:
                (BuildContext context, ImageChunkEvent? loadingProgress) {
              return loadingProgressBar();
            },
            errorBuilder: (context, exception, stackTrace) {
              return const Text('Loding failed!');
            },
            imageProvider: imageUrl.contains('http')
                ? NetworkImage(imageUrl) as ImageProvider<Object>?
                //  Image.network(
                //     imageUrl,
                //     loadingBuilder: (BuildContext context, Widget child,
                //         ImageChunkEvent? loadingProgress) {
                //       if (loadingProgress == null) {
                //         return child;
                //       }
                //       return loadingProgressBar();
                //       // return Center(
                //       //   child: CircularProgressIndicator(
                //       //     value: loadingProgress.expectedTotalBytes != null
                //       //         ? loadingProgress.cumulativeBytesLoaded /
                //       //             loadingProgress.expectedTotalBytes!
                //       //         : null,
                //       //   ),
                //       // );
                //     },
                //     errorBuilder: (context, exception, stackTrace) {
                //       return const Text('Your error widget...');
                //     },
                //   )
                : FileImage(File(imageUrl)),
          )),
    ));
  }
}

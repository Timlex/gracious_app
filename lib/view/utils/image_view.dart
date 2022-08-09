import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  String imageUrl;
  int? id;
  ImageView(this.imageUrl, {this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
            tag: id as int,
            child: Image.network(
              imageUrl,
              errorBuilder: (context, exception, stackTrace) {
                return const Text('Your error widget...');
              },
            )),
      ),
    );
  }
}

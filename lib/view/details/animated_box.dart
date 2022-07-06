import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBox extends StatefulWidget {
  final String title;
  final String content;
  const AnimatedBox(this.title, this.content, {Key? key}) : super(key: key);

  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 310),
      height: expanded ? min(widget.content.length.toDouble() / 1.2, 400) : 50,
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Column(
          children: [
            Flexible(
              child: ListTile(
                  title: Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      })),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              height:
                  expanded ? min(widget.content.length.toDouble() / 3, 70) : 0,
              child: Text(widget.content),
            ),
          ],
        ),
      ),
    );
  }
}

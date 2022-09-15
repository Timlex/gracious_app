import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constant_styles.dart';
import '../../view/utils/constant_name.dart';

class AnimatedBox extends StatelessWidget {
  String title;
  bool expanded;
  Map<String, String>? data;
  void Function()? onPressed;
  AnimatedBox(this.title, this.data, this.expanded, {this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: onPressed,
            dense: false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18),
            title: Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
                icon: Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: onPressed),
          ),
          if (expanded) ...?descriptions(),
          if (expanded) const SizedBox(height: 30)
        ],
      ),
    );
  }

  List<Widget>? descriptions() {
    List<Widget> descriptionList = [];
    if (data!.keys.first == '1') {
      descriptionList = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Html(
              data: data!.values.first,
              onLinkTap: (url, _, map, e) {
                if (url != null) {
                  launchUrl(Uri.parse(url));
                }
              }),
        ),
      ];
      return descriptionList;
    }
    data!.forEach((key, value) {
      descriptionList.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: key == '1' ? 0 : screenWidth / 4,
              child: Text(
                key == '1' ? '' : '$key :',
                style: TextStyle(
                    color: cc.greyHint,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              // width: screenWidth - 156,
              child: Text(
                value,
                maxLines: 5,
                style: TextStyle(
                    color: cc.greyHint,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ));
    });
    return descriptionList;
  }
}










// import 'dart:math';
// import 'package:flutter/material.dart';

// class AnimatedBox extends StatefulWidget {
//   final String title;
//   final String content;
//   const AnimatedBox(this.title, this.content, {Key? key}) : super(key: key);

//   @override
//   State<AnimatedBox> createState() => _AnimatedBoxState();
// }

// class _AnimatedBoxState extends State<AnimatedBox> {
//   bool expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 310),
//       height: expanded ? min(widget.content.length.toDouble() / 1.2, 400) : 50,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
//         child: Column(
//           children: [
//             ListTile(
//                 title: Text(
//                   widget.title,
//                   style: const TextStyle(
//                       fontSize: 19, fontWeight: FontWeight.w600),
//                 ),
//                 trailing: IconButton(
//                     icon: Icon(
//                       expanded ? Icons.expand_less : Icons.expand_more,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         expanded = !expanded;
//                       });
//                     })),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
//               height:
//                   expanded ? min(widget.content.length.toDouble() / 3, 100) : 0,
//               constraints:
//                   expanded ? const BoxConstraints(minHeight: 70) : null,
//               child: Text(widget.content),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

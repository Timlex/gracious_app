import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class PosterCard extends StatelessWidget {
  final String title;
  final String btText;
  final String description;
  final Function btFunction;
  final String image;

  PosterCard(
    this.title,
    this.btText,
    this.description,
    this.btFunction,
    this.image,
  );

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.only(left: 20, top: 25),
      height: 15,
      width: 320,
      // color: Color.fromARGB(110, 9, 154, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          stops: [.6, 1],
          colors: [
            Color(0xffDCFFDE),
            Color.fromARGB(107, 220, 255, 222),
          ],
        ),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: cc.blackColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: 170,
                child: Text(
                  description,
                  style: TextStyle(
                    color: cc.greyParagraph,
                  ),
                )),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                btFunction;
              },
              child: Text(btText),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  elevation: 0,
                  primary: cc.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const Spacer()
          ],
        ),
        Container(height: 150, child: Image.asset(image)),
      ]),
    );
  }
}

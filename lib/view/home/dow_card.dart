import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class DODCard extends StatelessWidget {
  final String title;
  final String btText;
  final Function btFunction;
  final String image;

  DODCard(
    this.title,
    this.btText,
    this.btFunction,
    this.image,
  );

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.only(left: 20, top: 25),
      height: 150,
      width: 280,
      // color: Color.fromARGB(110, 9, 154, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cc.lightPrimery2,
      ),

      child: Stack(children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deal of the Day',
                    style: TextStyle(
                      color: cc.orange,
                      fontSize: 15,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    // width: 100,
                    child: Text(
                      title,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      style: TextStyle(
                        color: cc.blackColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      btFunction;
                    },
                    child: Text(btText),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 21,
                          vertical: 11,
                        ),
                        elevation: 0,
                        primary: cc.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const Spacer()
                ],
              ),
            ]),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
              height: 125,
              margin: EdgeInsets.only(right: 3),
              child: Image.asset(image)),
        ),
      ]),
    );
  }
}

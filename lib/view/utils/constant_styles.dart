import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

ConstantColors cc = ConstantColors();

Widget textFieldTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    margin: const EdgeInsets.only(top: 17),
    child: Text(
      title,
      style: TextStyle(
        color: ConstantColors().greytitle,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget customContainerButton(
    String buttonTitle, double? buttonWidth, Function ontapFunction) {
  return GestureDetector(
      onTap: () {
        ontapFunction();
      },
      child: Container(
        height: 57,
        width: buttonWidth,
        margin: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ConstantColors().primaryColor,
        ),
        child: Text(
          buttonTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ConstantColors().pureWhite, fontWeight: FontWeight.bold),
        ),
      ));
}

Widget containerBorder(String imagePath, String text) {
  return Container(
    height: 44,
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 7),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: ConstantColors().greyBorder,
        width: 1,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25,
          child: Image.asset(imagePath),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(color: ConstantColors().greyParagraph),
        )
      ],
    ),
  );
}

Widget customIconButton(
  String iconTitle,
  String iconName, {
  double padding = 8.0,
}) {
  return GestureDetector(
    onTap: () {
      print('$iconTitle has been tapped');
    },
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: SvgPicture.asset(
        'assets/images/icons/$iconName',
        height: 27,
        color: Colors.black54,
      ),
    ),
  );
}

PreferredSizeWidget helloAppBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: ConstantColors().pureWhite,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: TextStyle(color: ConstantColors().greyHint, fontSize: 12),
            ),
            Text(
              'Robert',
              style: TextStyle(
                  color: ConstantColors().titleTexts,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
    actions: [
      customIconButton('notificationIcon', 'notification_bing.svg',
          padding: 10),
      const SizedBox(
        width: 17,
      )
    ],
  );
}

Widget seeAllTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        SizedBox(
            child: Row(children: [
          TextButton(
            onPressed: () {},
            child: Text('See All',
                textAlign: TextAlign.end,
                style: TextStyle(color: cc.primaryColor, fontSize: 14)),
          ),
          // const Icon(
          //   Icons.arrow_forward_ios,
          //   size: 18,
          // )
        ]))
      ],
    ),
  );
}

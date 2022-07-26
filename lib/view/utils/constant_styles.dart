import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

ConstantColors cc = ConstantColors();

Widget textFieldTitle(String title, {double fontSize = 15}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    margin: const EdgeInsets.only(top: 17),
    child: Text(
      title,
      style: TextStyle(
        color: ConstantColors().greytitle,
        fontSize: fontSize,
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
        height: 50,
        width: buttonWidth ?? double.infinity,
        // margin: const EdgeInsets.symmetric(vertical: 15),
        // margin: EdgeInsets.all(8),
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

Widget customBorderButton(String buttonText, Function ontap,
    {double width = 180}) {
  return GestureDetector(
    onTap: () {
      ontap();
    },
    child: Container(
        // margin: const EdgeInsets.all(8),
        height: 50,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: ConstantColors().primaryColor,
          ),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ConstantColors().primaryColor,
              fontWeight: FontWeight.w700),
        )),
  );
}

Widget containerBorder(String imagePath, String text,
    {double widht = double.infinity}) {
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
    // actions: [
    //   customIconButton('notificationIcon', 'notification_bing.svg',
    //       padding: 10),
    //   const SizedBox(
    //     width: 17,
    //   )
    // ],
  );
}

Widget favoriteIcon(bool isFavorite,
    {double size = 15, required void Function()? onPressed}) {
  return Container(
    margin: const EdgeInsets.only(top: 9, right: 5),
    child: CircleAvatar(
      radius: size,
      backgroundColor: cc.pureWhite,
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          'assets/images/icons/${isFavorite ? 'red_heart' : 'grey_heart'}.svg',
          height: 20,
        ),
      ),
    ),
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

Widget discAmountRow(double discountAmount, double amount) {
  return Row(
    children: [
      Text(
        '\$${discountAmount <= 0 ? amount.toString() : discountAmount.toStringAsFixed(2)}',
        style: TextStyle(
            color: cc.primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
      ),
      const SizedBox(width: 4),
      Text(
        '\$${amount.toStringAsFixed(2)}',
        style: TextStyle(
            color: cc.cardGreyHint,
            decoration: TextDecoration.lineThrough,
            decorationColor: cc.cardGreyHint,
            fontSize: 11),
      ),
    ],
  );
}

Widget customRowButton(
  String buttonText1,
  String buttonText2,
  Function ontap,
  Function ontap2,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      //skip Button

      customBorderButton(buttonText1, ontap, width: (screenWidth - 45) / 2),

      //continue button

      customContainerButton(buttonText2, (screenWidth - 45) / 2, ontap2)
    ],
  );
}

SnackBar snackBar(String content,
    {String buttonText = '', void Function()? onTap}) {
  return SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5),
      backgroundColor: cc.orange,
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          Text(
            content,
          ),
          const Spacer(),
          if (buttonText == '')
            GestureDetector(
              child: Text(buttonText),
              onTap: onTap,
            )
        ],
      ));
}

Widget loadingProgressBar() {
  return Center(
      child: SpinKitRotatingCircle(
    size: 50,
    color: cc.primaryColor,
  ));
}

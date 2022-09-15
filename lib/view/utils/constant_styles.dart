import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import '../../service/common_service.dart';
import '../../view/home/all_products.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../service/search_result_data_service.dart';

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
    String buttonTitle, double? buttonWidth, Function ontapFunction,
    {Color? color}) {
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
          color: color ?? ConstantColors().primaryColor,
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

Widget customIconButton(String iconTitle, String iconName,
    {double padding = 8.0, void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
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

PreferredSizeWidget helloAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: ConstantColors().pureWhite,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: GestureDetector(
        onTap: () {
          Provider.of<NavigationBarHelperService>(context, listen: false)
              .setNavigationIndex(4);
        },
        child: SizedBox(
          height: 100,
          // width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style:
                    TextStyle(color: ConstantColors().greyHint, fontSize: 12),
              ),
              Consumer<UserProfileService>(builder: (context, uService, child) {
                return Text(
                  uService.userProfileData.name == null
                      ? ''
                      : uService.userProfileData.name,
                  style: TextStyle(
                      color: ConstantColors().titleTexts,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                );
              }),
            ],
          ),
        ),
      ),
    ),
    actions: [
      Consumer<UserProfileService>(
        builder: (context, uService, child) {
          return GestureDetector(
            onTap: (() =>
                Provider.of<NavigationBarHelperService>(context, listen: false)
                    .setNavigationIndex(4)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CircleAvatar(
                backgroundColor:
                    uService.userProfileData.profileImageUrl == null
                        ? cc.primaryColor
                        : null,
                child: uService.userProfileData.profileImageUrl == null
                    ? Text(
                        uService.userProfileData.name
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(
                            color: cc.pureWhite, fontWeight: FontWeight.bold),
                      )
                    : null,
                backgroundImage:
                    uService.userProfileData.profileImageUrl != null
                        ? NetworkImage(
                            uService.userProfileData.profileImageUrl as String)
                        : null,
              ),
            ),
          );
        },
      )
    ],
  );
}

Widget favoriteIcon(bool isFavorite,
    {double size = 15, required void Function()? onPressed}) {
  return Container(
    margin: const EdgeInsets.only(top: 9, right: 5, left: 5),
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

Widget seeAllTitle(BuildContext context, String title,
    {void Function()? onPressed}) {
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
            onPressed: onPressed,
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

Widget discAmountRow(int discountAmount, int amount) {
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
  BuildContext context,
  String buttonText1,
  String buttonText2,
  Function ontap,
  Function ontap2,
) {
  initiateDeviceSize(context);
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

snackBar(BuildContext context, String content,
    {String? buttonText, void Function()? onTap, Color? backgroundColor}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

      // width: screenWidth - 100,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5),
      backgroundColor: backgroundColor ?? cc.primaryColor,
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          Text(
            content,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (buttonText != null)
            GestureDetector(
              child: Text(buttonText),
              onTap: onTap,
            )
        ],
      )));
}

Widget loadingProgressBar({Color? color, double size = 35}) {
  return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
    size: size,
    color: color ?? cc.primaryColor,
  ));
}

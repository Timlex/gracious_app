import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class AppBars {
  ConstantColors cc = ConstantColors();

  PreferredSizeWidget appBarTitled(String? title, Function ontap,
      {bool hasButton = true,
      bool hasElevation = true,
      List<Widget>? actions = null}) {
    return AppBar(
        elevation: hasElevation ? 1 : 0,
        foregroundColor: cc.blackColor,
        centerTitle: true,
        title: title == null
            ? null
            : Text(
                title,
                style: TextStyle(
                    color: cc.blackColor, fontWeight: FontWeight.w600),
              ),
        leading: GestureDetector(
          onTap: () => ontap(),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(
              'assets/images/icons/back_button.svg',
              color: cc.blackColor,
              height: 25,
            ),
          ]),
        ),
        actions: actions);
  }
}

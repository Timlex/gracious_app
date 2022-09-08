import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../service/common_service.dart';
import '../../view/utils/constant_colors.dart';

class AppBars {
  ConstantColors cc = ConstantColors();

  PreferredSizeWidget appBarTitled(String? title, Function ontap,
      {bool hasButton = true,
      bool hasElevation = true,
      bool? centerTitle = true,
      List<Widget>? actions}) {
    return AppBar(
        elevation: hasElevation ? 1 : 0,
        foregroundColor: cc.blackColor,
        centerTitle: centerTitle,
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
            Transform(
              transform: rtl ? Matrix4.rotationY(pi) : Matrix4.rotationY(0),
              child: SvgPicture.asset(
                'assets/images/icons/back_button.svg',
                color: cc.blackColor,
                height: 25,
              ),
            ),
          ]),
        ),
        actions: actions);
  }
}

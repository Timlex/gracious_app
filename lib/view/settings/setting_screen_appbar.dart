import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

class SettingScreenAppBar extends StatelessWidget {
  String image;
  SettingScreenAppBar(this.image, {Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHight / 3,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: screenHight / 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: cc.greyYellow,
              // boxShadow: const [
              //   BoxShadow(
              //       color: Colors.grey,
              //       blurRadius: 4,
              //       spreadRadius: 2,
              //       blurStyle: BlurStyle.normal)
              // ],
            ),
          ),
          Positioned(
            top: screenHight / 6,
            right: screenWidth / 2.9,
            child: CircleAvatar(
              backgroundColor: cc.greyYellow,
              radius: screenWidth / 6.5,
              backgroundImage: NetworkImage(
                image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

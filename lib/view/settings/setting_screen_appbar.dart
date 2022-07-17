import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class SettingScreenAppBar extends StatelessWidget {
  SettingScreenAppBar({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
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
            top: 135,
            right: MediaQuery.of(context).size.width / 2.9,
            child: CircleAvatar(
              backgroundColor: cc.greyYellow,
              radius: 60,
              child: Image.asset(
                'assets/images/setting_dp.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

import '../auth/custom_text_field.dart';
import '../intro/custom_dropdown.dart';
import '../utils/constant_styles.dart';

class ManageAccount extends StatelessWidget {
  static const routeName = 'manage account';
  ManageAccount({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('Manage Account', () {
        Navigator.of(context).pop();
      }, hasButton: true),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              width: 155,
              child: Stack(alignment: Alignment.center, children: [
                CircleAvatar(
                  backgroundColor: cc.greyYellow,
                  radius: 70,
                  child: Image.asset(
                    'assets/images/setting_dp.png',
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/images/icons/camera.svg',
                      height: 45,
                    ))
              ]),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textFieldTitle('Name'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter name',
                      emailController,
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('User name'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter user name',
                      emailController,
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('Email'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter email address',
                      emailController,
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('City'),
                    // const SizedBox(height: 8),
                    CustomDropdown('Bangladesh'),
                  ]),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: customContainerButton('Save Changes', double.infinity, () {
              Navigator.of(context).pop();
            }),
          ),
          const SizedBox(height: 45)
        ],
      ),
    );
  }
}

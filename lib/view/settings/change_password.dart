import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

import '../auth/custom_text_field.dart';
import '../intro/custom_dropdown.dart';
import '../utils/constant_styles.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = 'change password';
  ChangePassword({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('Change Password', () {
        Navigator.of(context).pop();
      }, hasButton: true),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textFieldTitle('Current password'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter current password',
                      emailController,
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('New password'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter new password',
                      emailController,
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('Re enter new password'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Re enter new password',
                      emailController,
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                  ]),
            ),
          ),
          const Spacer(),
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

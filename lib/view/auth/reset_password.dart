import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/enter_otp.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

import '../utils/constant_styles.dart';
import 'custom_text_field.dart';

class ResetPassEmail extends StatelessWidget {
  static const routeName = 'reset password email';
  ResetPassEmail({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled(null, () {
        Navigator.of(context).pop();
      }, hasElevation: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHight / 4.7,
                ),
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cc.titleTexts,
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  'Enter the email you used to creat account and we’ll send instruction for restting password',
                  style: TextStyle(
                    fontSize: 14,
                    color: ConstantColors().greyParagraph,
                  ),
                ),
                const SizedBox(height: 10),
                textFieldTitle('Enter email'),
                CustomTextField(
                  'Email',
                  controller: TextEditingController(),
                  leadingImage: 'assets/images/icons/mail.png',
                ),
                const SizedBox(height: 25),
                customContainerButton('Send OTP', double.infinity, () {
                  Navigator.of(context).pushNamed(EnterOTP.routeName);
                })
              ]),
        ),
      ),
    );
  }
}

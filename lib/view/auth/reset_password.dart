import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.titleTexts,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the email you used to creat account and we’ll send instruction for restting password',
                style: TextStyle(
                  fontSize: 13,
                  color: ConstantColors().greyParagraph,
                ),
              ),
              textFieldTitle('Username'),
              CustomTextField(
                'Enter email',
                TextEditingController(),
                leadingImage: 'assets/images/icons/mail.png',
              ),
              const SizedBox(height: 25),
              customContainerButton('Send OTP', double.infinity, () {})
            ]),
      ),
    );
  }
}

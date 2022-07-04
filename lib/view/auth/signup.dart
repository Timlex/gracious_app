import 'package:flutter/material.dart';

import '../utils/constant_colors.dart';
import '../utils/constant_styles.dart';
import 'custom_text_field.dart';

class SignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        Container(
          height: 56,
          width: double.infinity,
          // margin: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ConstantColors().greyBorder,
              width: 1,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bangladesh',
                  style: TextStyle(
                    color: ConstantColors().greyTextFieldLebel,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: ConstantColors().greyFour,
                    ))
              ],
            ),
          ),
        ),
        textFieldTitle('Password'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Enter password',
          emailController,
          // imagePath: 'assets/images/icons/password.png',
        ),
        textFieldTitle('Confirm Password'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Re enter password',
          emailController,
          // imagePath: 'assets/images/icons/password.png',
        ),
      ]),
    );
  }
}

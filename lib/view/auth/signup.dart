import 'package:flutter/material.dart';
import 'package:gren_mart/view/intro/custom_dropdown.dart';

import '../utils/constant_colors.dart';
import '../utils/constant_styles.dart';
import 'custom_text_field.dart';

class SignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  String city = 'Bangladesh';
  List citys = [
    'Bangladesh',
    'Japan',
    'Korea',
    'Africa',
  ];

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
        CustomDropdown(city),
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

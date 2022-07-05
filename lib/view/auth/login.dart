import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';

import '../utils/constant_styles.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        textFieldTitle('Username'),
        // const SizedBox(height: 3),
        CustomTextField(
          'Email',
          emailController,
          leadingImage: 'assets/images/icons/mail.png',
        ),
        textFieldTitle('Password'),
        // const SizedBox(height: 3),
        CustomTextField(
          'Password',
          emailController,
          leadingImage: 'assets/images/icons/password.png',
          trailing: true,
          obscureText: true,
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gren_mart/view/intro/custom_dropdown.dart';

import '../utils/constant_styles.dart';
import 'custom_text_field.dart';

class SignUp extends StatelessWidget {
  final TextEditingController _nameController;
  final TextEditingController _userNameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final _userNameFN = FocusNode();
  final _emailFN = FocusNode();
  final _reFN = FocusNode();
  String city = 'Dhaka';
  String country = 'Bangladesh';
  List countrys = [
    'Bangladesh',
    'Japan',
    'Korea',
    'Africa',
  ];
  List citys = [
    'Dhaka',
    'Tokyo',
    'Saul',
    'Beijing',
  ];

  SignUp(
    this._nameController,
    this._userNameController,
    this._emailController,
    this._passwordController,
    this.city, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        textFieldTitle('Name'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Enter name',
          controller: _nameController,
          validator: (emailText) {
            if (emailText!.isEmpty) {
              return 'Enter your name';
            }
            if (emailText.length <= 2) {
              return 'Enter a valid name';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_userNameFN);
          },
        ),
        textFieldTitle('User name'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Enter user name',
          controller: _userNameController,
          focusNode: _userNameFN,
          validator: (emailText) {
            if (emailText!.isEmpty) {
              return 'Enter your userName';
            }
            if (emailText.length <= 5) {
              return 'Enter at least 5 charecters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFN);
          },
        ),
        textFieldTitle('Email'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Enter email address',
          controller: _emailController,
          focusNode: _emailFN,
          validator: (emailText) {
            if (emailText!.isEmpty) {
              return 'Enter your email';
            }
            if (emailText.length <= 5) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        textFieldTitle('City'),
        // const SizedBox(height: 8),
        CustomDropdown(
          city: city,
        ),
        textFieldTitle('Country'),
        // const SizedBox(height: 8),
        CustomDropdown(country: country),
        textFieldTitle('Password'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Enter password',
          controller: _passwordController,
          validator: (emailText) {
            if (emailText!.isEmpty) {
              return 'Enter at least 6 charechters';
            }
            if (emailText.length <= 5) {
              return 'Enter at least 6 charechters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_reFN);
          },
        ),
        textFieldTitle('Confirm Password'),
        // const SizedBox(height: 8),
        CustomTextField(
          'Re enter password',
          controller: _passwordController,
          focusNode: _reFN,
          validator: (emailText) {
            if (emailText == _passwordController.text) {
              return 'Enter the same password';
            }
            return null;
          },
          onFieldSubmitted: (_) {},
        ),
      ]),
    );
  }
}

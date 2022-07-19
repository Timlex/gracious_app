import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

import '../../model/user_data.dart';
import '../auth/custom_text_field.dart';
import '../home/home_front.dart';
import '../intro/custom_dropdown.dart';
import '../utils/constant_styles.dart';

class NewAddress extends StatefulWidget {
  static const routeName = 'new address';
  NewAddress({Key? key}) : super(key: key);

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reFN = FocusNode();
  final _userNameFN = FocusNode();
  final _emailFN = FocusNode();
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

  void _onSubmit(String name, String userName, String email, String city) {
    Navigator.of(context).pushReplacementNamed(HomeFront.routeName);

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(snackBar('Invalid email/password'));
  }

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
                    textFieldTitle('Phone'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter your phone number',
                      controller: _userNameController,
                      focusNode: _userNameFN,
                      validator: (emailText) {
                        if (emailText!.isEmpty) {
                          return 'Enter your phone number';
                        }
                        if (emailText.length <= 5) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFN);
                      },
                    ),
                    textFieldTitle('City'),
                    // const SizedBox(height: 8),
                    CustomDropdown(city: city),
                    textFieldTitle('Country'),
                    // const SizedBox(height: 8),
                    CustomDropdown(country: country),
                    textFieldTitle('Zip code'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter your Zip code',
                      controller: _passwordController,
                      validator: (emailText) {
                        // if (emailText!.isEmpty) {
                        //   return 'Enter at least 6 charechters';
                        // }
                        // if (emailText.length <= 5) {
                        //   return 'Enter at least 6 charechters';
                        // }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_reFN);
                      },
                    ),
                    textFieldTitle('Address'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter your address',
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
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: customContainerButton('Save Changes', double.infinity, () {
              final validated = _formKey.currentState!.validate();
              if (!validated) {
                return;
              }
              Navigator.of(context).pop();
            }),
          ),
          const SizedBox(height: 45)
        ],
      ),
    );
  }
}
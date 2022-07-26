import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/user_data.dart';
import '../auth/custom_text_field.dart';
import '../home/home_front.dart';
import '../utils/constant_styles.dart';

class ManageAccount extends StatefulWidget {
  static const routeName = 'manage account';
  ManageAccount({Key? key}) : super(key: key);

  var user = UsersData(
    'carmeron123',
    '11111111',
    'Cameron Williamson',
    'cameron@cameron.com',
    'BanglaDesh',
  );

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userNameFN = FocusNode();
  final _emailFN = FocusNode();
  String? country;
  List<String> countris = [];
  File? _pickedImage;

  Future<void> imageSelectorGallery() async {
    try {
      final pickedImage =
          await ImagePicker.platform.pickImage(source: ImageSource.camera);
      final tempImage = pickedImage;
      _pickedImage = File(pickedImage!.path);
    } catch (error) {
      print(error);
    }

    setState(() {});
  }

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
                  backgroundImage: _pickedImage == null
                      ? const AssetImage(
                          'assets/images/setting_dp.png',
                        )
                      : FileImage(_pickedImage!) as ImageProvider<Object>,
                  //     _pickedImage!,
                  //     fit: BoxFit.cover,
                  //   ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        imageSelectorGallery();
                      },
                      child: SvgPicture.asset(
                        'assets/images/icons/camera.svg',
                        height: 45,
                      ),
                    ))
              ]),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
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
                        if (emailText.length <= 3) {
                          return 'Enter a valid email/username';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_userNameFN);
                      },
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('User name'),
                    // const SizedBox(height: 8),
                    CustomTextField(
                      'Enter user name',
                      controller: _userNameController,
                      focusNode: _userNameFN,
                      validator: (emailText) {
                        if (emailText!.isEmpty) {
                          return 'Enter your username';
                        }
                        if (emailText.length < 5) {
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
                      validator: (emailText) {
                        if (emailText!.isEmpty) {
                          return 'Enter your email';
                        }
                        if (emailText.length <= 5) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      // imagePath: 'assets/images/icons/mail.png',
                    ),
                    textFieldTitle('City'),
                    // const SizedBox(height: 8),
                    // CustomDropdown('city:'),
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

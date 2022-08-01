import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/service/auth_text_controller_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/user_data.dart';
import '../../service/country_dropdown_service.dart';
import '../../service/state_dropdown_service.dart';
import '../auth/custom_text_field.dart';
import '../home/home_front.dart';
import '../intro/custom_dropdown.dart';
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
      body: Consumer<UserProfileService>(builder: (context, uData, child) {
        return ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 155,
                child: Stack(alignment: Alignment.center, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: _pickedImage == null
                        ? CachedNetworkImage(
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            imageUrl: uData.userProfileData.profileImageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/skelleton.png',
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.file(
                            _pickedImage!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                  ),
                  // CircleAvatar(
                  //   backgroundColor: cc.greyYellow,
                  //   radius: 70,
                  //   backgroundImage:  (uData.userProfileData.profileImageUrl != null
                  //           ? NetworkImage(
                  //               uData.userProfileData.profileImageUrl,
                  //             )
                  //           : const AssetImage('assets/images/setting_dp.png')
                  //               as ImageProvider<Object>)
                  //       ,
                  //     _pickedImage!,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
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
                        'Enter name', initialValue: uData.userProfileData.name,
                        validator: (nameText) {
                          if (nameText!.isEmpty) {
                            return 'Enter your name';
                          }
                          if (nameText.length <= 3) {
                            return 'Enter a valid email/username';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_userNameFN);
                        },
                        onChanged: (value) {
                          Provider.of<AuthTextControllerService>(context,
                                  listen: false)
                              .setName(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('User name'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter user name',
                        initialValue: uData.userProfileData.username,
                        focusNode: _userNameFN,
                        validator: (usernameText) {
                          if (usernameText!.isEmpty) {
                            return 'Enter your username';
                          }
                          if (usernameText.length < 5) {
                            return 'Enter at least 5 charecters';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFN);
                        },
                        onChanged: (value) {
                          Provider.of<AuthTextControllerService>(context,
                                  listen: false)
                              .setUserName(value);
                        },
                      ),
                      textFieldTitle('Email'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter email address',
                        initialValue: uData.userProfileData.address,
                        validator: (emailText) {
                          if (emailText!.isEmpty) {
                            return 'Enter your email';
                          }
                          if (emailText.length <= 5) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          Provider.of<AuthTextControllerService>(context,
                                  listen: false)
                              .setEmail(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),

                      textFieldTitle('Country'),
                      // const SizedBox(height: 8),
                      Consumer<CountryDropdownService>(
                        builder: (context, cProvider, child) => cProvider
                                .countryDropdownList.isNotEmpty
                            ? CustomDropdown(
                                'Country',
                                cProvider.countryDropdownList,
                                (newValue) {
                                  cProvider.setCountryIdAndValue(newValue);
                                  Provider.of<StateDropdownService>(context,
                                          listen: false)
                                      .getStates(cProvider.selectedCountryId);
                                },
                                value: cProvider.selectedCountry,
                              )
                            : SizedBox(
                                height: 10,
                                child: Center(
                                  child: FittedBox(
                                    child: CircularProgressIndicator(
                                      color: cc.greyHint,
                                    ),
                                  ),
                                )),
                      ),
                      textFieldTitle('State'),
                      Consumer<StateDropdownService>(
                          builder: ((context, sModel, child) =>
                              // sModel.stateDropdownList.isEmpty
                              //     ? SizedBox(
                              //         child: Center(
                              //             child: CircularProgressIndicator(
                              //         color: cc.greyHint,
                              //       )))
                              //     :
                              (sModel.isLoading
                                  ? SizedBox(
                                      height: 10,
                                      child: Center(
                                        child: FittedBox(
                                          child: CircularProgressIndicator(
                                            color: cc.greyHint,
                                          ),
                                        ),
                                      ))
                                  : CustomDropdown(
                                      'State',
                                      sModel.stateDropdownList,
                                      (newValue) {
                                        sModel.setStateIdAndValue(newValue);
                                      },
                                      value: sModel.selectedState,
                                    )))),
                      textFieldTitle('City'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter your address',
                        initialValue: uData.userProfileData.address,
                        validator: (cityText) {
                          if (cityText!.isEmpty) {
                            return 'Enter your address';
                          }
                          if (cityText.length <= 5) {
                            return 'Enter a valid address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          Provider.of<AuthTextControllerService>(context,
                                  listen: false)
                              .setName(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
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
        );
      }),
    );
  }
}

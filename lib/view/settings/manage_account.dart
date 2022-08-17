import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../service/manage_account_service.dart';
import '../../service/signin_signup_service.dart';
import '../../service/user_profile_service.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../service/country_dropdown_service.dart';
import '../../service/state_dropdown_service.dart';
import '../auth/custom_text_field.dart';
import '../intro/custom_dropdown.dart';
import '../utils/constant_styles.dart';
import '../utils/image_view.dart';

class ManageAccount extends StatelessWidget {
  static const routeName = 'manage account';
  ManageAccount({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _userNameFN = FocusNode();
  final _emailFN = FocusNode();

  Future<void> imageSelector(BuildContext context,
      {ImageSource imageSource = ImageSource.camera}) async {
    try {
      final pickedImage =
          await ImagePicker.platform.pickImage(source: imageSource);
      Provider.of<ManageAccountService>(context, listen: false)
          .setPickedImage(File(pickedImage!.path));
    } catch (error) {
      print(error);
    }
  }

  Future _onSubmit(BuildContext context, ManageAccountService maData) async {
    final validated = _formKey.currentState!.validate();
    if (!validated) {
      return;
    }
    maData.setIsLoading(true);
    final _token =
        Provider.of<SignInSignUpService>(context, listen: false).token;
    maData.updateProfile(_token).then((value) async {
      if (value != null) {
        snackBar(context, value);
        maData.setIsLoading(false);
        return;
      }
      await Provider.of<UserProfileService>(context, listen: false)
          .fetchProfileService(_token);
      maData.setIsLoading(false);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    Provider.of<ManageAccountService>(context, listen: false).setInitialValue(
      userData.name,
      userData.email,
      userData.phone,
      userData.country.id.toString(),
      userData.state == null ? '1' : userData.state!.id.toString(),
      userData.city,
      userData.zipcode,
      userData.address,
      userData.profileImageUrl,
    );
    return Scaffold(
      appBar: AppBars().appBarTitled('Manage Account', () {
        Provider.of<ManageAccountService>(context, listen: false)
            .clearPickedImage();
        Navigator.of(context).pop();
      }, hasButton: true),
      body: Consumer<ManageAccountService>(builder: (context, maData, child) {
        return ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: screenWidth / 2.7,
                child: Stack(alignment: Alignment.center, children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) => ImageView(
                          maData.pickeImage != null
                              ? maData.pickeImage!.path
                              : maData.imgUrl as String,
                        ),
                      ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: maData.pickeImage == null
                          ? CachedNetworkImage(
                              height: screenHight / 5.5,
                              width: screenHight / 5.5,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              imageUrl: maData.imgUrl ?? '',
                              placeholder: (context, url) => Image.asset(
                                'assets/images/skelleton.png',
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/skelleton.png',
                              ),
                            )
                          : Image.file(
                              maData.pickeImage!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
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
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: const Text('Select an option.'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (() => imageSelector(context)
                                              .then((value) =>
                                                  Navigator.of(context).pop())),
                                          child: SizedBox(
                                            // width: screenWidth / 6,
                                            child: Row(children: [
                                              SvgPicture.asset(
                                                'assets/images/icons/camera.svg',
                                                height: 45,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                'Cameta',
                                                style: TextStyle(
                                                    color:
                                                        cc.greyTextFieldLebel),
                                              )
                                            ]),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: (() => imageSelector(context,
                                                  imageSource:
                                                      ImageSource.gallery)
                                              .then((value) =>
                                                  Navigator.of(context).pop())),
                                          child: SizedBox(
                                            // width: screenWidth / 6,
                                            child: Row(children: [
                                              Icon(
                                                Icons.image_outlined,
                                                size: 45,
                                                color: cc.primaryColor,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                'Gallery',
                                                style: TextStyle(
                                                    color:
                                                        cc.greyTextFieldLebel),
                                              )
                                            ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  )));
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
                        'Enter name', initialValue: maData.name,
                        validator: (nameText) {
                          if (nameText!.isEmpty) {
                            return 'Enter your name';
                          }
                          if (nameText.length <= 3) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_userNameFN);
                        },
                        onChanged: (value) {
                          maData.setName(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      // textFieldTitle('User name'),
                      // // const SizedBox(height: 8),
                      // CustomTextField(
                      //   'Enter user name',
                      //   initialValue: uData.userProfileData.username,
                      //   focusNode: _userNameFN,
                      //   validator: (usernameText) {
                      //     if (usernameText!.isEmpty) {
                      //       return 'Enter your username';
                      //     }
                      //     if (usernameText.length < 5) {
                      //       return 'Enter at least 5 charecters';
                      //     }
                      //     return null;
                      //   },
                      //   onFieldSubmitted: (_) {
                      //     FocusScope.of(context).requestFocus(_emailFN);
                      //   },
                      //   onChanged: (value) {
                      //     Provider.of<AuthTextControllerService>(context,
                      //             listen: false)
                      //         .setUserName(value);
                      //   },
                      // ),
                      textFieldTitle('Email'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter email address',
                        initialValue: maData.email,
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
                          maData.setEmail(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('Phone Number'),
                      IntlPhoneField(
                        style: TextStyle(color: cc.greyHint, fontSize: 13),
                        keyboardType: TextInputType.number,
                        initialValue: maData.phoneNumber,
                        initialCountryCode: maData.countryCode,
                        decoration: InputDecoration(
                          hintText: 'Enter your number',
                          hintStyle: TextStyle(
                              color: cc.greyTextFieldLebel, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 17),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: cc.greyHint, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: cc.primaryColor, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: cc.greyBorder, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: cc.orange, width: 1),
                          ),
                        ),
                        onChanged: (phone) {
                          maData.setPhoneNumber(phone.number);
                          print(phone.completeNumber);
                        },
                        onCountryChanged: (country) {
                          maData.setCountryCode(country.code);
                          print('Country changed to: ' + country.code);
                        },
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
                                  maData.setCountryID(
                                      cProvider.selectedCountry.toString());
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
                                        maData.setStateId(
                                            sModel.selectedStateId.toString());
                                      },
                                      value: sModel.selectedState,
                                    )))),
                      textFieldTitle('City'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter your city',
                        initialValue: maData.city,
                        // validator: (cityText) {
                        //   if (cityText!.isEmpty) {
                        //     return 'Enter your address';
                        //   }
                        //   if (cityText.length <= 5) {
                        //     return 'Enter a valid address';
                        //   }
                        //   return null;
                        // },
                        onChanged: (value) {
                          maData.setCity(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('Zip code'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter zip code',
                        initialValue: maData.zipCode,
                        keyboardType: TextInputType.number,
                        // validator: (zipCode) {
                        //   return null;

                        //   // if (cityText!.isEmpty) {
                        //   //   return 'Enter your address';
                        //   // }
                        //   // if (cityText.length <= 5) {
                        //   //   return 'Enter a valid address';
                        //   // }
                        //   // return null;
                        // },
                        onChanged: (value) {
                          maData.setZipCode(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('Address'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter your address',
                        initialValue: maData.address,

                        onChanged: (value) {
                          maData.setAddress(value);
                        },
                        onFieldSubmitted: (value) {
                          _onSubmit(context, maData);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Stack(
                  children: [
                    customContainerButton(
                        maData.isLoading ? '' : 'Save Changes',
                        double.infinity,
                        maData.isLoading
                            ? () {}
                            : () {
                                _onSubmit(context, maData);
                              }),
                    if (maData.isLoading)
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Center(
                              child: loadingProgressBar(
                                  size: 30, color: cc.pureWhite)))
                  ],
                )),
            const SizedBox(height: 45)
          ],
        );
      }),
    );
  }
}

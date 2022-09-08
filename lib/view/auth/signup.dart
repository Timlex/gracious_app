import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/web_view.dart';
import '../../service/auth_text_controller_service.dart';
import '../../service/country_dropdown_service.dart';
import '../../service/signin_signup_service.dart';
import '../../view/intro/custom_dropdown.dart';
import '../../view/utils/constant_name.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../service/state_dropdown_service.dart';
import '../utils/constant_styles.dart';
import 'custom_text_field.dart';

class SignUp extends StatelessWidget {
  final _userNameFN = FocusNode();
  final _emailFN = FocusNode();
  final _passFN = FocusNode();
  final _rePassFN = FocusNode();
  final Key _formkey;

  SignUp(
    this._formkey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthTextControllerService>(
        builder: (context, authController, child) {
      return Form(
        key: _formkey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          textFieldTitle('Name'),
          // const SizedBox(height: 8),
          CustomTextField(
            'Enter name',
            validator: (nameText) {
              if (nameText!.isEmpty) {
                return 'Enter your name';
              }
              if (nameText.length <= 2) {
                return 'Enter a valid name';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_userNameFN);
            },
            onChanged: (name) {
              authController.setName(name);
            },
          ),
          textFieldTitle('User name'),
          // const SizedBox(height: 8),
          CustomTextField(
            'Enter user name',
            focusNode: _userNameFN,
            validator: (ussernameText) {
              if (ussernameText!.isEmpty) {
                return 'Enter your userName';
              }
              if (ussernameText.contains(' ')) {
                return 'Enter username without space.';
              }
              if (ussernameText.length <= 5) {
                return 'Enter at least 5 charecters';
              }
              return null;
            },
            onChanged: (username) {
              authController.setUserName(username);
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailFN);
            },
          ),
          textFieldTitle('Email'),
          // const SizedBox(height: 8),
          CustomTextField(
            'Enter email address',
            focusNode: _emailFN,
            validator: (emaiText) {
              if (emaiText!.isEmpty) {
                return 'Enter your email';
              }
              if (emaiText.length <= 5) {
                return 'Enter a valid email';
              }
              return null;
            },
            onChanged: (email) {
              authController.setEmail(email);
            },
          ),
          textFieldTitle('Phone Number'),
          IntlPhoneField(
            style: TextStyle(color: cc.blackColor, fontSize: 15),
            initialCountryCode: 'BD',
            decoration: InputDecoration(
              hintText: 'Enter your number',
              hintStyle: TextStyle(color: cc.greyTextFieldLebel, fontSize: 13),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cc.greyHint, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cc.primaryColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cc.greyBorder, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cc.orange, width: 1),
              ),
            ),
            onChanged: (phone) {
              authController.setPhoneNumber(phone.completeNumber);
              print(authController.phoneNumber);
            },
            onCountryChanged: (country) {
              authController.setCountryCode(country.code);
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
                      Provider.of<StateDropdownService>(context, listen: false)
                          .getStates(cProvider.selectedCountryId);
                      authController.setCountry(newValue);
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
                            authController.setState(newValue);
                          },
                          value: sModel.selectedState,
                        )))),
          textFieldTitle('City'),
          // const SizedBox(height: 8),
          CustomTextField(
            'City',
            validator: (cityText) {
              if (cityText!.isEmpty) {
                return 'Enter at least 6 charechters';
              }
              if (cityText.length <= 5) {
                return 'Enter at least 6 charechters';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passFN);
            },
            onChanged: (city) {
              authController.setCityAddress(city);
            },
          ),
          textFieldTitle('Password'),
          CustomTextField(
            'Enter password',
            focusNode: _passFN,
            keyboardType: TextInputType.number,
            validator: (password) {
              if (password!.isEmpty) {
                return 'Enter at least 6 charechters';
              }
              if (password.length <= 5) {
                return 'Enter at least 6 charechters';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_rePassFN);
            },
            onChanged: (pass) {
              authController.setPass(pass);
            },
          ),
          textFieldTitle('Confirm Password'),
          // const SizedBox(height: 8),
          CustomTextField(
            'Re enter password',
            focusNode: _rePassFN,
            keyboardType: TextInputType.number,
            validator: (password) {
              if (password != authController.password) {
                return 'Enter the same password';
              }
              return null;
            },
            onFieldSubmitted: (_) {},
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Transform.scale(
                scale: 1.3,
                child: Checkbox(

                    // splashRadius: 30,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      width: 1,
                      color: cc.greyBorder,
                    ),
                    activeColor: cc.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          width: 1,
                          color: cc.greyBorder,
                        )),
                    value:
                        Provider.of<SignInSignUpService>(context).termsAndCondi,
                    onChanged: (value) {
                      Provider.of<SignInSignUpService>(context, listen: false)
                          .toggleTermsAndCondi();
                    }),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: screenWidth - 85,
                child: FittedBox(
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                        text: 'Accept all',
                        style: TextStyle(
                          color: cc.greyHint,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).pushNamed(
                                        WebViewScreen.routeName,
                                        arguments: [
                                          'https://zahid.xgenious.com/grenmart-api/terms-and-conditions'
                                        ]),
                              text: ' Terms and Conditions',
                              style: TextStyle(color: cc.primaryColor)),
                          TextSpan(
                              text: ' & ',
                              style: TextStyle(color: cc.greyHint)),
                          TextSpan(
                              text: ' Privacy Policy',
                              style: TextStyle(color: cc.primaryColor)),
                        ]),
                  ),
                ),
              ),
            ],
          )
        ]),
      );
    });
  }
}

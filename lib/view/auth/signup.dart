import 'package:flutter/material.dart';
import 'package:gren_mart/service/auth_text_controller_service.dart';
import 'package:gren_mart/service/country_dropdown_service.dart';
import 'package:gren_mart/view/intro/custom_dropdown.dart';
import 'package:provider/provider.dart';

import '../../service/state_dropdown_service.dart';
import '../utils/constant_styles.dart';
import 'custom_text_field.dart';

class SignUp extends StatelessWidget {
  final _userNameFN = FocusNode();
  final _emailFN = FocusNode();
  final _passFN = FocusNode();
  final _rePassFN = FocusNode();

  SignUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthTextControllerService>(
        builder: (context, authController, child) {
      return Form(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          textFieldTitle('Name'),
          // const SizedBox(height: 8),
          CustomTextField(
            'Enter name',
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
            onChanged: (name) {
              authController.setName(name);
            },
          ),
          textFieldTitle('User name'),
          // const SizedBox(height: 8),
          CustomTextField(
            'Enter user name',
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
            validator: (emailText) {
              if (emailText!.isEmpty) {
                return 'Enter your email';
              }
              if (emailText.length <= 5) {
                return 'Enter a valid email';
              }
              return null;
            },
            onChanged: (email) {
              authController.setEmail(email);
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
            validator: (password) {
              if (password == authController.password) {
                return 'Enter the same password';
              }
              return null;
            },
            onFieldSubmitted: (_) {},
          ),
        ]),
      );
    });
  }
}

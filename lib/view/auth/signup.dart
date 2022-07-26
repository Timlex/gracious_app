import 'package:flutter/material.dart';
import 'package:gren_mart/service/country_dropdown_service.dart';
import 'package:gren_mart/view/intro/custom_dropdown.dart';
import 'package:provider/provider.dart';

import '../../service/state_dropdown_service.dart';
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

  SignUp(
    this._nameController,
    this._userNameController,
    this._emailController,
    this._passwordController, {
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

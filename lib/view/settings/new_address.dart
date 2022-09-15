import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../auth/custom_text_field.dart';
import '../intro/custom_dropdown.dart';
import '../utils/constant_styles.dart';
import '../../view/utils/text_themes.dart';
import '../../service/shipping_addresses_service.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import '../../service/country_dropdown_service.dart';
import '../../service/state_dropdown_service.dart';

class AddNewAddress extends StatelessWidget {
  static const routeName = 'add new address';
  AddNewAddress({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailFN = FocusNode();
  final _phonelFN = FocusNode();
  final _cityFN = FocusNode();
  final _zipCodeFN = FocusNode();
  final _addressFN = FocusNode();

  Future _onSubmit(
      BuildContext context, ShippingAddressesService saData) async {
    final validated = _formKey.currentState!.validate();
    if (!validated || saData.phone == null) {
      return;
    }
    saData.setIsLoading(true);
    saData.addShippingAddress().then((value) {
      if (value == null) {
        saData.fetchUsersShippingAddress(context);
        Navigator.of(context).pop();
        saData.setIsLoading(false);
        return;
      }
      snackBar(context, value);
      saData.setIsLoading(false);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CountryDropdownService>(context, listen: false)
        .getContries(context);
    return Scaffold(
      appBar: AppBars().appBarTitled('Add New Address', () {
        Navigator.of(context).pop();
      }, hasButton: true),
      body:
          Consumer<ShippingAddressesService>(builder: (context, saData, child) {
        return ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(height: 30),
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
                        validator: (nameText) {
                          if (nameText!.isEmpty) {
                            return 'Enter address name';
                          }
                          if (nameText.length <= 3) {
                            return 'Enter more then 3 charecter';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFN);
                        },
                        onChanged: (value) {
                          saData.setName(value);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
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
                          if (!emailText.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          saData.setEmail(value);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phonelFN);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('Phone Number'),
                      IntlPhoneField(
                        focusNode: _phonelFN,
                        style: TextThemeConstrants.greyHint13,
                        keyboardType: TextInputType.number,
                        initialCountryCode: 'BD',
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
                          saData.setPhone(phone.number);
                          print(phone.number);
                        },
                        onCountryChanged: (country) {
                          saData.setCountryCode(country.code);
                          print('Country changed to: ' + country.code);
                        },
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_cityFN);
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
                                  saData.setCountryId(
                                      cProvider.selectedCountryId.toString());
                                  Provider.of<StateDropdownService>(context,
                                          listen: false)
                                      .getStates(cProvider.selectedCountryId)
                                      .then((value) {
                                    saData.setStateId(
                                        Provider.of<StateDropdownService>(
                                                context,
                                                listen: false)
                                            .selectedStateId
                                            .toString());
                                  });
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
                                        saData.setStateId(
                                            sModel.selectedStateId.toString());
                                      },
                                      value: sModel.selectedState,
                                    )))),
                      textFieldTitle('City'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter your city',
                        validator: (cityText) {
                          if (cityText!.isEmpty) {
                            return 'Enter your city';
                          }
                          if (cityText.length <= 2) {
                            return 'Enter a valid city';
                          }
                          return null;
                        },
                        focusNode: _cityFN,
                        onChanged: (value) {
                          saData.setCity(value);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_zipCodeFN);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('Zip code'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter zip code',
                        focusNode: _zipCodeFN,
                        keyboardType: TextInputType.number,
                        validator: (zipCode) {
                          if (zipCode!.isEmpty) {
                            return 'Enter your zip conde';
                          }
                          if (zipCode.length <= 3) {
                            return 'Enter a valid zip code';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          saData.setZipCode(value);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_addressFN);
                        },
                        // imagePath: 'assets/images/icons/mail.png',
                      ),
                      textFieldTitle('Address'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter your address',
                        focusNode: _addressFN,
                        validator: (address) {
                          if (address == null) {
                            return 'Enter your address.';
                          }
                          if (address.length <= 5) {
                            return 'Enter a valid address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          saData.setAddress(value);
                        },
                        onFieldSubmitted: (value) {
                          _onSubmit(context, saData);
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
                        saData.isLoading ? '' : 'Add Address',
                        double.infinity,
                        saData.isLoading
                            ? () {}
                            : () {
                                FocusScope.of(context).unfocus();
                                _onSubmit(context, saData);
                              }),
                    if (saData.isLoading)
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

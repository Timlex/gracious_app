import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import '../../service/change_password_service.dart';
import '../../service/signin_signup_service.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../auth/custom_text_field.dart';
import '../utils/constant_styles.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = 'change password';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final _nPFN = FocusNode();
  final _reFN = FocusNode();

  Future _onSubmit(BuildContext context, ChangePasswordService cpData) async {
    final valide = _formKey.currentState!.validate();
    if (!valide) {
      return;
    }
    cpData.toggPassleLaodingSpinner(value: true);
    cpData
        .changePassword(cpData.currentPass, cpData.newPass,
            Provider.of<SignInSignUpService>(context, listen: false).token)
        .then((value) {
      if (value != null) {
        print(value);
        snackBar(context, value ?? '');
        cpData.toggPassleLaodingSpinner(value: false);
        return;
      }
      cpData.toggPassleLaodingSpinner(value: false);
      Navigator.of(context).pop();
    }).onError((error, stackTrace) {
      cpData.toggPassleLaodingSpinner(value: false);
      snackBar(context, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars()
          .appBarTitled(context, asProvider.getString('Change Password'), () {
        Navigator.of(context).pop();
      }, hasButton: true),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Consumer<ChangePasswordService>(
                  builder: (context, cpData, child) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textFieldTitle(
                                    asProvider.getString('Current password')),
                                // const SizedBox(height: 8),
                                CustomTextField(
                                  asProvider
                                      .getString('Enter current password'),
                                  validator: (cPass) {
                                    if (cPass!.isEmpty) {
                                      return asProvider.getString(
                                          'Enter at least 6 characters');
                                    }
                                    if (cPass.length <= 5) {
                                      return asProvider.getString(
                                          'Enter at least 6 characters');
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    cpData.setCurrentPass(value);
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(_nPFN);
                                  },
                                ),
                                textFieldTitle(
                                    asProvider.getString('New password')),
                                // const SizedBox(height: 8),
                                CustomTextField(
                                  asProvider.getString('Enter new password'),
                                  focusNode: _nPFN,
                                  validator: (nPass) {
                                    if (nPass!.isEmpty) {
                                      return asProvider.getString(
                                          'Enter at least 6 characters');
                                    }
                                    if (nPass.length <= 5) {
                                      return asProvider.getString(
                                          'Enter at least 6 characters');
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    cpData.setNewPass(value);
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(_reFN);
                                  },
                                ),
                                textFieldTitle(asProvider
                                    .getString('Re enter new password')),
                                // const SizedBox(height: 8),
                                CustomTextField(
                                  asProvider.getString('Re enter new password'),
                                  focusNode: _reFN,
                                  validator: (nPass) {
                                    if (nPass != cpData.newPass) {
                                      return asProvider
                                          .getString('Enter the same password');
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    _onSubmit(context, cpData);
                                  },
                                ),
                              ]),
                        )),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Stack(
                        children: [
                          customContainerButton(
                              cpData.changePassLoading
                                  ? ''
                                  : asProvider.getString('Save Changes'),
                              double.infinity,
                              cpData.changePassLoading
                                  ? () {}
                                  : () async {
                                      await _onSubmit(context, cpData);
                                    }),
                          if (cpData.changePassLoading)
                            SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Center(
                                    child: loadingProgressBar(
                                        size: 30, color: cc.pureWhite)))
                        ],
                      ),
                    ),
                    const SizedBox(height: 45)
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}

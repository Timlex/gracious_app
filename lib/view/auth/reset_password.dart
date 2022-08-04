import 'package:flutter/material.dart';
import 'package:gren_mart/service/auth_text_controller_service.dart';
import 'package:gren_mart/service/reset_pass_otp_service.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../auth/custom_text_field.dart';
import '../utils/constant_styles.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = 'reset password';
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  ConstantColors cc = ConstantColors();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _newPasswordController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nPFN = FocusNode();
  final _reFN = FocusNode();

  @override
  Widget build(
    BuildContext context,
  ) {
    Future _onSubmit(BuildContext context) async {
      final valid = _formKey.currentState!.validate();
      if (!valid) {
        Provider.of<ResetPassOTPService>(context, listen: false)
            .toggPassleLaodingSpinner(value: false);
        return;
      }
      await Provider.of<ResetPassOTPService>(context, listen: false)
          .resetPassword(
              Provider.of<AuthTextControllerService>(context, listen: false)
                  .email,
              Provider.of<AuthTextControllerService>(context, listen: false)
                  .password)
          .then((value) {
        if (value == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Auth()),
              (Route<dynamic> route) => false);
          return;
        }
        snackBar(context, value);
        return;
      }).onError((error, stackTrace) {
        snackBar(context, error.toString());
        return;
      });
    }

    return Scaffold(
      appBar: AppBars().appBarTitled('Reset Password', () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Auth()),
            (Route<dynamic> route) => false);
      }, hasButton: true),
      body: Consumer<ResetPassOTPService>(builder: (context, resetData, child) {
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
                      textFieldTitle('New password'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Enter new password',
                        focusNode: _nPFN,
                        validator: (password) {
                          if (password!.isEmpty) {
                            return 'Enter at least 6 charechters';
                          }
                          if (password.length <= 5) {
                            return 'Enter at least 6 charechters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          Provider.of<AuthTextControllerService>(context,
                                  listen: false)
                              .setPass(value);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_reFN);
                        },
                      ),
                      textFieldTitle('Re enter new password'),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        'Re enter new password',
                        focusNode: _reFN,
                        validator: (password) {
                          if (password == _passwordController.text) {
                            return 'Enter the same password';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) async {
                          Provider.of<ResetPassOTPService>(context,
                                  listen: false)
                              .toggPassleLaodingSpinner(value: true);
                          await _onSubmit(context);
                          Provider.of<ResetPassOTPService>(context,
                                  listen: false)
                              .toggPassleLaodingSpinner(value: false);
                        },
                      ),
                    ]),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                children: [
                  customContainerButton(
                      resetData.changePassLoading ? '' : 'Save Changes',
                      double.infinity,
                      resetData.changePassLoading
                          ? () {}
                          : () async {
                              Provider.of<ResetPassOTPService>(context,
                                      listen: false)
                                  .toggPassleLaodingSpinner(value: true);
                              await _onSubmit(context);
                              Provider.of<ResetPassOTPService>(context,
                                      listen: false)
                                  .toggPassleLaodingSpinner(value: false);
                            }),
                  if (resetData.changePassLoading)
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
    );
  }
}

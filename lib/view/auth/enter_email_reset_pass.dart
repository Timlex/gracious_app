import 'package:flutter/material.dart';
import '../../service/auth_text_controller_service.dart';
import '../../service/reset_pass_otp_service.dart';
import '../../view/auth/enter_otp.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';
import '../utils/text_themes.dart';
import 'custom_text_field.dart';

class ResetPassEmail extends StatelessWidget {
  static const routeName = 'reset password email';
  ResetPassEmail({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  Future _sendRequest(
      BuildContext context, ResetPassOTPService resetData, String value) async {
    resetData.toggleLaodingSpinner(value: true);
    await resetData.getOtp(value).then((value) {
      resetData.toggleLaodingSpinner(value: true);
      if (value) {
        Navigator.of(context).pushNamed(EnterOTP.routeName);
        return;
      }
      snackBar(context, value.toString());
      return;
    }).onError((error, stackTrace) {
      snackBar(context, 'Something Went Wrong');
    });
    resetData.toggleLaodingSpinner(value: false);
  }

  @override
  Widget build(BuildContext context) {
    initiateDeviceSize(context);
    return Scaffold(
      appBar: AppBars().appBarTitled(null, () {
        Navigator.of(context).pop();
      }, hasElevation: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Consumer<ResetPassOTPService>(
              builder: (context, resetData, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHight / 4.7,
                  ),
                  Text(
                    'Reset Password',
                    style: TextThemeConstrants.titleText,
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Enter the email you used to creat account and we\'ll send instruction for resetting password',
                    style: TextStyle(
                      fontSize: 14,
                      color: ConstantColors().greyParagraph,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textFieldTitle('Enter email'),
                  CustomTextField(
                    'Email',
                    onChanged: (value) {
                      Provider.of<AuthTextControllerService>(context,
                              listen: false)
                          .setEmail(value);
                    },
                    onFieldSubmitted: (value) async {
                      _sendRequest(context, resetData, value);
                    },
                    leadingImage: 'assets/images/icons/mail.png',
                  ),
                  const SizedBox(height: 25),
                  Stack(
                    children: [
                      customContainerButton(
                          resetData.isLoading ? '' : 'Send OTP',
                          double.infinity,
                          resetData.isLoading
                              ? () {}
                              : () async {
                                  final value =
                                      Provider.of<AuthTextControllerService>(
                                              context,
                                              listen: false)
                                          .email;
                                  _sendRequest(context, resetData, value);
                                }),
                      if (resetData.isLoading)
                        SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                                child: loadingProgressBar(
                                    size: 30, color: cc.pureWhite)))
                    ],
                  )
                ]);
          }),
        ),
      ),
    );
  }
}

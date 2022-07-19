import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/auth.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:pinput/pinput.dart';

import '../home/home_front.dart';
import '../utils/constant_colors.dart';
import '../utils/constant_styles.dart';

class EnterOTP extends StatelessWidget {
  static const routeName = 'confirm OTP';
  EnterOTP({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 85,
      height: 56,
      textStyle: TextStyle(
        fontSize: 17,
        color: cc.greyParagraph,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: cc.greyBorder),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: cc.primaryColor),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBars().appBarTitled(null, () {
        Navigator.of(context).pop();
      }, hasElevation: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: screenHight / 20),
            Center(
              child: SizedBox(
                height: 90,
                child: Image.asset('assets/images/email.png'),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cc.titleTexts,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Enter the 4 digit code we sent to to your email in order to reset password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: cc.greyParagraph,
                ),
              ),
            ),
            const SizedBox(height: 20),
            otpPinput(defaultPinTheme, focusedPinTheme, context),
            const SizedBox(height: 35),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Didn\'t received?',
                  style: TextStyle(
                    fontSize: 13,
                    color: ConstantColors().greyParagraph,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        onEnter: (event) {},
                        text: 'Send again',
                        style: TextStyle(
                            color: cc.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Pinput otpPinput(PinTheme defaultPinTheme, PinTheme focusedPinTheme,
      BuildContext context) {
    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      validator: (s) {
        if (s == '2222') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Auth()),
              (Route<dynamic> route) => false);
          return;
        }

        // _scaffoldKey.currentState!.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(
            snackBar('Wrong OTP Code', buttonText: 'Resend code', onTap: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }));

        return;
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => print(pin),
    );
  }
}

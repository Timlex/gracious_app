import 'package:flutter/material.dart';
import 'package:gren_mart/service/auth_text_controller_service.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/service/signin_signup_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/auth/horizontal_devider.dart';
import 'package:gren_mart/view/auth/login.dart';
import 'package:gren_mart/view/auth/remember.dart';
import 'package:gren_mart/view/auth/enter_email_reset_pass.dart';
import 'package:gren_mart/view/auth/signup.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../service/country_dropdown_service.dart';
import '../../service/state_dropdown_service.dart';
import '../utils/constant_styles.dart';

class Auth extends StatelessWidget {
  static const routeName = 'auth';

  Auth({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();
  final GlobalKey<FormState> _formKeySignin = GlobalKey();
  final GlobalKey<FormState> _formKeySignup = GlobalKey();
  final String _email = '';
  var email;
  List<String> contries = [];

  void _toggleLogin() {
    // setState(() {
    //   login = !login;
    // });
  }

  Future<void> _onSubmit(
      BuildContext context, bool login, GlobalKey<FormState> formKey) async {
    final validated = formKey.currentState!.validate();
    if (!validated) {
      return;
    }

    if (login) {
      var email =
          (Provider.of<AuthTextControllerService>(context, listen: false)
              .email);
      var pass = (Provider.of<AuthTextControllerService>(context, listen: false)
          .password);
      if (email == null) {
        email = Provider.of<SignInSignUpService>(context, listen: false).email;
        pass =
            Provider.of<SignInSignUpService>(context, listen: false).password;
      }
      Provider.of<NavigationBarHelperService>(context, listen: false)
          .setNavigationIndex(0);
      await Provider.of<SignInSignUpService>(context, listen: false)
          .signInOption(email.trim(), pass)
          .then((value) async {
        if (value) {
          await Provider.of<UserProfileService>(context, listen: false)
              .fetchProfileService(
                  Provider.of<SignInSignUpService>(context, listen: false)
                      .token);

          Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
          return;
        }
        Provider.of<SignInSignUpService>(context, listen: false)
            .toggleLaodingSpinner(value: false);

        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar('SomeThing went wrong'));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(error.toString()));
        print(error.toString());
      });
      return;
    }
    if (!(Provider.of<SignInSignUpService>(context, listen: false)
        .termsAndCondi)) {
      ScaffoldMessenger.of(context).showSnackBar(
          snackBar('Please read and accept the terms and condition'));

      return;
    }
    Provider.of<SignInSignUpService>(context, listen: false)
        .signUpOption(
            Provider.of<AuthTextControllerService>(context, listen: false)
                .email,
            Provider.of<AuthTextControllerService>(context, listen: false)
                .password,
            Provider.of<AuthTextControllerService>(context, listen: false).name,
            Provider.of<AuthTextControllerService>(context, listen: false)
                .username,
            Provider.of<AuthTextControllerService>(context, listen: false)
                .phoneNumber,
            Provider.of<AuthTextControllerService>(context, listen: false)
                .countryCode,
            (Provider.of<AuthTextControllerService>(context, listen: false)
                        .country ??
                    1)
                .toString(),
            (Provider.of<AuthTextControllerService>(context, listen: false)
                        .state ??
                    1)
                .toString(),
            Provider.of<AuthTextControllerService>(context, listen: false)
                .cityAddress,
            'true')
        .then((value) async {
      if (value) {
        await Provider.of<UserProfileService>(context, listen: false)
            .fetchProfileService(
                Provider.of<SignInSignUpService>(context, listen: false).token);

        Navigator.of(context).pushReplacementNamed(HomeFront.routeName);

        return;
      }
      // setState(() {
      //   loading = !loading;
      // });
      Provider.of<SignInSignUpService>(context, listen: false)
          .toggleLaodingSpinner();

      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('SomeThing went wrong'));
    }).onError((error, stackTrace) {
      Provider.of<SignInSignUpService>(context, listen: false)
          .toggleLaodingSpinner(value: false);
      ScaffoldMessenger.of(context).showSnackBar(snackBar(error.toString()));
      return;
    });
    Provider.of<SignInSignUpService>(context, listen: false)
        .toggleLaodingSpinner();

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(snackBar('Invalid email/password'));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CountryDropdownService>(context, listen: false)
        .getContries()
        .then((value) {
      Provider.of<AuthTextControllerService>(context, listen: false)
          .setCountry(value ?? 1);
      Provider.of<StateDropdownService>(context, listen: false)
          .getStates(value ?? 1)
          .then((value) =>
              Provider.of<AuthTextControllerService>(context, listen: false)
                  .setState(value ?? 1));
    });
    return Scaffold(
      body: Consumer<SignInSignUpService>(builder: (context, ssData, child) {
        return SingleChildScrollView(
          child: ListView(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  height: 230,
                  // padding:
                  //     EdgeInsets.only(top: MediaQuery.of(context).padding.top - 20),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color(0xffE3FFE5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            spreadRadius: 2,
                            blurStyle: BlurStyle.normal)
                      ]),
                  child:
                      // Stack(children: [
                      //   Positioned(
                      //       top: 17,
                      //       left: 7,
                      //       child: IconButton(
                      //           onPressed: () {
                      //             print('back button tapped');
                      //           },
                      //           icon: Image.asset(
                      //               'assets/images/icons/back_button_auth.png'))),
                      Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: SizedBox(
                        height: 230,
                        child: Image.asset('assets/images/auth_image.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    ssData.login ? 'Welcome back' : 'Register to join us',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: cc.titleTexts,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ssData.login
                        ? Login(
                            _formKeySignin,
                            () {
                              _onSubmit(context, ssData.login, _formKeySignin);
                            },
                            initialPass: ssData.password,
                            initialemail: ssData.email,
                          )
                        : SignUp(_formKeySignup)),
                const SizedBox(height: 10),
                Consumer<SignInSignUpService>(
                    builder: (context, ssData, child) {
                  return ssData.login
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 30,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RememberBox(ssData.rememberPass,
                                        (value) {
                                      ssData.toggleRememberPass(value);
                                    }),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(ResetPassEmail.routeName);
                                    },
                                    child: RichText(
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.end,
                                      softWrap: true,
                                      maxLines: 1,
                                      text: TextSpan(
                                        text: 'Forgot password?',
                                        style: TextStyle(
                                          color: cc.titleTexts,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : const SizedBox();
                }),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    children: [
                      customContainerButton(
                        ssData.isLoading
                            ? ''
                            : (ssData.login ? 'Log in' : 'Sign up'),
                        double.infinity,
                        ssData.login
                            ? () {
                                ssData.toggleLaodingSpinner();
                                _onSubmit(
                                    context, ssData.login, _formKeySignin);

                                ssData.toggleLaodingSpinner();
                              }
                            : () {
                                ssData.toggleLaodingSpinner();
                                _onSubmit(
                                    context, ssData.login, _formKeySignup);

                                ssData.toggleLaodingSpinner();
                                // Navigator.of(context)
                                //     .pushReplacementNamed(HomeFront.routeName);
                              },
                      ),
                      if (ssData.isLoading)
                        SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                                child: loadingProgressBar(
                                    size: 30, color: cc.pureWhite)))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ssData.login
                            ? 'Don\'t have an account?'
                            : 'Already have an account?',
                        style: TextStyle(color: cc.greyParagraph),
                      ),
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: GestureDetector(
                          onTap: () {
                            ssData.toggleSigninSignup();
                          },
                          child: RichText(
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.end,
                            softWrap: true,
                            maxLines: 1,
                            text: TextSpan(
                              text: ssData.login ? 'Register' : 'Log In',
                              style: TextStyle(
                                color: cc.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: HorizontalDivider(),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: containerBorder(
                      'assets/images/icons/google.png',
                      ssData.login
                          ? 'Log in with Google'
                          : 'Signup with Google'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: containerBorder(
                      'assets/images/icons/facebook.png',
                      ssData.login
                          ? 'Log in with Facebook'
                          : 'Signup with Facebook'),
                ),
                const SizedBox(
                  height: 25,
                )
              ]),
        );
      }),
    );
  }
}

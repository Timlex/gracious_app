import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/horizontal_devider.dart';
import 'package:gren_mart/view/auth/login.dart';
import 'package:gren_mart/view/auth/remember.dart';
import 'package:gren_mart/view/auth/reset_password.dart';
import 'package:gren_mart/view/auth/signup.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

import '../utils/constant_styles.dart';

class Auth extends StatefulWidget {
  static const routeName = 'auth';

  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  ConstantColors cc = ConstantColors();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '';
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  String city = 'Dhaka';
  bool login = true;

  bool rememberPass = false;

  void _toggleLogin() {
    setState(() {
      login = !login;
    });
  }

  void _toggleRemember(bool value) {
    setState(() {
      rememberPass = !rememberPass;
    });
  }

  void _onSubmit() {
    final validated = _formKey.currentState!.validate();
    if (!validated) {
      return;
    }
    if (_emailController.text == '11111111' &&
        _passController.text == '11111111') {
      Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar('Invalid email/password'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(250, 250),
        child: Container(
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
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  height: 230,
                  child: Image.asset('assets/images/auth_image.png'),
                ),
              ),
            )
            // ]),
            ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                const SizedBox(height: 35),
                Text(
                  login ? 'Welcome back' : 'Register to join us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cc.titleTexts,
                  ),
                ),
                const SizedBox(height: 15),
                login
                    ? Login(_formKey, _email, _passController, _onSubmit,
                        _emailController)
                    : SignUp(
                        _nameController,
                        _userNameController,
                        _emailController,
                        _passController,
                        city,
                      ),
                const SizedBox(height: 10),
                if (login)
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            child: RememberBox(
                              rememberPass,
                              _toggleRemember,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ResetPassEmail.routeName);
                              print('something!');
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
                const SizedBox(height: 10),
                customContainerButton(
                    login ? 'Log in' : 'Sign up',
                    double.infinity,
                    login
                        ? _onSubmit
                        : () {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeFront.routeName);
                          }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      login
                          ? 'Don\'t have an account?'
                          : 'Already have an account?',
                      style: TextStyle(color: cc.greyParagraph),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: _toggleLogin,
                      child: RichText(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.end,
                        softWrap: true,
                        maxLines: 1,
                        text: TextSpan(
                          text: login ? 'Register' : 'Log In',
                          style: TextStyle(
                            color: cc.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const HorizontalDivider(),
                const SizedBox(height: 25),
                containerBorder(
                    'assets/images/icons/google.png', 'Log in with Google'),
                containerBorder(
                    'assets/images/icons/facebook.png', 'Log in with Facebook'),
                const SizedBox(
                  height: 25,
                )
              ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';

import '../utils/constant_styles.dart';

class Login extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  String _emailText;
  final TextEditingController _passController;
  final TextEditingController _emailController;
  Function onSave;
  Login(this._formKey, this._emailText, this._passController, this.onSave,
      this._emailController,
      {Key? key})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _passFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        textFieldTitle('Username'),
        const SizedBox(height: 3),
        CustomTextField(
          'Email',
          controller: widget._emailController,
          leadingImage: 'assets/images/icons/mail.png',
          validator: (emailText) {
            if (emailText!.isEmpty) {
              return 'Enter your email/username';
            }
            if (emailText.length <= 5) {
              return 'Enter a valid email/username';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            widget._emailText = _;
            FocusScope.of(context).requestFocus(_passFN);
          },
          onChanged: (emailText) {
            widget._emailText = emailText;
          },
        ),
        textFieldTitle('Password'),
        CustomTextField(
          'Password',
          controller: widget._passController,
          focusNode: _passFN,
          leadingImage: 'assets/images/icons/password.png',
          trailing: true,
          obscureText: true,
          validator: (pass) {
            if (pass == null || pass.length < 6) {
              return 'Password must be at least 6 digit.';
            }
            return null;
          },
          onFieldSubmitted: (_) => widget.onSave(),
        ),
      ]),
    );
  }
}
